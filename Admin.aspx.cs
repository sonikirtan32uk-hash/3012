using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin : System.Web.UI.Page
{
    private const string AdminSessionKey = "AdminAuthenticated";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsAdminAuthenticated())
        {
            Response.Redirect("AdminLogin.aspx");
            return;
        }

        if (!IsPostBack)
        {
            BindDashboard();
        }
    }

    private bool IsAdminAuthenticated()
    {
        return Session[AdminSessionKey] != null && (bool)Session[AdminSessionKey];
    }

    private void BindDashboard()
    {
        BindProducts();
        BindOrders();
        BindReviews();
        BindMetrics();
    }

    private void BindMetrics()
    {
        List<Product> products = CatalogRepository.GetAll();
        List<OrderRecord> orders = OrderRepository.GetAll();
        List<ReviewRecord> reviews = ReviewRepository.GetAll();
        lblTotalProducts.Text = products.Count.ToString();
        lblTotalOrders.Text = orders.Count.ToString();
        lblDeliveredOrders.Text = orders.Count(o => String.Equals(o.DeliveryStatus, "Delivered", StringComparison.OrdinalIgnoreCase)).ToString();
        lblRevenue.Text = "Rs. " + orders.Sum(o => o.TotalAmount).ToString("0.##");
        lblAverageOrderValue.Text = orders.Count == 0 ? "Rs. 0" : "Rs. " + orders.Average(o => o.TotalAmount).ToString("0.##");
        lblReviewCount.Text = reviews.Count.ToString();
        BindPaymentMix(orders);
        BindTopProducts(orders);
        BindRatingMix(reviews);
    }

    private void BindPaymentMix(List<OrderRecord> orders)
    {
        rptPaymentMix.DataSource = orders
            .GroupBy(o => String.IsNullOrWhiteSpace(o.PaymentMethod) ? "Unknown" : o.PaymentMethod)
            .Select(g => new DashboardMetricItem { Label = g.Key, Value = g.Count().ToString() })
            .OrderByDescending(x => Convert.ToInt32(x.Value))
            .ToList();
        rptPaymentMix.DataBind();
    }

    private void BindTopProducts(List<OrderRecord> orders)
    {
        rptTopProducts.DataSource = orders
            .Where(o => o.Items != null)
            .SelectMany(o => o.Items)
            .GroupBy(i => i.Name)
            .Select(g => new DashboardMetricItem { Label = g.Key, Value = g.Sum(i => i.Quantity).ToString() })
            .OrderByDescending(x => Convert.ToInt32(x.Value))
            .Take(5)
            .ToList();
        rptTopProducts.DataBind();
    }

    private void BindRatingMix(List<ReviewRecord> reviews)
    {
        rptRatingMix.DataSource = reviews
            .GroupBy(r => r.Rating)
            .Select(g => new DashboardMetricItem { Label = g.Key + " star", Value = g.Count().ToString() })
            .OrderByDescending(x => Convert.ToInt32(x.Label.Split(' ')[0]))
            .ToList();
        rptRatingMix.DataBind();
    }

    private void BindProducts()
    {
        gvProducts.DataSource = CatalogRepository.GetAll();
        gvProducts.DataBind();
    }

    private void BindOrders()
    {
        gvOrders.RowDataBound -= gvOrders_RowDataBound;
        gvOrders.RowDataBound += gvOrders_RowDataBound;
        gvOrders.DataSource = OrderRepository.GetAll();
        gvOrders.DataBind();
    }

    private void BindReviews()
    {
        gvReviews.DataSource = ReviewRepository.GetAll();
        gvReviews.DataBind();
    }

    protected void btnAdminLogout_Click(object sender, EventArgs e)
    {
        Session[AdminSessionKey] = null;
        Response.Redirect("AdminLogin.aspx");
    }

    protected void btnAddProduct_Click(object sender, EventArgs e)
    {
        if (!IsAdminAuthenticated())
        {
            Response.Redirect("AdminLogin.aspx");
            return;
        }

        decimal price;
        if (!Decimal.TryParse(txtProductPrice.Text, out price))
        {
            lblAdminMessage.Text = "Enter a valid price.";
            lblAdminMessage.Visible = true;
            return;
        }

        string imageUrl = txtImageUrl.Text.Trim();
        if (fuProductImage.HasFile)
        {
            string uploadedImageUrl;
            if (!TrySaveUploadedImage(fuProductImage, out uploadedImageUrl))
            {
                lblAdminMessage.Text = "Upload a valid image file: .jpg, .jpeg, .png, .gif, or .webp.";
                lblAdminMessage.Visible = true;
                return;
            }

            imageUrl = uploadedImageUrl;
        }

        List<Product> products = CatalogRepository.GetAll();
        products.Add(new Product
        {
            Id = CatalogRepository.GetNextId(),
            Category = ddlCategory.SelectedValue,
            Name = txtProductName.Text.Trim(),
            Description = txtProductDescription.Text.Trim(),
            ImageUrl = imageUrl,
            Price = price,
            Featured = chkFeatured.Checked
        });

        CatalogRepository.SaveAll(products);
        txtProductName.Text = "";
        txtProductDescription.Text = "";
        txtProductPrice.Text = "";
        txtImageUrl.Text = "";
        chkFeatured.Checked = false;
        lblAdminMessage.Text = "Product added.";
        lblAdminMessage.Visible = true;
        BindProducts();
        BindMetrics();
    }

    protected void gvProducts_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvProducts.EditIndex = e.NewEditIndex;
        BindProducts();
    }

    protected void gvProducts_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvProducts.EditIndex = -1;
        BindProducts();
    }

    protected void gvProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int id = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);
        GridViewRow row = gvProducts.Rows[e.RowIndex];
        List<Product> products = CatalogRepository.GetAll();
        Product product = products.Find(p => p.Id == id);

        if (product == null)
        {
            return;
        }

        decimal price;
        Decimal.TryParse(((TextBox)row.Cells[3].Controls[0]).Text, out price);

        product.Category = ((TextBox)row.Cells[1].Controls[0]).Text.Trim();
        product.Name = ((TextBox)row.Cells[2].Controls[0]).Text.Trim();
        product.Price = price;
        product.ImageUrl = ((TextBox)row.Cells[4].Controls[0]).Text.Trim();
        CheckBox featured = row.Cells[5].Controls[0] as CheckBox;
        if (featured != null)
        {
            product.Featured = featured.Checked;
        }

        CatalogRepository.SaveAll(products);
        gvProducts.EditIndex = -1;
        lblAdminMessage.Text = "Product updated.";
        lblAdminMessage.Visible = true;
        BindProducts();
    }

    protected void gvProducts_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int id = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);
        List<Product> products = CatalogRepository.GetAll();
        Product product = products.Find(p => p.Id == id);
        if (product != null)
        {
            products.Remove(product);
            CatalogRepository.SaveAll(products);
        }

        lblAdminMessage.Text = "Product deleted.";
        lblAdminMessage.Visible = true;
        BindProducts();
        BindMetrics();
    }

    protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
        {
            return;
        }

        OrderRecord order = (OrderRecord)e.Row.DataItem;
        DropDownList ddl = e.Row.FindControl("ddlDeliveryStatus") as DropDownList;
        if (ddl != null)
        {
            ListItem item = ddl.Items.FindByText(order.DeliveryStatus);
            if (item != null)
            {
                ddl.ClearSelection();
                item.Selected = true;
            }
        }
    }

    protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (!IsAdminAuthenticated())
        {
            Response.Redirect("AdminLogin.aspx");
            return;
        }

        if (e.CommandName != "UpdateOrderStatus")
        {
            return;
        }

        GridViewRow row = ((Control)e.CommandSource).NamingContainer as GridViewRow;
        if (row == null)
        {
            return;
        }

        DropDownList ddl = row.FindControl("ddlDeliveryStatus") as DropDownList;
        if (ddl == null)
        {
            return;
        }

        List<OrderRecord> orders = OrderRepository.GetAll();
        OrderRecord order = orders.Find(o => o.OrderNumber == Convert.ToString(e.CommandArgument));
        if (order == null)
        {
            return;
        }

        order.DeliveryStatus = ddl.SelectedValue;
        OrderRepository.SaveAll(orders);
        lblAdminMessage.Text = "Order status updated to " + ddl.SelectedValue + ".";
        lblAdminMessage.Visible = true;
        BindOrders();
        BindMetrics();
    }

    protected void gvReviews_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (!IsAdminAuthenticated())
        {
            Response.Redirect("AdminLogin.aspx");
            return;
        }

        int id;
        if (!Int32.TryParse(Convert.ToString(e.CommandArgument), out id))
        {
            return;
        }

        List<ReviewRecord> reviews = ReviewRepository.GetAll();
        ReviewRecord review = reviews.Find(r => r.Id == id);
        if (review == null)
        {
            return;
        }

        if (e.CommandName == "DeleteReview")
        {
            reviews.Remove(review);
            ReviewRepository.SaveAll(reviews);
            lblAdminMessage.Text = "Review deleted.";
        }
        else if (e.CommandName == "UpdateReview")
        {
            GridViewRow row = ((Control)e.CommandSource).NamingContainer as GridViewRow;
            CheckBox chkApproved = row != null ? row.FindControl("chkApproved") as CheckBox : null;
            review.Approved = chkApproved != null && chkApproved.Checked;
            ReviewRepository.SaveAll(reviews);
            lblAdminMessage.Text = review.Approved ? "Review approved for storefront display." : "Review hidden from storefront.";
        }

        lblAdminMessage.Visible = true;
        BindReviews();
        BindMetrics();
    }

    private class DashboardMetricItem
    {
        public string Label { get; set; }
        public string Value { get; set; }
    }

    private bool TrySaveUploadedImage(FileUpload upload, out string imageUrl)
    {
        imageUrl = String.Empty;
        if (upload == null || !upload.HasFile)
        {
            return false;
        }

        string extension = Path.GetExtension(upload.FileName);
        string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };
        bool isAllowed = allowedExtensions.Any(ext => String.Equals(ext, extension, StringComparison.OrdinalIgnoreCase));
        if (!isAllowed)
        {
            return false;
        }

        string uploadsFolder = Server.MapPath("~/img/uploads");
        if (!Directory.Exists(uploadsFolder))
        {
            Directory.CreateDirectory(uploadsFolder);
        }

        string safeFileName = "product_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + extension.ToLowerInvariant();
        string physicalPath = Path.Combine(uploadsFolder, safeFileName);
        upload.SaveAs(physicalPath);
        imageUrl = "~/img/uploads/" + safeFileName;
        return true;
    }
}
