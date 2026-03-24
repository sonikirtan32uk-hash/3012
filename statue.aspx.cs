using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class statue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindProducts();
        }
    }

    private void BindProducts()
    {
        rptProducts.DataSource = CatalogRepository.GetByCategory("Statue");
        rptProducts.DataBind();
    }

    protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "AddToCart")
        {
            CartService.AddProduct(Convert.ToInt32(e.CommandArgument));
            lblMessage.Text = "Product added to cart.";
            lblMessage.Visible = true;
            BindProducts();
        }
    }
}
