using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;

public class AddressLookupHandler : IHttpHandler
{
    private static readonly Regex UkPostcodeRegex = new Regex(
        "^(GIR 0AA|[A-Z]{1,2}[0-9][0-9A-Z]?\\s?[0-9][A-Z]{2})$",
        RegexOptions.IgnoreCase | RegexOptions.Compiled);

    public bool IsReusable
    {
        get { return false; }
    }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Cache.SetCacheability(HttpCacheability.NoCache);

        string postcode = (context.Request["postcode"] ?? string.Empty).Trim().ToUpperInvariant();
        JavaScriptSerializer serializer = new JavaScriptSerializer();

        if (string.IsNullOrEmpty(postcode))
        {
            context.Response.StatusCode = 400;
            context.Response.Write(serializer.Serialize(new
            {
                ok = false,
                error = "Enter a postcode."
            }));
            return;
        }

        if (!UkPostcodeRegex.IsMatch(postcode))
        {
            context.Response.StatusCode = 400;
            context.Response.Write(serializer.Serialize(new
            {
                ok = false,
                error = "Enter a valid UK postcode."
            }));
            return;
        }

        string normalisedPostcode = Regex.Replace(postcode, "\\s+", " ").Trim();
        List<object> addresses = GetPlaceholderAddresses(normalisedPostcode);

        context.Response.StatusCode = 200;
        context.Response.Write(serializer.Serialize(new
        {
            ok = true,
            postcode = normalisedPostcode,
            addresses = addresses
        }));
    }

    private static List<object> GetPlaceholderAddresses(string postcode)
    {
        Dictionary<string, List<object>> addressBook = new Dictionary<string, List<object>>(StringComparer.OrdinalIgnoreCase)
        {
            {
                "SW1A 1AA",
                new List<object>
                {
                    CreateAddress("Buckingham Palace", "Buckingham Palace Road", "London", "Greater London", postcode, "England"),
                    CreateAddress("The Royal Mews", "Buckingham Palace Road", "London", "Greater London", postcode, "England"),
                    CreateAddress("Queen's Gallery Entrance", "Buckingham Palace Road", "London", "Greater London", postcode, "England")
                }
            },
            {
                "EC1A 1BB",
                new List<object>
                {
                    CreateAddress("1 St. Martin's Le Grand", "St. Martin's Le Grand", "London", "City of London", postcode, "England"),
                    CreateAddress("2 St. Martin's Le Grand", "St. Martin's Le Grand", "London", "City of London", postcode, "England"),
                    CreateAddress("General Post Office Building", "St. Martin's Le Grand", "London", "City of London", postcode, "England")
                }
            },
            {
                "M1 1AE",
                new List<object>
                {
                    CreateAddress("1 Piccadilly Place", "Aytoun Street", "Manchester", "Greater Manchester", postcode, "England"),
                    CreateAddress("2 Piccadilly Place", "Aytoun Street", "Manchester", "Greater Manchester", postcode, "England"),
                    CreateAddress("Piccadilly Plaza", "Portland Street", "Manchester", "Greater Manchester", postcode, "England")
                }
            },
            {
                "B1 1TB",
                new List<object>
                {
                    CreateAddress("1 Brindleyplace", "Brindleyplace", "Birmingham", "West Midlands", postcode, "England"),
                    CreateAddress("2 Brindleyplace", "Brindleyplace", "Birmingham", "West Midlands", postcode, "England"),
                    CreateAddress("3 Brindleyplace", "Brindleyplace", "Birmingham", "West Midlands", postcode, "England")
                }
            }
        };

        if (addressBook.ContainsKey(postcode))
        {
            return addressBook[postcode];
        }

        return new List<object>();
    }

    private static object CreateAddress(string line1, string street, string city, string county, string postcode, string country)
    {
        return new
        {
            line1 = line1,
            street = street,
            city = city,
            county = county,
            postcode = postcode,
            country = country,
            formatted = string.Format("{0}, {1}, {2}, {3}, {4}", line1, street, city, county, postcode)
        };
    }
}
