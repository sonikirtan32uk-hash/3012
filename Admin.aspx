<%@ Page Title="Admin Panel" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Admin.aspx.cs" Inherits="Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
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
        .admin-grid
        {
            display:grid;
            grid-template-columns:1.1fr 0.9fr;
            gap:24px;
        }
        .admin-grid input,
        .admin-grid textarea,
        .admin-grid select
        {
            width:100%;
        }
        .image-thumb
        {
            width:70px;
            height:70px;
            object-fit:cover;
            border-radius:12px;
        }
        @media screen and (max-width: 900px)
        {
            .admin-grid
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
            <div class="eyebrow">Admin panel</div>
            <h1 class="section-title">Manage products, images, pricing, and orders</h1>
            <p class="section-copy">This panel updates the JSON-backed product catalog used by the storefront pages. Edit records inline or add new products from the form below.</p>
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
                    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" CssClass="data-table"
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
            <h2 style="margin:8px 0 18px; font-size:30px;">Recent checkout records</h2>
            <div class="table-shell">
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="data-table">
                    <Columns>
                        <asp:BoundField DataField="OrderNumber" HeaderText="Order" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="PaymentMethod" HeaderText="Payment" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="Rs. {0:0.##}" />
                        <asp:BoundField DataField="CreatedAt" HeaderText="Created" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
