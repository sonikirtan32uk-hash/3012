using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

public static class OrderRepository
{
    private static readonly object SyncRoot = new object();

    private static string OrdersPath
    {
        get { return HttpContext.Current.Server.MapPath("~/App_Data/orders.json"); }
    }

    public static List<OrderRecord> GetAll()
    {
        EnsureFileExists();
        string json = File.ReadAllText(OrdersPath);
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        List<OrderRecord> orders = serializer.Deserialize<List<OrderRecord>>(json) ?? new List<OrderRecord>();
        foreach (OrderRecord order in orders)
        {
            if (String.IsNullOrWhiteSpace(order.DeliveryStatus))
            {
                order.DeliveryStatus = "Processing";
            }
        }
        return orders.OrderByDescending(o => o.CreatedAt).ToList();
    }

    public static void Save(OrderRecord order)
    {
        lock (SyncRoot)
        {
            List<OrderRecord> orders = GetAll();
            orders.Add(order);
            SaveAll(orders);
        }
    }

    public static void SaveAll(List<OrderRecord> orders)
    {
        lock (SyncRoot)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            File.WriteAllText(OrdersPath, serializer.Serialize(orders));
        }
    }

    private static void EnsureFileExists()
    {
        if (!File.Exists(OrdersPath))
        {
            File.WriteAllText(OrdersPath, "[]");
        }
    }
}
