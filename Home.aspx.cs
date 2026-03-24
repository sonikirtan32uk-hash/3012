using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Home : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            rptFeaturedProducts.DataSource = CatalogRepository.GetFeatured(6);
            rptFeaturedProducts.DataBind();
        }
    }

    protected void rptFeaturedProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "AddToCart")
        {
            CartService.AddProduct(Convert.ToInt32(e.CommandArgument));
            Response.Redirect("Cart.aspx");
        }
    }
}
