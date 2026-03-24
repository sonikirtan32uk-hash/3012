using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

public static class ReviewRepository
{
    private static readonly object SyncRoot = new object();

    private static string ReviewsPath
    {
        get { return HttpContext.Current.Server.MapPath("~/App_Data/reviews.json"); }
    }

    public static List<ReviewRecord> GetAll()
    {
        EnsureFileExists();
        string json = File.ReadAllText(ReviewsPath);
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        List<ReviewRecord> reviews = serializer.Deserialize<List<ReviewRecord>>(json) ?? new List<ReviewRecord>();
        return reviews.OrderByDescending(r => r.CreatedAt).ToList();
    }

    public static List<ReviewRecord> GetApproved(int take)
    {
        return GetAll()
            .Where(r => r.Approved)
            .OrderByDescending(r => r.CreatedAt)
            .Take(take)
            .ToList();
    }

    public static List<ReviewRecord> GetApprovedByProduct(int productId)
    {
        return GetAll()
            .Where(r => r.Approved && r.ProductId == productId)
            .OrderByDescending(r => r.CreatedAt)
            .ToList();
    }

    public static int GetNextId()
    {
        List<ReviewRecord> reviews = GetAll();
        return reviews.Count == 0 ? 1 : reviews.Max(r => r.Id) + 1;
    }

    public static void Save(ReviewRecord review)
    {
        lock (SyncRoot)
        {
            List<ReviewRecord> reviews = GetAll();
            reviews.Add(review);
            SaveAll(reviews);
        }
    }

    public static void SaveAll(List<ReviewRecord> reviews)
    {
        lock (SyncRoot)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            File.WriteAllText(ReviewsPath, serializer.Serialize(reviews));
        }
    }

    private static void EnsureFileExists()
    {
        if (!File.Exists(ReviewsPath))
        {
            File.WriteAllText(ReviewsPath, "[]");
        }
    }
}
