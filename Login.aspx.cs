using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

public partial class Login : System.Web.UI.Page
{
    SqlCommand cmd = new SqlCommand();
    SqlDataAdapter adp = new SqlDataAdapter();
    DataSet ds = new DataSet();
    private string ConnectionString
    {
        get { return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
    }
   
    protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
    {
        using (SqlConnection con = new SqlConnection(ConnectionString))
        {
            con.Open();
            cmd = new SqlCommand("select * from reg where Email=@Email and Password=@Password", con);
            cmd.Parameters.AddWithValue("@Email", Login1.UserName);
            cmd.Parameters.AddWithValue("@Password", Login1.Password);

            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                if (dr.Read())
                {
                    Response.Redirect("Home.aspx");
                }
                else
                {
                    Response.Write("Pleasw Enter Valid Email and Password");
                }
            }
        }
    }
}
