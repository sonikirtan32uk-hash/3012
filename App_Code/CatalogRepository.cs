using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

public static class CatalogRepository
{
    private static readonly object SyncRoot = new object();

    private static string ProductsPath
    {
        get { return HttpContext.Current.Server.MapPath("~/App_Data/products.json"); }
    }

    public static List<Product> GetAll()
    {
        EnsureFileExists();
        string json = File.ReadAllText(ProductsPath);
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        List<Product> products = serializer.Deserialize<List<Product>>(json) ?? new List<Product>();
        return products.OrderBy(p => p.Category).ThenBy(p => p.Name).ToList();
    }

    public static List<Product> GetByCategory(string category)
    {
        return GetAll()
            .Where(p => string.Equals(p.Category, category, StringComparison.OrdinalIgnoreCase))
            .OrderBy(p => p.Name)
            .ToList();
    }

    public static List<Product> GetFeatured(int count)
    {
        return GetAll()
            .Where(p => p.Featured)
            .Take(count)
            .ToList();
    }

    public static Product GetById(int id)
    {
        return GetAll().FirstOrDefault(p => p.Id == id);
    }

    public static void SaveAll(List<Product> products)
    {
        lock (SyncRoot)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string json = serializer.Serialize(products.OrderBy(p => p.Category).ThenBy(p => p.Name).ToList());
            File.WriteAllText(ProductsPath, json);
        }
    }

    public static int GetNextId()
    {
        List<Product> products = GetAll();
        return products.Count == 0 ? 1 : products.Max(p => p.Id) + 1;
    }

    private static void EnsureFileExists()
    {
        if (!File.Exists(ProductsPath))
        {
            File.WriteAllText(ProductsPath, "[]");
        }
    }
}
