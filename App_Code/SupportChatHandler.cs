using System;
using System.Collections.Generic;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class SupportChatHandler : IHttpHandler, IRequiresSessionState
{
    private const string ChatSessionKey = "SupportChatHistory";

    public bool IsReusable
    {
        get { return false; }
    }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        if (String.Equals(context.Request.HttpMethod, "GET", StringComparison.OrdinalIgnoreCase))
        {
            if (String.Equals(context.Request.QueryString["action"], "clear", StringComparison.OrdinalIgnoreCase))
            {
                SaveConversationHistory(context, new List<ChatTurn>());
                WriteJson(context, new { ok = true, messages = new List<ChatTurn>() }, 200);
                return;
            }

            WriteJson(context, new { ok = true, messages = GetConversationHistory(context) }, 200);
            return;
        }

        if (!String.Equals(context.Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
        {
            WriteJson(context, new { ok = false, reply = "Only POST requests are supported." }, 405);
            return;
        }

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> payload;

        try
        {
            using (StreamReader reader = new StreamReader(context.Request.InputStream))
            {
                payload = serializer.Deserialize<Dictionary<string, object>>(reader.ReadToEnd());
            }
        }
        catch
        {
            WriteJson(context, new { ok = false, reply = "The support request could not be read." }, 400);
            return;
        }

        string userMessage = GetString(payload, "message");
        string pagePath = GetString(payload, "page");
        string friendlyPageName = GetFriendlyPageName(pagePath);
        if (String.IsNullOrWhiteSpace(userMessage))
        {
            WriteJson(context, new { ok = false, reply = "Please enter a support question." }, 400);
            return;
        }

        string apiKey = GetApiKey();
        string model = ConfigurationManager.AppSettings["OpenAIChatModel"];

        if (String.IsNullOrWhiteSpace(model))
        {
            model = "gpt-5-mini";
        }

        if (String.IsNullOrWhiteSpace(apiKey))
        {
            WriteJson(context, new
            {
                ok = false,
                reply = "The AI support assistant is not configured yet. Set the OPENAI_API_KEY environment variable or add a local OpenAIApiKey value in web.config."
            }, 503);
            return;
        }

        try
        {
            List<ChatTurn> history = GetConversationHistory(context);
            history.Add(new ChatTurn { Role = "user", Text = userMessage });

            string reply = CallOpenAI(apiKey, model, BuildSupportPrompt(context, friendlyPageName), history);

            history.Add(new ChatTurn { Role = "bot", Text = reply });
            TrimHistory(history);
            SaveConversationHistory(context, history);

            WriteJson(context, new { ok = true, reply = reply, messages = history }, 200);
        }
        catch (WebException ex)
        {
            string reply = "The AI support assistant is temporarily unavailable.";
            if (ex.Response != null)
            {
                using (StreamReader reader = new StreamReader(ex.Response.GetResponseStream()))
                {
                    string errorBody = reader.ReadToEnd();
                    LogSupportError(errorBody);
                    if (!String.IsNullOrWhiteSpace(errorBody))
                    {
                        reply = "The AI support assistant could not complete the request. Check the API key, model, or request quota.";
                    }
                }
            }
            else
            {
                LogSupportError(ex.ToString());
            }

            WriteJson(context, new { ok = false, reply = reply }, 502);
        }
        catch (Exception ex)
        {
            LogSupportError(ex.ToString());
            WriteJson(context, new { ok = false, reply = "The AI support assistant hit an unexpected error." }, 500);
        }
    }

    private static string CallOpenAI(string apiKey, string model, string systemPrompt, List<ChatTurn> history)
    {
        ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        serializer.MaxJsonLength = Int32.MaxValue;

        List<object> messages = new List<object>();
        messages.Add(new Dictionary<string, object>
        {
            { "role", "developer" },
            { "content", systemPrompt }
        });

        foreach (ChatTurn turn in history)
        {
            messages.Add(new Dictionary<string, object>
            {
                { "role", String.Equals(turn.Role, "bot", StringComparison.OrdinalIgnoreCase) ? "assistant" : "user" },
                { "content", turn.Text }
            });
        }

        Dictionary<string, object> requestBody = new Dictionary<string, object>
        {
            { "model", model },
            { "messages", messages.ToArray() },
            { "max_tokens", 220 },
            { "temperature", 0.7 }
        };

        string json = serializer.Serialize(requestBody);
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://api.openai.com/v1/chat/completions");
        request.Method = "POST";
        request.ContentType = "application/json";
        request.Accept = "application/json";
        request.Headers["Authorization"] = "Bearer " + apiKey;

        using (StreamWriter writer = new StreamWriter(request.GetRequestStream()))
        {
            writer.Write(json);
        }

        using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
        using (StreamReader reader = new StreamReader(response.GetResponseStream()))
        {
            string responseJson = reader.ReadToEnd();
            Dictionary<string, object> responseData = serializer.Deserialize<Dictionary<string, object>>(responseJson);
            object choicesObject;
            if (responseData.TryGetValue("choices", out choicesObject) && choicesObject is ArrayList)
            {
                ArrayList choices = (ArrayList)choicesObject;
                if (choices.Count > 0)
                {
                    Dictionary<string, object> firstChoice = choices[0] as Dictionary<string, object>;
                    if (firstChoice != null)
                    {
                        object messageObject;
                        if (firstChoice.TryGetValue("message", out messageObject))
                        {
                            Dictionary<string, object> message = messageObject as Dictionary<string, object>;
                            if (message != null)
                            {
                                object content;
                                if (message.TryGetValue("content", out content))
                                {
                                    string text = Convert.ToString(content);
                                    if (!String.IsNullOrWhiteSpace(text))
                                    {
                                        return text.Trim();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return "I could not generate a support answer just now. Please try again.";
    }

    private static string BuildSupportPrompt(HttpContext context, string friendlyPageName)
    {
        List<Product> products = CatalogRepository.GetAll();
        List<CartItem> cartItems = CartService.GetCart();
        int cartCount = CartService.GetItemCount();
        decimal cartTotal = CartService.GetTotal();
        string catalogSummary = BuildCatalogSummary(products);
        string cartSummary = BuildCartSummary(cartItems);

        return "You are CasaCraft Support AI for an ASP.NET decor store. " +
               "Answer only about this website and customer support tasks. " +
               "Be concise, helpful, and practical. " +
               "If asked about unavailable actions, say so clearly. " +
               "Never mention .aspx file names, server paths, code files, or internal route names in customer-facing replies. " +
               "Use friendly page names only, such as Home, Bird House, Lamps, Statues, Cart, Checkout, Reviews, Contact Us, and Admin. " +
               "Available customer-facing areas are Home, Bird House, Lamps, Statues, Cart, Checkout, Reviews, and Contact Us. " +
               "Admin page is internal only and must not expose admin workflows or credentials. " +
               "Payment methods shown in checkout are Visa or Mastercard, PayPal, Apple Pay or Google Pay, and Bank Transfer. " +
               "Reviews are submitted per product and require admin approval before public display. " +
               "The user's current page is: " + (String.IsNullOrWhiteSpace(friendlyPageName) ? "unknown" : friendlyPageName) + ". " +
               "Current cart item count: " + cartCount + ". " +
               "Current cart total in rupees: " + cartTotal.ToString("0.##") + ". " +
               "Current cart contents: " + cartSummary + ". " +
               "Current live catalog summary: " + catalogSummary + ". " +
               "If the user asks for contact help, direct them to the Contact Us page. " +
               "If the user asks how to order, explain catalog -> cart -> payment -> order confirmation. " +
               "If the user asks what products are available, answer from the live catalog summary provided. " +
               "If the user asks what is in their cart, answer from the current cart contents provided. " +
               "Do not invent return policies, shipping promises, or phone numbers.";
    }

    private static string GetFriendlyPageName(string pagePath)
    {
        if (String.IsNullOrWhiteSpace(pagePath))
        {
            return "Unknown";
        }

        string lower = pagePath.ToLowerInvariant();

        if (lower.Contains("home"))
        {
            return "Home";
        }
        if (lower.Contains("bid%20house") || lower.Contains("bid house"))
        {
            return "Bird House";
        }
        if (lower.Contains("lamp"))
        {
            return "Lamps";
        }
        if (lower.Contains("statue"))
        {
            return "Statues";
        }
        if (lower.Contains("cart"))
        {
            return "Cart";
        }
        if (lower.Contains("payment"))
        {
            return "Checkout";
        }
        if (lower.Contains("reviews"))
        {
            return "Reviews";
        }
        if (lower.Contains("contact"))
        {
            return "Contact Us";
        }
        if (lower.Contains("about"))
        {
            return "About Us";
        }
        if (lower.Contains("admin"))
        {
            return "Admin";
        }
        if (lower.Contains("login"))
        {
            return "Login";
        }
        if (lower.Contains("registration"))
        {
            return "Registration";
        }

        return "Current page";
    }

    private static string BuildCatalogSummary(List<Product> products)
    {
        if (products == null || products.Count == 0)
        {
            return "No products available.";
        }

        return String.Join(" | ",
            products
                .GroupBy(p => p.Category)
                .Select(group => group.Key + ": " + String.Join(", ",
                    group.Take(6).Select(p => p.Name + " (Rs. " + p.Price.ToString("0.##") + ")")))
                .ToArray());
    }

    private static string BuildCartSummary(List<CartItem> cartItems)
    {
        if (cartItems == null || cartItems.Count == 0)
        {
            return "Cart is empty";
        }

        return String.Join(", ",
            cartItems.Select(item => item.Name + " x" + item.Quantity + " (Rs. " + item.LineTotal.ToString("0.##") + ")").ToArray());
    }

    private static string GetString(IDictionary<string, object> data, string key)
    {
        object value;
        return data != null && data.TryGetValue(key, out value) && value != null ? Convert.ToString(value) : String.Empty;
    }

    private static string GetApiKey()
    {
        string apiKey = Environment.GetEnvironmentVariable("OPENAI_API_KEY");
        if (!String.IsNullOrWhiteSpace(apiKey))
        {
            return apiKey;
        }

        return ConfigurationManager.AppSettings["OpenAIApiKey"];
    }

    private static List<ChatTurn> GetConversationHistory(HttpContext context)
    {
        List<ChatTurn> history = context.Session[ChatSessionKey] as List<ChatTurn>;
        if (history == null)
        {
            history = new List<ChatTurn>();
            context.Session[ChatSessionKey] = history;
        }

        return history;
    }

    private static void SaveConversationHistory(HttpContext context, List<ChatTurn> history)
    {
        context.Session[ChatSessionKey] = history;
    }

    private static void TrimHistory(List<ChatTurn> history)
    {
        int maxTurns = 12;
        while (history.Count > maxTurns)
        {
            history.RemoveAt(0);
        }
    }

    private static void WriteJson(HttpContext context, object value, int statusCode)
    {
        context.Response.StatusCode = statusCode;
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        context.Response.Write(serializer.Serialize(value));
    }

    private static void LogSupportError(string text)
    {
        try
        {
            string path = HttpContext.Current.Server.MapPath("~/App_Data/supportchat-errors.log");
            File.AppendAllText(path, DateTime.Now.ToString("s") + " " + text + Environment.NewLine + Environment.NewLine);
        }
        catch
        {
        }
    }

    [Serializable]
    private class ChatTurn
    {
        public string Role { get; set; }
        public string Text { get; set; }
    }
}
