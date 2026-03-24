using System;
using System.Collections.Generic;

public class OrderRecord
{
    public string OrderNumber { get; set; }
    public string CustomerName { get; set; }
    public string Email { get; set; }
    public string Phone { get; set; }
    public string Address { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string Pincode { get; set; }
    public string PaymentMethod { get; set; }
    public string PaymentReference { get; set; }
    public string DeliveryStatus { get; set; }
    public decimal TotalAmount { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<CartItem> Items { get; set; }
}
