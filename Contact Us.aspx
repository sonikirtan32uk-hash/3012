<%@ Page Title="Contact" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Contact Us.aspx.cs" Inherits="Contact_Us" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="page-intro">
        <div class="hero-card hero-content">
            <div class="eyebrow">Contact</div>
            <h1 class="section-title">Reach the store for product, order, or custom decor queries.</h1>
            <p class="section-copy">This page has been rebuilt as a proper contact screen with clear communication details instead of a fixed-width table. Use the numbers below for direct contact and the address for in-person reference.</p>
        </div>
    </div>

    <div class="info-grid">
        <div class="section-card info-block">
            <div class="eyebrow">Call us</div>
            <div class="contact-lines">
                <p class="contact-value">7622811923</p>
                <p class="contact-value">9157543924</p>
            </div>
        </div>
        <div class="section-card info-block">
            <div class="eyebrow">Mail us</div>
            <div class="contact-lines">
                <p class="contact-value"><asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="mailto:eaadorn.com">eaadorn.com</asp:HyperLink></p>
                <p class="section-copy">Use email for product questions, bulk requests, and order follow-ups.</p>
            </div>
        </div>
        <div class="accent-card info-block">
            <div class="eyebrow">Store address</div>
            <p class="contact-value">Eadorn Campus</p>
            <p class="section-copy">Bootyad Gali, Hathnoli near Dabhan, Nadiad, Kheda, Gujarat.</p>
        </div>
    </div>
</asp:Content>
