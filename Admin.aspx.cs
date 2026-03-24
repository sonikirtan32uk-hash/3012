using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindProducts();
            BindOrders();
        }
    }

    private void BindProducts()
    {
        gvProducts.DataSource = CatalogRepository.GetAll();
        gvProducts.DataBind();
    }

    private void BindOrders()
    {
        gvOrders.DataSource = OrderRepository.GetAll();
        gvOrders.DataBind();
    }

    protected void btnAddProduct_Click(object sender, EventArgs e)
    {
        decimal price;
        if (!Decimal.TryParse(txtProductPrice.Text, out price))
        {
            lblAdminMessage.Text = "Enter a valid price.";
            lblAdminMessage.Visible = true;
            return;
        }

        List<Product> products = CatalogRepository.GetAll();
        products.Add(new Product
        {
            Id = CatalogRepository.GetNextId(),
            Category = ddlCategory.SelectedValue,
            Name = txtProductName.Text.Trim(),
            Description = txtProductDescription.Text.Trim(),
            ImageUrl = txtImageUrl.Text.Trim(),
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
    }
}
