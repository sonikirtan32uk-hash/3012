<%@ Page Title="Admin Login" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="AdminLogin.aspx.cs" Inherits="AdminLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblAdminLoginMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
    <div class="auth-shell">
        <div class="hero-card auth-panel">
            <div class="eyebrow">Restricted access</div>
            <h1 class="auth-title">Private admin access for catalog and dashboard control.</h1>
            <p class="section-copy">The admin area is no longer linked from the public storefront. Only authorized administrators with valid credentials can reach the dashboard.</p>
            <ul class="feature-list">
                <li>Manage products, images, pricing, orders, and reviews from a protected route.</li>
                <li>Keep the storefront navigation focused on customers only.</li>
                <li>Use the existing admin credentials to continue working in the dashboard.</li>
            </ul>
        </div>
        <div class="summary-card auth-card">
            <div class="eyebrow">Admin only</div>
            <h2 class="section-title">Sign in to dashboard</h2>
            <div class="form-stack">
                <div class="field">
                    <label for="txtAdminId">Admin ID</label>
                    <asp:TextBox ID="txtAdminId" runat="server"></asp:TextBox>
                </div>
                <div class="field">
                    <label for="txtAdminPassword">Password</label>
                    <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password"></asp:TextBox>
                </div>
                <asp:Button ID="btnAdminLogin" runat="server" Text="Open admin dashboard" CssClass="btn-primary" OnClick="btnAdminLogin_Click" />
            </div>
        </div>
    </div>
</asp:Content>
