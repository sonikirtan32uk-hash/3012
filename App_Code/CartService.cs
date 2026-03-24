using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public static class CartService
{
    private const string CartSessionKey = "CartItems";

    public static List<CartItem> GetCart()
    {
        HttpContext context = HttpContext.Current;
        if (context.Session[CartSessionKey] == null)
        {
            context.Session[CartSessionKey] = new List<CartItem>();
        }

        return (List<CartItem>)context.Session[CartSessionKey];
    }

    public static void AddProduct(int productId)
    {
        Product product = CatalogRepository.GetById(productId);
        if (product == null)
        {
            return;
        }

        List<CartItem> cart = GetCart();
        CartItem existing = cart.FirstOrDefault(item => item.ProductId == productId);

        if (existing == null)
        {
            cart.Add(new CartItem
            {
                ProductId = product.Id,
                Name = product.Name,
                Category = product.Category,
                ImageUrl = product.ImageUrl,
                Price = product.Price,
                Quantity = 1
            });
        }
        else
        {
            existing.Quantity += 1;
        }
    }

    public static void UpdateQuantity(int productId, int quantity)
    {
        List<CartItem> cart = GetCart();
        CartItem existing = cart.FirstOrDefault(item => item.ProductId == productId);

        if (existing == null)
        {
            return;
        }

        if (quantity <= 0)
        {
            cart.Remove(existing);
        }
        else
        {
            existing.Quantity = quantity;
        }
    }

    public static void RemoveProduct(int productId)
    {
        List<CartItem> cart = GetCart();
        CartItem existing = cart.FirstOrDefault(item => item.ProductId == productId);
        if (existing != null)
        {
            cart.Remove(existing);
        }
    }

    public static void Clear()
    {
        HttpContext.Current.Session[CartSessionKey] = new List<CartItem>();
    }

    public static int GetItemCount()
    {
        return GetCart().Sum(item => item.Quantity);
    }

    public static decimal GetTotal()
    {
        return GetCart().Sum(item => item.LineTotal);
    }
}
