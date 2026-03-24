<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Payment.aspx.cs" Inherits="Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .checkout-layout
        {
            display:grid;
            grid-template-columns:minmax(0, 1fr) 360px;
            gap:24px;
            padding-top:30px;
        }
        .checkout-panel,
        .checkout-summary
        {
            padding:28px;
        }
        .payment-methods label
        {
            display:block;
            padding:10px 12px;
            margin:0 0 10px;
            border:1px solid var(--line);
            border-radius:14px;
            background:#fff;
        }
        .order-item
        {
            display:flex;
            justify-content:space-between;
            gap:12px;
            padding:12px 0;
            border-bottom:1px solid var(--line);
        }
        @media screen and (max-width: 900px)
        {
            .checkout-layout
            {
                grid-template-columns:1fr;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblPaymentMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
    <div class="checkout-layout">
        <div class="section-card checkout-panel">
            <div class="eyebrow">Checkout</div>
            <h1 class="section-title">Customer and payment details</h1>
            <asp:Panel ID="pnlCheckoutEmpty" runat="server" Visible="false" CssClass="empty-state">
                <p class="section-copy" style="margin-bottom:18px;">There are no items in the cart yet.</p>
                <a href="Home.aspx" class="btn-primary">Browse products</a>
            </asp:Panel>
            <asp:Panel ID="pnlCheckoutForm" runat="server">
                <div class="form-grid">
                    <div class="field">
                        <label for="txtUname">Full name</label>
                        <asp:TextBox ID="txtUname" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtUname" ErrorMessage="Enter name" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtEmail">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Enter email" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtPhone">Phone</label>
                        <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
                    </div>
                    <div class="field">
                        <label for="txtAmount">Order total</label>
                        <asp:TextBox ID="txtAmount" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="field full">
                        <label for="txtAddress">Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" ErrorMessage="Enter address" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtCity">City</label>
                        <asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" ErrorMessage="Enter city" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtState">State</label>
                        <asp:TextBox ID="txtState" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState" ErrorMessage="Enter state" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtPin">Pincode</label>
                        <asp:TextBox ID="txtPin" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPincode" runat="server" ControlToValidate="txtPin" ErrorMessage="Enter pincode" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field full payment-methods">
                        <label style="border:none; padding:0; background:none;">Payment option</label>
                        <asp:RadioButtonList ID="rblPaymentMethod" runat="server" RepeatLayout="Flow">
                            <asp:ListItem Selected="True">Cash on Delivery</asp:ListItem>
                            <asp:ListItem>UPI</asp:ListItem>
                            <asp:ListItem>Credit or Debit Card</asp:ListItem>
                            <asp:ListItem>Net Banking</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="field full">
                        <label for="txtPaymentReference">Payment reference or notes</label>
                        <asp:TextBox ID="txtPaymentReference" runat="server" placeholder="UPI transaction id, card last 4 digits, or bank reference"></asp:TextBox>
                    </div>
                </div>
                <div style="display:flex; gap:12px; flex-wrap:wrap; margin-top:24px;">
                    <asp:Button ID="Button3" runat="server" Text="Place order" CssClass="btn-primary" OnClick="Button3_Click" />
                    <asp:Button ID="Button4" runat="server" Text="Reset form" CssClass="btn-secondary" CausesValidation="false" OnClick="Button4_Click" />
                </div>
            </asp:Panel>
        </div>

        <div class="summary-card checkout-summary">
            <div class="eyebrow">Order summary</div>
            <h2 style="margin:10px 0 16px; font-size:30px;">Items in this order</h2>
            <asp:Repeater ID="rptOrderSummary" runat="server">
                <ItemTemplate>
                    <div class="order-item">
                        <div>
                            <div style="font-size:18px;"><%# Eval("Name") %></div>
                            <div class="muted">Qty <%# Eval("Quantity") %></div>
                        </div>
                        <div>Rs. <%# Eval("LineTotal", "{0:0.##}") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <div style="display:flex; justify-content:space-between; margin-top:18px; font-size:24px;">
                <strong>Total</strong>
                <asp:Label ID="lblSummaryTotal" runat="server" />
            </div>
        </div>
    </div>
</asp:Content>
