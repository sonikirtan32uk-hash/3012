<%@ Page Title="Cart" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .cart-layout
        {
            display:grid;
            grid-template-columns:minmax(0, 1fr) 340px;
            gap:24px;
            padding-top:30px;
        }
        .cart-panel,
        .cart-summary
        {
            padding:26px;
        }
        .cart-item
        {
            display:grid;
            grid-template-columns:110px 1fr auto;
            gap:18px;
            padding:18px 0;
            border-bottom:1px solid var(--line);
            align-items:center;
        }
        .cart-item img
        {
            width:110px;
            height:110px;
            object-fit:cover;
            border-radius:18px;
        }
        .qty-box
        {
            width:74px;
            padding:10px 12px;
            border-radius:12px;
            border:1px solid var(--line);
        }
        @media screen and (max-width: 900px)
        {
            .cart-layout
            {
                grid-template-columns:1fr;
            }
            .cart-item
            {
                grid-template-columns:1fr;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblCartMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
    <div class="cart-layout">
        <div class="section-card cart-panel">
            <div class="eyebrow">Shopping cart</div>
            <h1 class="section-title">Review items before checkout</h1>
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                <p class="section-copy" style="margin-bottom:18px;">Your cart is empty. Start with the product catalog and add a few pieces.</p>
                <a href="bid house.aspx" class="btn-primary">Browse products</a>
            </asp:Panel>
            <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                <ItemTemplate>
                    <div class="cart-item">
                        <img src="<%# ResolveUrl(Eval("ImageUrl").ToString()) %>" alt="<%# Eval("Name") %>" />
                        <div>
                            <div class="eyebrow"><%# Eval("Category") %></div>
                            <h3 style="margin:8px 0 10px; font-size:24px;"><%# Eval("Name") %></h3>
                            <div class="muted">Rs. <%# Eval("Price", "{0:0.##}") %> each</div>
                            <div style="margin-top:14px; display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                                <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Quantity") %>' CssClass="qty-box"></asp:TextBox>
                                <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn-secondary" CommandName="UpdateQuantity" CommandArgument='<%# Eval("ProductId") %>' />
                                <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="btn-link" CommandName="RemoveItem" CommandArgument='<%# Eval("ProductId") %>' />
                            </div>
                        </div>
                        <div style="font-size:24px;">Rs. <%# Eval("LineTotal", "{0:0.##}") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="summary-card cart-summary">
            <div class="eyebrow">Order summary</div>
            <h2 style="margin:10px 0 14px; font-size:30px;">Cart total</h2>
            <div style="display:flex; justify-content:space-between; margin-bottom:10px;">
                <span class="muted">Items</span>
                <asp:Label ID="lblItemCount" runat="server" />
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom:18px;">
                <span class="muted">Subtotal</span>
                <asp:Label ID="lblCartTotal" runat="server" Font-Size="X-Large" />
            </div>
            <p class="section-copy" style="margin-bottom:20px;">Shipping is included in this demo storefront. Continue to payment to place the order.</p>
            <a href="Payment.aspx" class="btn-primary" style="display:block; text-align:center; margin-bottom:12px;">Proceed to payment</a>
            <a href="Home.aspx" class="btn-secondary" style="display:block; text-align:center;">Continue shopping</a>
        </div>
    </div>
</asp:Content>
