<%@ Page Title="Bird House" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="bid house.aspx.cs" Inherits="bid_house" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .catalog-hero
        {
            padding:32px 0 20px;
            display:grid;
            grid-template-columns:1fr 320px;
            gap:22px;
        }
        .catalog-hero-copy
        {
            padding:34px;
        }
        .catalog-hero-copy h1
        {
            margin:0 0 12px;
            font-size:42px;
        }
        .catalog-side
        {
            padding:28px;
        }
        @media screen and (max-width: 900px)
        {
            .catalog-hero
            {
                grid-template-columns:1fr;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
    <div class="catalog-hero">
        <div class="hero-card catalog-hero-copy">
            <div class="eyebrow">Bird house collection</div>
            <h1>Decor-first homes for balcony corners and gifting sets.</h1>
            <p class="section-copy">This page is now powered by the product catalog. Admin changes to product name, image, description, or pricing appear here automatically.</p>
        </div>
        <div class="section-card catalog-side">
            <div class="eyebrow">Quick actions</div>
            <h2 style="margin:8px 0 12px; font-size:28px;">Shop faster</h2>
            <p class="section-copy" style="margin-bottom:18px;">Add products directly to cart, then checkout with your preferred payment option.</p>
            <a href="Cart.aspx" class="btn-primary">Open cart</a>
        </div>
    </div>

    <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
        <HeaderTemplate><div class="grid product-grid"></HeaderTemplate>
        <ItemTemplate>
            <div class="section-card product-card">
                <img src="<%# ResolveUrl(Eval("ImageUrl").ToString()) %>" alt="<%# Eval("Name") %>" />
                <div class="product-card-body">
                    <div class="eyebrow"><%# Eval("Category") %></div>
                    <h3 style="margin:0; font-size:24px;"><%# Eval("Name") %></h3>
                    <p class="muted" style="margin:0; line-height:1.6;"><%# Eval("Description") %></p>
                    <div style="margin-top:auto; display:flex; justify-content:space-between; align-items:center; gap:10px; flex-wrap:wrap;">
                        <span class="price">Rs. <%# Eval("Price", "{0:0.##}") %></span>
                        <div style="display:flex; gap:10px; flex-wrap:wrap;">
                            <a href='Reviews.aspx?productId=<%# Eval("Id") %>' class="btn-secondary">Reviews</a>
                            <asp:Button ID="btnAddToCart" runat="server" Text="Add to cart" CssClass="catalog-btn" CommandName="AddToCart" CommandArgument='<%# Eval("Id") %>' />
                        </div>
                    </div>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>
</asp:Content>
