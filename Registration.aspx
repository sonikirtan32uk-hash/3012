<%@ Page Title="Registration" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Registration.aspx.cs" Inherits="Registration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .postcode-shell
        {
            display:grid;
            gap:12px;
        }
        .postcode-row
        {
            display:grid;
            grid-template-columns:minmax(0, 1fr) auto;
            gap:10px;
            align-items:start;
        }
        .postcode-status
        {
            min-height:20px;
            color:var(--muted);
            font-size:13px;
            line-height:1.5;
        }
        .postcode-status.error
        {
            color:#b42318;
        }
        .postcode-status.success
        {
            color:var(--success);
        }
        .lookup-select
        {
            width:100%;
            padding:12px 14px;
            border-radius:14px;
            border:1px solid var(--line);
            background:#fff;
            font-family:inherit;
            font-size:14px;
        }
        .lookup-empty
        {
            display:none;
            color:#b42318;
            font-size:13px;
        }
        @media screen and (max-width: 900px)
        {
            .postcode-row
            {
                grid-template-columns:1fr;
            }
        }
    </style>
    <script type="text/javascript" src="Scripts/uk-postcode-address-lookup.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="auth-shell">
        <div class="hero-card auth-panel">
            <div class="eyebrow">Registration</div>
            <h1 class="auth-title">Create a customer account for the CasaCraft storefront.</h1>
            <p class="section-copy">The registration screen is now structured like a production form instead of a centered table. New users can create an account and then continue into login, shopping, and checkout.</p>
            <ul class="feature-list">
                <li>All core account fields are grouped with clearer visual hierarchy.</li>
                <li>Validation stays in place while the layout remains readable on smaller screens.</li>
                <li>The page now matches the rest of the storefront and admin experience.</li>
            </ul>
        </div>
        <div class="summary-card auth-card">
            <div class="eyebrow">Sign up</div>
            <h2 class="section-title">Customer details</h2>
            <div class="form-grid">
                <div class="field">
                    <asp:Label ID="Label1" runat="server" Text="First name"></asp:Label>
                    <asp:TextBox ID="txtFname" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtFname" ErrorMessage="Please enter first name" ForeColor="Red" CssClass="validator"></asp:RequiredFieldValidator>
                </div>
                <div class="field">
                    <asp:Label ID="Label2" runat="server" Text="Last name"></asp:Label>
                    <asp:TextBox ID="txtLname" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtLname" ErrorMessage="Please enter last name" ForeColor="Red" CssClass="validator"></asp:RequiredFieldValidator>
                </div>
                <div class="field">
                    <asp:Label ID="Label3" runat="server" Text="Phone number"></asp:Label>
                    <asp:TextBox ID="txtPhone" runat="server" placeholder="+44 7700 900123"></asp:TextBox>
                    <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="txtPhone" ErrorMessage="Please enter a valid phone number" ForeColor="Red" CssClass="validator" MaximumValue="99999999999" MinimumValue="10000000000" Type="Double"></asp:RangeValidator>
                </div>
                <div class="field">
                    <asp:Label ID="Label4" runat="server" Text="Email"></asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="you@example.co.uk"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail" ErrorMessage="Please enter valid email" ForeColor="Red" CssClass="validator" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                </div>
                <div class="field">
                    <asp:Label ID="Label5" runat="server" Text="Password"></asp:Label>
                    <asp:TextBox ID="txtPass" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtPass" ErrorMessage="Please enter password" ForeColor="Red" CssClass="validator"></asp:RequiredFieldValidator>
                </div>
                <div class="field">
                    <asp:Label ID="Label6" runat="server" Text="Retype password"></asp:Label>
                    <asp:TextBox ID="txtRpass" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtPass" ControlToValidate="txtRpass" ErrorMessage="Password and retype password should match" ForeColor="Red" CssClass="validator"></asp:CompareValidator>
                </div>
                <div class="field full">
                    <asp:Label ID="Label7" runat="server" Text="Postcode"></asp:Label>
                    <div class="postcode-shell">
                        <div class="postcode-row">
                            <asp:TextBox ID="txtPin" runat="server" placeholder="SW1A 1AA"></asp:TextBox>
                            <button id="registrationPostcodeLookup" type="button" class="btn-secondary">Find addresses</button>
                        </div>
                        <div id="registrationPostcodeStatus" class="postcode-status">Find the postcode to confirm the customer area before signup.</div>
                    </div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtPin" EnableViewState="False" ErrorMessage="Postcode is required" ForeColor="Red" CssClass="validator"></asp:RequiredFieldValidator>
                </div>
                <div class="field full">
                    <label for="registrationAddressSelect">Available addresses</label>
                    <select id="registrationAddressSelect" class="lookup-select" disabled="disabled"></select>
                    <div id="registrationNoResults" class="lookup-empty">No addresses were returned for that postcode.</div>
                </div>
                <div class="field full">
                    <label for="registrationSelectedAddress">Selected address</label>
                    <textarea id="registrationSelectedAddress" rows="3" readonly="readonly" placeholder="Choose an address to preview it here"></textarea>
                </div>
                <div class="field">
                    <label for="registrationCity">City</label>
                    <input id="registrationCity" type="text" readonly="readonly" />
                </div>
                <div class="field">
                    <label for="registrationCounty">County</label>
                    <input id="registrationCounty" type="text" readonly="readonly" />
                </div>
                <div class="field">
                    <label for="registrationCountry">Country</label>
                    <input id="registrationCountry" type="text" readonly="readonly" />
                </div>
            </div>
            <div class="auth-links">
                <asp:Button ID="Button1" runat="server" CssClass="btn-primary" onclick="Button1_Click" Text="Sign up" />
                <asp:Button ID="Button2" runat="server" CssClass="btn-secondary" Text="Reset" CausesValidation="false" OnClientClick="this.form.reset(); return false;" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var registrationAddressLookup = new UkPostcodeAddressLookup({
            postcodeId: '<%= txtPin.ClientID %>',
            lookupButtonId: 'registrationPostcodeLookup',
            statusId: 'registrationPostcodeStatus',
            selectId: 'registrationAddressSelect',
            noResultsId: 'registrationNoResults',
            formattedId: 'registrationSelectedAddress',
            cityId: 'registrationCity',
            countyId: 'registrationCounty',
            countryId: 'registrationCountry',
            lookupUrl: 'AddressLookup.ashx'
        });
        registrationAddressLookup.init();
    </script>
</asp:Content>
