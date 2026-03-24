<%@ Page Title="Lamps" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="lamp.aspx.cs" Inherits="lamp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .catalog-banner
        {
            margin:32px 0 24px;
            padding:36px;
            background:linear-gradient(135deg, rgba(184,92,56,0.12), rgba(29,43,42,0.04));
        }
        .catalog-banner h1
        {
            margin:8px 0 12px;
            font-size:42px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
    <div class="hero-card catalog-banner">
        <div class="eyebrow">Lighting collection</div>
        <h1>Decorative lighting with a warmer, cleaner storefront.</h1>
        <p class="section-copy">Each lamp now comes from the shared catalog. Pricing and imagery can be updated from the admin panel without touching this page markup.</p>
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
                    <div style="margin-top:auto; display:flex; justify-content:space-between; align-items:center; gap:14px; flex-wrap:wrap;">
                        <span class="price">Rs. <%# Eval("Price", "{0:0.##}") %></span>
                        <asp:Button ID="btnAddToCart" runat="server" Text="Add to cart" CssClass="catalog-btn" CommandName="AddToCart" CommandArgument='<%# Eval("Id") %>' />
                    </div>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>
</asp:Content>
