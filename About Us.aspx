<%@ Page Title="About" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="About Us.aspx.cs" Inherits="About_Us" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="page-intro">
        <div class="split-hero">
            <div class="hero-card hero-content">
                <div class="eyebrow">About CasaCraft</div>
                <h1 class="auth-title">A cleaner, more premium storefront for handcrafted decor.</h1>
                <p class="section-copy">CasaCraft presents curated resin and handcrafted decor pieces with the structure of a modern retail experience. The project now combines product discovery, cart, checkout, and administration in one consistent interface.</p>
                <div class="stat-row">
                    <div class="stat-pill">
                        <strong>3</strong>
                        Decor categories
                    </div>
                    <div class="stat-pill">
                        <strong>4</strong>
                        Payment options
                    </div>
                    <div class="stat-pill">
                        <strong>1</strong>
                        Shared catalog source
                    </div>
                </div>
            </div>
            <div class="hero-card media-frame">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/img/bg/bg.jpg" AlternateText="CasaCraft decor showcase" />
            </div>
        </div>
    </div>

    <div class="info-grid">
        <div class="section-card info-block">
            <div class="eyebrow">Vision</div>
            <h2 class="section-title">Decor with craft value</h2>
            <p class="section-copy">The business idea behind this project is to make distinctive home decor feel collectible rather than generic. Products are positioned for customers who care about finish, character, and the visual impact of a room.</p>
        </div>
        <div class="section-card info-block">
            <div class="eyebrow">Approach</div>
            <h2 class="section-title">Built around uniqueness</h2>
            <p class="section-copy">The catalog focuses on one-off or small-batch pieces that work as statement objects for shelves, balconies, and living spaces. The redesign reflects that intent with stronger hierarchy, better spacing, and a more refined browsing flow.</p>
        </div>
        <div class="accent-card info-block">
            <div class="eyebrow">What changed</div>
            <h2 class="section-title">From static pages to a real storefront</h2>
            <ul class="feature-list">
                <li>Shared product catalog powering collection pages and featured items.</li>
                <li>Unified cart and checkout journey with saved order records.</li>
                <li>Admin panel for pricing, imagery, descriptions, and product additions.</li>
            </ul>
        </div>
    </div>
</asp:Content>
