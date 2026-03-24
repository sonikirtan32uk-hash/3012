<%@ Page Title="Home" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .home-hero
        {
            display:grid;
            grid-template-columns:1.1fr 0.9fr;
            gap:26px;
            padding:34px 0 22px;
            align-items:stretch;
        }
        .hero-copy
        {
            padding:44px;
        }
        .hero-copy h1
        {
            font-size:54px;
            line-height:1.02;
            margin:0 0 18px;
        }
        .hero-actions
        {
            display:flex;
            gap:14px;
            flex-wrap:wrap;
            margin-top:28px;
        }
        .hero-media
        {
            position:relative;
            min-height:420px;
            overflow:hidden;
            border-radius:24px;
            background:linear-gradient(160deg, rgba(29,43,42,0.04), rgba(184,92,56,0.18));
        }
        .hero-media img
        {
            position:absolute;
            object-fit:cover;
            box-shadow:var(--shadow);
            border-radius:24px;
            border:8px solid rgba(255,255,255,0.72);
        }
        .hero-media .hero-main
        {
            right:20px;
            top:24px;
            width:58%;
            height:55%;
        }
        .hero-media .hero-secondary
        {
            left:20px;
            bottom:20px;
            width:44%;
            height:42%;
        }
        .hero-media .hero-accent
        {
            right:32%;
            bottom:24px;
            width:32%;
            height:28%;
        }
        .home-sections
        {
            display:grid;
            gap:22px;
            grid-template-columns:repeat(auto-fit, minmax(260px, 1fr));
            margin:16px 0 34px;
        }
        .home-panel
        {
            padding:24px;
        }
        .catalog-section
        {
            padding:22px 0 4px;
        }
        @media screen and (max-width: 900px)
        {
            .home-hero
            {
                grid-template-columns:1fr;
            }
            .hero-copy
            {
                padding:28px;
            }
            .hero-copy h1
            {
                font-size:40px;
            }
            .hero-media
            {
                min-height:340px;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="home-hero">
        <div class="hero-card hero-copy">
            <div class="eyebrow">Curated decor studio</div>
            <h1>Handcrafted pieces for a sharper, more premium home.</h1>
            <p class="section-copy">CasaCraft turns your old static showcase into a working store. Browse curated bird houses, lamps, and statues, add products to cart, checkout with multiple payment methods, and manage the catalog from the admin panel.</p>
            <div class="hero-actions">
                <a href="bid house.aspx" class="btn-primary">Shop collection</a>
                <a href="Admin.aspx" class="btn-secondary">Open admin panel</a>
            </div>
        </div>
        <div class="hero-media">
            <img class="hero-main" src="img/bird house/images.jpeg" alt="Bird house" />
            <img class="hero-secondary" src="img/lamp/wall-lamp2.jpg" alt="Lamp" />
            <img class="hero-accent" src="img/statue/buddha1.jpg" alt="Statue" />
        </div>
    </div>

    <div class="home-sections">
        <div class="section-card home-panel">
            <div class="eyebrow">Why it feels better</div>
            <h2 class="section-title">Professional storefront layout</h2>
            <p class="section-copy">The UI now uses a consistent shell, focused typography, product cards, structured checkout, and a working cart flow instead of isolated static tables.</p>
        </div>
        <div class="section-card home-panel">
            <div class="eyebrow">Admin control</div>
            <h2 class="section-title">Edit catalog in one place</h2>
            <p class="section-copy">Update product names, categories, descriptions, image paths, and pricing directly from the admin page. The storefront pages refresh from the same source.</p>
        </div>
        <div class="section-card home-panel">
            <div class="eyebrow">Checkout ready</div>
            <h2 class="section-title">Multiple payment options</h2>
            <p class="section-copy">Customers can place orders with Cash on Delivery, UPI, card, or net banking. Orders are saved for admin review.</p>
        </div>
    </div>

    <div class="catalog-section">
        <div style="display:flex; justify-content:space-between; align-items:end; gap:18px; margin-bottom:18px; flex-wrap:wrap;">
            <div>
                <div class="eyebrow">Featured products</div>
                <h2 class="section-title">Best of the current catalog</h2>
            </div>
            <a href="Cart.aspx" class="btn-secondary">View cart</a>
        </div>
        <asp:Repeater ID="rptFeaturedProducts" runat="server" OnItemCommand="rptFeaturedProducts_ItemCommand">
            <HeaderTemplate><div class="grid product-grid"></HeaderTemplate>
            <ItemTemplate>
                <div class="section-card product-card">
                    <img src="<%# ResolveUrl(Eval("ImageUrl").ToString()) %>" alt="<%# Eval("Name") %>" />
                    <div class="product-card-body">
                        <div class="eyebrow"><%# Eval("Category") %></div>
                        <h3 style="margin:0; font-size:24px;"><%# Eval("Name") %></h3>
                        <p class="muted" style="margin:0; line-height:1.6;"><%# Eval("Description") %></p>
                        <div style="margin-top:auto; display:flex; align-items:center; justify-content:space-between; gap:14px; flex-wrap:wrap;">
                            <span class="price">Rs. <%# Eval("Price", "{0:0.##}") %></span>
                            <asp:Button ID="btnAddFeatured" runat="server" Text="Add to cart" CssClass="catalog-btn" CommandName="AddToCart" CommandArgument='<%# Eval("Id") %>' />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
