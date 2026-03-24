<%@ Page Title="Product Reviews" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Reviews.aspx.cs" Inherits="Reviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .review-layout
        {
            display:grid;
            grid-template-columns:minmax(0, 1fr) 360px;
            gap:24px;
            padding-top:30px;
        }
        .review-panel,
        .review-form
        {
            padding:28px;
        }
        .review-item
        {
            padding:18px 0;
            border-bottom:1px solid var(--line);
        }
        .rating-pill
        {
            display:inline-block;
            padding:6px 10px;
            border-radius:999px;
            background:var(--surface-alt);
            color:var(--accent-dark);
            font-size:12px;
            letter-spacing:1px;
            text-transform:uppercase;
        }
        @media screen and (max-width: 900px)
        {
            .review-layout
            {
                grid-template-columns:1fr;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblReviewMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
    <asp:Panel ID="pnlMissingProduct" runat="server" Visible="false" CssClass="empty-state">
        <p class="section-copy" style="margin-bottom:18px;">The selected product was not found.</p>
        <a href="Home.aspx" class="btn-primary">Go back home</a>
    </asp:Panel>

    <asp:Panel ID="pnlReviews" runat="server" Visible="false">
        <div class="review-layout">
            <div class="section-card review-panel">
                <div class="eyebrow">Product reviews</div>
                <h1 class="section-title"><asp:Label ID="lblProductName" runat="server" /></h1>
                <p class="section-copy" style="margin-bottom:18px;"><asp:Label ID="lblProductDescription" runat="server" /></p>
                <div style="display:flex; gap:14px; flex-wrap:wrap; margin-bottom:20px;">
                    <span class="rating-pill"><asp:Label ID="lblAverageRating" runat="server" /></span>
                    <span class="rating-pill"><asp:Label ID="lblReviewTotal" runat="server" /></span>
                </div>
                <asp:Repeater ID="rptReviews" runat="server">
                    <ItemTemplate>
                        <div class="review-item">
                            <div style="display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap;">
                                <strong><%# Eval("CustomerName") %></strong>
                                <span class="muted"><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></span>
                            </div>
                            <div class="muted" style="margin:6px 0 8px;">Rating: <%# Eval("Rating") %>/5<asp:PlaceHolder ID="phLocation" runat="server" Visible='<%# !String.IsNullOrWhiteSpace(Convert.ToString(Eval("Location"))) %>'> | <%# Eval("Location") %></asp:PlaceHolder></div>
                            <p class="section-copy"><%# Eval("Comment") %></p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoReviews" runat="server" Visible="false" CssClass="empty-state">
                    <p class="section-copy">No approved reviews yet. Be the first to leave feedback.</p>
                </asp:Panel>
            </div>

            <div class="summary-card review-form">
                <div class="eyebrow">Leave a review</div>
                <h2 style="margin:8px 0 18px; font-size:30px;">Share your experience</h2>
                <div class="form-stack">
                    <div class="field">
                        <label for="txtReviewerName">Your name</label>
                        <asp:TextBox ID="txtReviewerName" runat="server"></asp:TextBox>
                    </div>
                    <div class="field">
                        <label for="txtReviewerLocation">Location</label>
                        <asp:TextBox ID="txtReviewerLocation" runat="server"></asp:TextBox>
                    </div>
                    <div class="field">
                        <label for="ddlRating">Rating</label>
                        <asp:DropDownList ID="ddlRating" runat="server">
                            <asp:ListItem Value="5">5 - Excellent</asp:ListItem>
                            <asp:ListItem Value="4">4 - Very good</asp:ListItem>
                            <asp:ListItem Value="3">3 - Good</asp:ListItem>
                            <asp:ListItem Value="2">2 - Fair</asp:ListItem>
                            <asp:ListItem Value="1">1 - Poor</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="field">
                        <label for="txtReviewComment">Review</label>
                        <asp:TextBox ID="txtReviewComment" runat="server" TextMode="MultiLine" Rows="5"></asp:TextBox>
                    </div>
                    <div class="field-note">Reviews are saved immediately and require admin approval before they show on the storefront.</div>
                    <asp:Button ID="btnSubmitReview" runat="server" Text="Submit review" CssClass="btn-primary" OnClick="btnSubmitReview_Click" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
