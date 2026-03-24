<%@ Page Title="Login" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="auth-shell">
        <div class="hero-card auth-panel">
            <div class="eyebrow">Account access</div>
            <h1 class="auth-title">Sign in to manage orders and continue shopping.</h1>
            <p class="section-copy">The login flow now sits inside the same design system as the storefront. Existing users can sign in here, while new customers can register and start building a cart immediately.</p>
            <ul class="feature-list">
                <li>Use your registered email and password to access the storefront.</li>
                <li>Reset your password if you no longer remember the existing credentials.</li>
                <li>Move from sign-in to catalog, cart, and checkout without switching layout styles.</li>
            </ul>
        </div>
        <asp:Login ID="Login1" runat="server" onauthenticate="Login1_Authenticate" CreateUserText="Please Registration Here?" CreateUserUrl="~/Registration.aspx">
            <LayoutTemplate>
                <div class="summary-card auth-card">
                    <div class="eyebrow">Login</div>
                    <h2 class="section-title">Welcome back</h2>
                    <div class="form-stack">
                        <div class="field">
                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">Email</asp:Label>
                            <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User name is required." ToolTip="User Name is required." ValidationGroup="Login1" CssClass="validator"></asp:RequiredFieldValidator>
                        </div>
                        <div class="field">
                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password</asp:Label>
                            <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login1" CssClass="validator"></asp:RequiredFieldValidator>
                        </div>
                        <div class="field">
                            <asp:CheckBox ID="RememberMe" runat="server" Text="Remember me next time" />
                        </div>
                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                        <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Log In" ValidationGroup="Login1" CssClass="btn-primary" />
                    </div>
                    <div class="auth-links">
                        <asp:HyperLink ID="CreateUserLink" runat="server" NavigateUrl="~/Registration.aspx">Create an account</asp:HyperLink>
                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Reset.aspx">Reset password</asp:HyperLink>
                    </div>
                </div>
            </LayoutTemplate>
        </asp:Login>
    </div>
</asp:Content>
