<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Reset.aspx.cs" Inherits="Reset" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="auth-shell">
        <div class="hero-card auth-panel">
            <div class="eyebrow">Password reset</div>
            <h1 class="auth-title">Set a new password with a cleaner recovery screen.</h1>
            <p class="section-copy">The reset flow now uses the same layout language as the rest of the project. Enter the account email, choose a new password, confirm it, and submit the update.</p>
        </div>
        <div class="summary-card auth-card">
            <div class="eyebrow">Reset access</div>
            <h2 class="section-title">Update credentials</h2>
            <div class="form-stack">
                <div class="field">
                    <label for="TextBox1">Email</label>
                    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1" ErrorMessage="Enter email id" CssClass="validator"></asp:RequiredFieldValidator>
                </div>
                <div class="field">
                    <label for="TextBox2">New password</label>
                    <asp:TextBox ID="TextBox2" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox2" ErrorMessage="Enter new password" CssClass="validator"></asp:RequiredFieldValidator>
                </div>
                <div class="field">
                    <label for="TextBox3">Confirm password</label>
                    <asp:TextBox ID="TextBox3" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="TextBox2" ControlToValidate="TextBox3" ErrorMessage="New password and confirm password should be same" CssClass="validator"></asp:CompareValidator>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TextBox3" ErrorMessage="Enter confirm password" CssClass="validator"></asp:RequiredFieldValidator>
                </div>
                <div class="auth-links">
                    <asp:Button ID="Button1" runat="server" CssClass="btn-primary" Text="Confirm" onclick="Button1_Click" />
                    <asp:Button ID="Button2" runat="server" CssClass="btn-secondary" Text="Cancel" CausesValidation="false" onclick="Button2_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
