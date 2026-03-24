using System;

public class ReviewRecord
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; }
    public string CustomerName { get; set; }
    public string Location { get; set; }
    public int Rating { get; set; }
    public string Comment { get; set; }
    public bool Approved { get; set; }
    public DateTime CreatedAt { get; set; }
}
