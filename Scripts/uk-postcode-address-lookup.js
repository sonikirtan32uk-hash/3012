/* Reusable UK postcode address lookup component.
   1. Validates postcode format on the client.
   2. Uses postcodes.io to verify the postcode exists.
   3. Calls a configurable address API for exact address results.
   4. Renders a selectable list and auto-fills address fields. */
(function (window) {
    'use strict';

    function UkPostcodeAddressLookup(options) {
        this.options = options || {};
        this.elements = {
            postcode: document.getElementById(this.options.postcodeId),
            lookupButton: document.getElementById(this.options.lookupButtonId),
            status: document.getElementById(this.options.statusId),
            select: document.getElementById(this.options.selectId),
            noResults: document.getElementById(this.options.noResultsId),
            street: document.getElementById(this.options.streetId),
            city: document.getElementById(this.options.cityId),
            county: document.getElementById(this.options.countyId),
            country: document.getElementById(this.options.countryId),
            formatted: document.getElementById(this.options.formattedId)
        };

        this.postcodeRegex = /^(GIR 0AA|[A-Z]{1,2}[0-9][0-9A-Z]?\s?[0-9][A-Z]{2})$/i;
    }

    UkPostcodeAddressLookup.prototype.init = function () {
        var self = this;
        if (!self.elements.postcode || !self.elements.lookupButton || !self.elements.status || !self.elements.select) {
            return;
        }

        self.elements.lookupButton.onclick = function () {
            self.lookup();
        };

        self.elements.postcode.onblur = function () {
            self.normalisePostcode();
        };

        self.elements.postcode.onkeydown = function (event) {
            event = event || window.event;
            if (event.key === 'Enter' || event.keyCode === 13) {
                if (event.preventDefault) {
                    event.preventDefault();
                }
                self.lookup();
                return false;
            }
        };

        self.elements.select.onchange = function () {
            self.applySelection();
        };
    };

    UkPostcodeAddressLookup.prototype.normalisePostcode = function () {
        var value = (this.elements.postcode.value || '').replace(/\s+/g, ' ').toUpperCase().trim();
        this.elements.postcode.value = value;
        return value;
    };

    UkPostcodeAddressLookup.prototype.setStatus = function (message, type) {
        this.elements.status.className = 'lookup-status' + (type ? ' ' + type : '');
        this.elements.status.textContent = message || '';
    };

    UkPostcodeAddressLookup.prototype.clearSelect = function () {
        this.elements.select.innerHTML = '';
        this.elements.select.disabled = true;
        if (this.elements.noResults) {
            this.elements.noResults.style.display = 'none';
        }
    };

    UkPostcodeAddressLookup.prototype.showAddresses = function (addresses) {
        var i;
        this.clearSelect();

        if (!addresses || !addresses.length) {
            if (this.elements.noResults) {
                this.elements.noResults.style.display = 'block';
            }
            return;
        }

        this.elements.select.disabled = false;
        this.elements.select.options.add(new Option('Select an address', ''));
        for (i = 0; i < addresses.length; i++) {
            this.elements.select.options.add(new Option(addresses[i].formatted, JSON.stringify(addresses[i])));
        }
    };

    UkPostcodeAddressLookup.prototype.applySelection = function () {
        var selectedValue = this.elements.select.value;
        var address;

        if (!selectedValue) {
            return;
        }

        address = JSON.parse(selectedValue);
        if (this.elements.street) {
            this.elements.street.value = [address.line1, address.street].join('\n');
        }
        if (this.elements.city) {
            this.elements.city.value = address.city || '';
        }
        if (this.elements.county) {
            this.elements.county.value = address.county || '';
        }
        if (this.elements.country) {
            this.elements.country.value = address.country || '';
        }
        if (this.elements.formatted) {
            this.elements.formatted.value = address.formatted || '';
        }

        this.setStatus('Address selected and form fields updated.', 'success');
    };

    UkPostcodeAddressLookup.prototype.lookup = function () {
        var self = this;
        var postcode = self.normalisePostcode();

        self.clearSelect();

        if (!postcode) {
            self.setStatus('Enter a postcode first.', 'error');
            return;
        }

        if (!self.postcodeRegex.test(postcode)) {
            self.setStatus('Enter a valid UK postcode format.', 'error');
            return;
        }

        self.setStatus('Validating postcode...', '');

        fetch('https://api.postcodes.io/postcodes/' + encodeURIComponent(postcode))
            .then(function (response) {
                return response.json();
            })
            .then(function (validationResponse) {
                if (!validationResponse || !validationResponse.result) {
                    throw new Error('Postcode not recognised.');
                }

                self.setStatus('Loading addresses for ' + postcode + '...', '');
                return fetch(self.options.lookupUrl + '?postcode=' + encodeURIComponent(postcode));
            })
            .then(function (response) {
                return response.json();
            })
            .then(function (addressResponse) {
                if (!addressResponse || !addressResponse.ok) {
                    throw new Error(addressResponse && addressResponse.error ? addressResponse.error : 'Address lookup failed.');
                }

                self.showAddresses(addressResponse.addresses || []);

                if (!addressResponse.addresses || !addressResponse.addresses.length) {
                    self.setStatus('No addresses were returned for that postcode.', 'error');
                    return;
                }

                self.setStatus('Choose an address from the list.', 'success');
            })
            .catch(function (error) {
                self.clearSelect();
                self.setStatus(error.message || 'We could not complete the address lookup right now.', 'error');
            });
    };

    window.UkPostcodeAddressLookup = UkPostcodeAddressLookup;
})(window);
