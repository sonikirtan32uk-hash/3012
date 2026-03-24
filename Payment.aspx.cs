using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Payment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCheckout();
        }
    }

    private void BindCheckout()
    {
        List<CartItem> cart = CartService.GetCart();
        bool hasItems = cart.Count > 0;
        pnlCheckoutEmpty.Visible = !hasItems;
        pnlCheckoutForm.Visible = hasItems;
        rptOrderSummary.DataSource = cart;
        rptOrderSummary.DataBind();
        txtAmount.Text = CartService.GetTotal().ToString("0.##");
        lblSummaryTotal.Text = "Rs. " + CartService.GetTotal().ToString("0.##");
    }

    protected void Button4_Click(object sender, EventArgs e)
    {
        txtUname.Text = "";
        txtEmail.Text = "";
        txtPhone.Text = "";
        txtAddress.Text = "";
        txtCity.Text = "";
        txtState.Text = "";
        txtPin.Text = "";
        txtPaymentReference.Text = "";
        rblPaymentMethod.SelectedIndex = 0;
    }

    protected void Button3_Click(object sender, EventArgs e)
    {
        List<CartItem> cart = CartService.GetCart();
        if (cart.Count == 0)
        {
            lblPaymentMessage.Text = "Cart is empty.";
            lblPaymentMessage.Visible = true;
            return;
        }

        OrderRecord order = new OrderRecord
        {
            OrderNumber = "ORD-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
            CustomerName = txtUname.Text.Trim(),
            Email = txtEmail.Text.Trim(),
            Phone = txtPhone.Text.Trim(),
            Address = txtAddress.Text.Trim(),
            City = txtCity.Text.Trim(),
            State = txtState.Text.Trim(),
            Pincode = txtPin.Text.Trim(),
            PaymentMethod = rblPaymentMethod.SelectedValue,
            PaymentReference = txtPaymentReference.Text.Trim(),
            DeliveryStatus = "Processing",
            TotalAmount = CartService.GetTotal(),
            CreatedAt = DateTime.Now,
            Items = new List<CartItem>(cart)
        };

        OrderRepository.Save(order);
        CartService.Clear();
        lblPaymentMessage.Text = "Order placed successfully. Reference: " + order.OrderNumber;
        lblPaymentMessage.Visible = true;
        Button4_Click(sender, e);
        BindCheckout();
    }
}
