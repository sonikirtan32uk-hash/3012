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
        .payment-note
        {
            margin-top:8px;
            color:var(--muted);
            font-size:13px;
            line-height:1.6;
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
                        <asp:TextBox ID="txtUname" runat="server" placeholder="Oliver Bennett"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtUname" ErrorMessage="Enter name" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtEmail">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" placeholder="oliver.bennett@example.co.uk"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Enter email" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtPhone">Phone number</label>
                        <asp:TextBox ID="txtPhone" runat="server" placeholder="+44 7700 900123"></asp:TextBox>
                    </div>
                    <div class="field">
                        <label for="txtAmount">Order total</label>
                        <asp:TextBox ID="txtAmount" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="field full">
                        <label for="txtAddress">Address line 1</label>
                        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" placeholder="Flat 4B&#10;18 Kensington High Street"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" ErrorMessage="Enter address" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                        <div class="payment-note">Use a full delivery address, for example flat or house number followed by street name.</div>
                    </div>
                    <div class="field">
                        <label for="txtCity">Town or city</label>
                        <asp:TextBox ID="txtCity" runat="server" placeholder="London"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" ErrorMessage="Enter city" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtState">County</label>
                        <asp:TextBox ID="txtState" runat="server" placeholder="Greater London"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState" ErrorMessage="Enter state" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field">
                        <label for="txtPin">Postcode</label>
                        <asp:TextBox ID="txtPin" runat="server" placeholder="SW1A 1AA"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPincode" runat="server" ControlToValidate="txtPin" ErrorMessage="Enter postcode" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="field full payment-methods">
                        <label style="border:none; padding:0; background:none;">Payment method</label>
                        <asp:RadioButtonList ID="rblPaymentMethod" runat="server" RepeatLayout="Flow">
                            <asp:ListItem Selected="True">Visa or Mastercard</asp:ListItem>
                            <asp:ListItem>PayPal</asp:ListItem>
                            <asp:ListItem>Apple Pay or Google Pay</asp:ListItem>
                            <asp:ListItem>Bank Transfer</asp:ListItem>
                        </asp:RadioButtonList>
                        <div class="payment-note">Demo checkout only. No live payment is processed, but the flow now reflects common UK-facing payment choices.</div>
                    </div>
                    <div class="field full">
                        <label for="txtPaymentReference">Payment reference or notes</label>
                        <asp:TextBox ID="txtPaymentReference" runat="server" placeholder="Example: Visa ending 4242, PayPal transaction reference, or bank transfer confirmation"></asp:TextBox>
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
