using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

public partial class Reviews : Page
{
    private int ProductId
    {
        get
        {
            int productId;
            return Int32.TryParse(Request.QueryString["productId"], out productId) ? productId : 0;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPage();
        }
    }

    private void BindPage()
    {
        Product product = CatalogRepository.GetById(ProductId);
        if (product == null)
        {
            pnlMissingProduct.Visible = true;
            pnlReviews.Visible = false;
            return;
        }

        pnlMissingProduct.Visible = false;
        pnlReviews.Visible = true;
        lblProductName.Text = product.Name;
        lblProductDescription.Text = product.Description;

        List<ReviewRecord> reviews = ReviewRepository.GetApprovedByProduct(product.Id);
        rptReviews.DataSource = reviews;
        rptReviews.DataBind();
        pnlNoReviews.Visible = reviews.Count == 0;
        lblReviewTotal.Text = reviews.Count + " approved review" + (reviews.Count == 1 ? "" : "s");
        lblAverageRating.Text = reviews.Count == 0
            ? "No rating yet"
            : "Average rating: " + reviews.Average(r => r.Rating).ToString("0.0") + "/5";
    }

    protected void btnSubmitReview_Click(object sender, EventArgs e)
    {
        Product product = CatalogRepository.GetById(ProductId);
        if (product == null)
        {
            pnlMissingProduct.Visible = true;
            pnlReviews.Visible = false;
            return;
        }

        ReviewRecord review = new ReviewRecord
        {
            Id = ReviewRepository.GetNextId(),
            ProductId = product.Id,
            ProductName = product.Name,
            CustomerName = txtReviewerName.Text.Trim(),
            Location = txtReviewerLocation.Text.Trim(),
            Rating = Convert.ToInt32(ddlRating.SelectedValue),
            Comment = txtReviewComment.Text.Trim(),
            Approved = false,
            CreatedAt = DateTime.Now
        };

        ReviewRepository.Save(review);
        txtReviewerName.Text = "";
        txtReviewerLocation.Text = "";
        txtReviewComment.Text = "";
        ddlRating.SelectedIndex = 0;
        lblReviewMessage.Text = "Review submitted. It will appear after admin approval.";
        lblReviewMessage.Visible = true;
        BindPage();
    }
}
