using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Cart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCart();
        }
    }

    private void BindCart()
    {
        var cart = CartService.GetCart();
        pnlEmpty.Visible = cart.Count == 0;
        rptCart.Visible = cart.Count > 0;
        rptCart.DataSource = cart;
        rptCart.DataBind();
        lblItemCount.Text = CartService.GetItemCount().ToString();
        lblCartTotal.Text = "Rs. " + CartService.GetTotal().ToString("0.##");
    }

    protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int productId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "UpdateQuantity")
        {
            TextBox txtQuantity = (TextBox)e.Item.FindControl("txtQuantity");
            int quantity;
            if (!Int32.TryParse(txtQuantity.Text, out quantity))
            {
                quantity = 1;
            }

            CartService.UpdateQuantity(productId, quantity);
            lblCartMessage.Text = "Cart updated.";
            lblCartMessage.Visible = true;
        }
        else if (e.CommandName == "RemoveItem")
        {
            CartService.RemoveProduct(productId);
            lblCartMessage.Text = "Item removed from cart.";
            lblCartMessage.Visible = true;
        }

        BindCart();
    }
}
