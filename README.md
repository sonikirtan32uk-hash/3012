# CasaCraft Decor Store

CasaCraft is an ASP.NET Web Forms decor storefront project built with C# and .NET Framework 4.x. It includes a product catalog, cart flow, checkout, and an admin panel for managing catalog items and viewing orders.

## Features

- Responsive storefront layout with shared master page styling
- Product catalog for bird houses, lamps, and statues
- Shopping cart and checkout flow
- Order summary and payment method selection
- Admin panel for product and order management
- JSON-backed catalog and order storage for storefront features

## Tech Stack

- ASP.NET Web Forms
- C#
- .NET Framework 4.x
- IIS Express
- SQL Server LocalDB / attached MDF for legacy account data

## Project Structure

- `App_Code/` shared business and data classes
- `App_Data/` local data files
- `img/` product and background images
- `MasterPage.master` shared site layout
- `Home.aspx`, `Cart.aspx`, `Payment.aspx`, `Admin.aspx` main application pages

## Run Locally

### 1. Precompile the site

```cmd
C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_compiler.exe -p "C:\Users\sonik\OneDrive\Documents\Visual Studio 2015\Projects\3013" -v / -f "C:\Users\sonik\OneDrive\Documents\Visual Studio 2015\Projects\3013\build_output"
```

### 2. Run the site

```cmd
cd /d "C:\Users\sonik\OneDrive\Documents\Visual Studio 2015\Projects\3013"
run.cmd
```

Open:

`http://localhost:8085/`

## Git Commands

```cmd
git add .
git commit -m "Update project"
git push
```

## Notes

- `build_output/` is generated output and is excluded from Git.
- Local database files are excluded from Git.
- The default site entry page is `Home.aspx`.
