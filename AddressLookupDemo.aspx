<%@ Page Title="Address Lookup Demo" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .lookup-shell
        {
            max-width:860px;
            margin:34px auto 0;
            display:grid;
            gap:24px;
        }
        .lookup-card
        {
            padding:28px;
        }
        .lookup-row
        {
            display:grid;
            grid-template-columns:minmax(0, 1fr) auto;
            gap:12px;
            align-items:start;
        }
        .lookup-status
        {
            min-height:20px;
            color:var(--muted);
            font-size:13px;
            line-height:1.5;
        }
        .lookup-status.error
        {
            color:#b42318;
        }
        .lookup-status.success
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
            .lookup-row
            {
                grid-template-columns:1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="lookup-shell">
        <div class="section-card lookup-card">
            <div class="eyebrow">Example component</div>
            <h1 class="section-title">UK postcode address lookup</h1>
            <p class="section-copy">This example validates the postcode with Postcodes.io, then calls a placeholder address API inside this project to load available addresses for that postcode.</p>
        </div>

        <div class="summary-card lookup-card">
            <div class="form-grid">
                <div class="field full">
                    <label for="demoPostcode">Postcode</label>
                    <div class="lookup-row">
                        <input id="demoPostcode" type="text" placeholder="SW1A 1AA" />
                        <button id="demoLookupButton" type="button" class="btn-secondary">Find addresses</button>
                    </div>
                    <div id="demoLookupStatus" class="lookup-status">Try `SW1A 1AA`, `EC1A 1BB`, `M1 1AE`, or `B1 1TB`.</div>
                </div>

                <div class="field full">
                    <label for="demoAddressSelect">Available addresses</label>
                    <select id="demoAddressSelect" class="lookup-select" disabled="disabled"></select>
                    <div id="demoNoResults" class="lookup-empty">No addresses were found for that postcode.</div>
                </div>

                <div class="field full">
                    <label for="demoStreet">Street / address lines</label>
                    <textarea id="demoStreet" rows="3" placeholder="Selected address lines will appear here"></textarea>
                </div>
                <div class="field">
                    <label for="demoCity">City</label>
                    <input id="demoCity" type="text" />
                </div>
                <div class="field">
                    <label for="demoCounty">County</label>
                    <input id="demoCounty" type="text" />
                </div>
                <div class="field">
                    <label for="demoCountry">Country</label>
                    <input id="demoCountry" type="text" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="Scripts/uk-postcode-address-lookup.js"></script>
    <script type="text/javascript">
        var lookup = new UkPostcodeAddressLookup({
            postcodeId: 'demoPostcode',
            lookupButtonId: 'demoLookupButton',
            statusId: 'demoLookupStatus',
            selectId: 'demoAddressSelect',
            noResultsId: 'demoNoResults',
            streetId: 'demoStreet',
            cityId: 'demoCity',
            countyId: 'demoCounty',
            countryId: 'demoCountry',
            lookupUrl: 'AddressLookup.ashx'
        });

        lookup.init();
    </script>
</asp:Content>
