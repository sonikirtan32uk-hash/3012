<%@ Page Title="Admin Panel" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Admin.aspx.cs" Inherits="Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .admin-login-shell
        {
            max-width:960px;
            margin:0 auto;
            padding-top:34px;
        }
        .admin-login-layout
        {
            display:grid;
            grid-template-columns:minmax(0, 1fr) 380px;
            gap:24px;
        }
        .admin-layout
        {
            display:grid;
            gap:24px;
            padding-top:30px;
        }
        .admin-section
        {
            padding:28px;
        }
        .dashboard-grid
        {
            display:grid;
            grid-template-columns:repeat(4, minmax(0, 1fr));
            gap:18px;
        }
        .metric-card
        {
            padding:22px;
        }
        .metric-card strong
        {
            display:block;
            font-size:34px;
            margin-top:10px;
        }
        .admin-grid
        {
            display:grid;
            grid-template-columns:1.1fr 0.9fr;
            gap:24px;
        }
        .status-chip
        {
            display:inline-block;
            padding:6px 12px;
            border-radius:999px;
            font-size:12px;
            background:var(--surface-alt);
        }
        .status-delivered
        {
            background:#e7f5ee;
            color:#1f6a4f;
        }
        .status-processing
        {
            background:#f8ecd9;
            color:#8f5a16;
        }
        .status-dispatched
        {
            background:#e6f0fa;
            color:#225d9c;
        }
        .admin-actions
        {
            display:flex;
            gap:10px;
            flex-wrap:wrap;
            align-items:center;
        }
        .wide-table td,
        .wide-table th
        {
            white-space:normal;
        }
        .review-grid
        {
            display:grid;
            grid-template-columns:1.15fr 0.85fr;
            gap:24px;
        }
        .analytics-grid
        {
            display:grid;
            grid-template-columns:repeat(3, minmax(0, 1fr));
            gap:24px;
        }
        .analytics-panel
        {
            padding:24px;
        }
        .analytics-list
        {
            margin:0;
            padding:0;
            list-style:none;
            display:grid;
            gap:12px;
        }
        .analytics-list li
        {
            display:flex;
            justify-content:space-between;
            gap:12px;
            padding:12px 14px;
            border-radius:14px;
            background:var(--surface-alt);
        }
        .upload-note
        {
            margin-top:8px;
            color:var(--muted);
            font-size:13px;
            line-height:1.5;
        }
        @media screen and (max-width: 900px)
        {
            .admin-login-layout,
            .admin-grid,
            .review-grid,
            .analytics-grid
            {
                grid-template-columns:1fr;
            }
            .dashboard-grid
            {
                grid-template-columns:repeat(2, minmax(0, 1fr));
            }
        }
        @media screen and (max-width: 640px)
        {
            .dashboard-grid
            {
                grid-template-columns:1fr;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblAdminMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

    <div class="admin-layout">
            <div class="hero-card admin-section">
                <div style="display:flex; justify-content:space-between; align-items:start; gap:16px; flex-wrap:wrap;">
                    <div>
                        <div class="eyebrow">Admin dashboard</div>
                        <h1 class="section-title">Control products, track delivery, and manage reviews</h1>
                        <p class="section-copy">Signed in as `admin`. Monitor customer activity, update order progression, and keep the storefront feedback section professional.</p>
                    </div>
                    <asp:Button ID="btnAdminLogout" runat="server" Text="Logout" CssClass="btn-secondary" OnClick="btnAdminLogout_Click" />
                </div>
            </div>

            <div class="dashboard-grid">
                <div class="section-card metric-card">
                    <div class="eyebrow">Products</div>
                    <strong><asp:Label ID="lblTotalProducts" runat="server" Text="0"></asp:Label></strong>
                    <div class="muted">Active catalog items</div>
                </div>
                <div class="section-card metric-card">
                    <div class="eyebrow">Orders</div>
                    <strong><asp:Label ID="lblTotalOrders" runat="server" Text="0"></asp:Label></strong>
                    <div class="muted">Total orders received</div>
                </div>
                <div class="section-card metric-card">
                    <div class="eyebrow">Delivered</div>
                    <strong><asp:Label ID="lblDeliveredOrders" runat="server" Text="0"></asp:Label></strong>
                    <div class="muted">Orders marked as delivered</div>
                </div>
                <div class="section-card metric-card">
                    <div class="eyebrow">Revenue</div>
                    <strong><asp:Label ID="lblRevenue" runat="server" Text="Rs. 0"></asp:Label></strong>
                    <div class="muted">Total order value</div>
                </div>
                <div class="section-card metric-card">
                    <div class="eyebrow">Average order</div>
                    <strong><asp:Label ID="lblAverageOrderValue" runat="server" Text="Rs. 0"></asp:Label></strong>
                    <div class="muted">Average order value</div>
                </div>
                <div class="section-card metric-card">
                    <div class="eyebrow">Reviews</div>
                    <strong><asp:Label ID="lblReviewCount" runat="server" Text="0"></asp:Label></strong>
                    <div class="muted">Customer feedback records</div>
                </div>
            </div>

            <div class="analytics-grid">
                <div class="section-card analytics-panel">
                    <div class="eyebrow">Payments</div>
                    <h2 style="margin:8px 0 16px; font-size:28px;">Payment method mix</h2>
                    <asp:Repeater ID="rptPaymentMix" runat="server">
                        <HeaderTemplate><ul class="analytics-list"></HeaderTemplate>
                        <ItemTemplate>
                            <li><span><%# Eval("Label") %></span><strong><%# Eval("Value") %></strong></li>
                        </ItemTemplate>
                        <FooterTemplate></ul></FooterTemplate>
                    </asp:Repeater>
                </div>
                <div class="section-card analytics-panel">
                    <div class="eyebrow">Top products</div>
                    <h2 style="margin:8px 0 16px; font-size:28px;">Most ordered items</h2>
                    <asp:Repeater ID="rptTopProducts" runat="server">
                        <HeaderTemplate><ul class="analytics-list"></HeaderTemplate>
                        <ItemTemplate>
                            <li><span><%# Eval("Label") %></span><strong><%# Eval("Value") %></strong></li>
                        </ItemTemplate>
                        <FooterTemplate></ul></FooterTemplate>
                    </asp:Repeater>
                </div>
                <div class="section-card analytics-panel">
                    <div class="eyebrow">Review rating</div>
                    <h2 style="margin:8px 0 16px; font-size:28px;">Review score mix</h2>
                    <asp:Repeater ID="rptRatingMix" runat="server">
                        <HeaderTemplate><ul class="analytics-list"></HeaderTemplate>
                        <ItemTemplate>
                            <li><span><%# Eval("Label") %></span><strong><%# Eval("Value") %></strong></li>
                        </ItemTemplate>
                        <FooterTemplate></ul></FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <div class="admin-grid">
                <div class="section-card admin-section">
                    <div style="display:flex; justify-content:space-between; align-items:end; gap:14px; flex-wrap:wrap; margin-bottom:16px;">
                        <div>
                            <div class="eyebrow">Catalog</div>
                            <h2 style="margin:8px 0 0; font-size:30px;">Product management</h2>
                        </div>
                    </div>
                    <div class="table-shell">
                        <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" CssClass="data-table wide-table"
                            DataKeyNames="Id"
                            OnRowEditing="gvProducts_RowEditing"
                            OnRowCancelingEdit="gvProducts_RowCancelingEdit"
                            OnRowUpdating="gvProducts_RowUpdating"
                            OnRowDeleting="gvProducts_RowDeleting">
                            <Columns>
                                <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="true" />
                                <asp:BoundField DataField="Category" HeaderText="Category" />
                                <asp:BoundField DataField="Name" HeaderText="Name" />
                                <asp:BoundField DataField="Price" HeaderText="Price" />
                                <asp:BoundField DataField="ImageUrl" HeaderText="Image Path" />
                                <asp:CheckBoxField DataField="Featured" HeaderText="Featured" />
                                <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <div class="summary-card admin-section">
                    <div class="eyebrow">Create product</div>
                    <h2 style="margin:8px 0 18px; font-size:30px;">Add new catalog item</h2>
                    <div class="form-grid">
                        <div class="field">
                            <label for="ddlCategory">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server">
                                <asp:ListItem>Bird House</asp:ListItem>
                                <asp:ListItem>Lamp</asp:ListItem>
                                <asp:ListItem>Statue</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="field">
                            <label for="txtProductName">Product name</label>
                            <asp:TextBox ID="txtProductName" runat="server"></asp:TextBox>
                        </div>
                        <div class="field full">
                            <label for="txtProductDescription">Description</label>
                            <asp:TextBox ID="txtProductDescription" runat="server" TextMode="MultiLine" Rows="4"></asp:TextBox>
                        </div>
                        <div class="field">
                            <label for="txtProductPrice">Price</label>
                            <asp:TextBox ID="txtProductPrice" runat="server"></asp:TextBox>
                        </div>
                        <div class="field">
                            <label for="txtImageUrl">Image path</label>
                            <asp:TextBox ID="txtImageUrl" runat="server"></asp:TextBox>
                            <div class="upload-note">You can paste an existing path or upload a new image from the local device below.</div>
                        </div>
                        <div class="field">
                            <label for="fuProductImage">Upload image</label>
                            <asp:FileUpload ID="fuProductImage" runat="server" />
                            <div class="upload-note">Allowed types: `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`.</div>
                        </div>
                        <div class="field full">
                            <asp:CheckBox ID="chkFeatured" runat="server" Text="Show as featured on home page" />
                        </div>
                    </div>
                    <div style="margin-top:20px;">
                        <asp:Button ID="btnAddProduct" runat="server" Text="Add product" CssClass="admin-btn" OnClick="btnAddProduct_Click" />
                    </div>
                </div>
            </div>

            <div class="section-card admin-section">
                <div class="eyebrow">Orders</div>
                <h2 style="margin:8px 0 18px; font-size:30px;">Delivery tracking</h2>
                <div class="table-shell">
                    <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="data-table wide-table" DataKeyNames="OrderNumber" OnRowCommand="gvOrders_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="OrderNumber" HeaderText="Order" />
                            <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:BoundField DataField="PaymentMethod" HeaderText="Payment" />
                            <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="Rs. {0:0.##}" />
                            <asp:BoundField DataField="CreatedAt" HeaderText="Created" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                            <asp:TemplateField HeaderText="Delivery">
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlDeliveryStatus" runat="server">
                                        <asp:ListItem>Processing</asp:ListItem>
                                        <asp:ListItem>Dispatched</asp:ListItem>
                                        <asp:ListItem>Delivered</asp:ListItem>
                                    </asp:DropDownList>
                                    <script runat="server">
                                    </script>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Update">
                                <ItemTemplate>
                                    <asp:Button ID="btnUpdateOrderStatus" runat="server" Text="Save" CssClass="btn-secondary" CommandName="UpdateOrderStatus" CommandArgument='<%# Eval("OrderNumber") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <div class="review-grid">
                <div class="section-card admin-section">
                    <div class="eyebrow">Reviews</div>
                    <h2 style="margin:8px 0 18px; font-size:30px;">Customer review moderation</h2>
                    <div class="table-shell">
                        <asp:GridView ID="gvReviews" runat="server" AutoGenerateColumns="False" CssClass="data-table wide-table" DataKeyNames="Id" OnRowCommand="gvReviews_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                                <asp:BoundField DataField="Location" HeaderText="Location" />
                                <asp:BoundField DataField="Rating" HeaderText="Rating" />
                                <asp:BoundField DataField="Comment" HeaderText="Comment" />
                                <asp:TemplateField HeaderText="Visible">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkApproved" runat="server" Checked='<%# Eval("Approved") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <div class="admin-actions">
                                            <asp:Button ID="btnSaveReview" runat="server" Text="Save" CssClass="btn-secondary" CommandName="UpdateReview" CommandArgument='<%# Eval("Id") %>' />
                                            <asp:Button ID="btnDeleteReview" runat="server" Text="Delete" CssClass="btn-link" CommandName="DeleteReview" CommandArgument='<%# Eval("Id") %>' />
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <div class="summary-card admin-section">
                    <div class="eyebrow">Admin credentials</div>
                    <h2 style="margin:8px 0 18px; font-size:30px;">Protected access details</h2>
                    <ul class="feature-list">
                        <li>Admin ID: <strong>admin</strong></li>
                        <li>Password: <strong>admin@123</strong></li>
                        <li>Use the orders table above to mark items as processing, dispatched, or delivered.</li>
                        <li>Customer reviews can be made visible on the storefront or removed from the list.</li>
                    </ul>
                </div>
            </div>
        </div>
</asp:Content>
