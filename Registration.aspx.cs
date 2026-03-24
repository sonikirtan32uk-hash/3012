using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls.WebParts;
using System.Data;


public partial class Registration : System.Web.UI.Page
{
    SqlCommand cmd = new SqlCommand();
    SqlDataAdapter adp = new SqlDataAdapter();
    DataTable dt = new DataTable();
    private string ConnectionString
    {
        get { return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
  
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(ConnectionString))
        {
            con.Open();
            cmd = new SqlCommand("insert into reg (F_name,L_name,P_no,Email,Password,Pincode)Values (@F_name,@L_name,@P_no,@Email,@Password,@Pincode)", con);
            cmd.Parameters.AddWithValue("@F_name", txtFname.Text);
            cmd.Parameters.AddWithValue("@L_name", txtLname.Text);
            cmd.Parameters.AddWithValue("@P_no", txtPhone.Text);
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
            cmd.Parameters.AddWithValue("@Password", txtPass.Text);
            cmd.Parameters.AddWithValue("@Pincode", txtPin.Text);

            cmd.ExecuteNonQuery();
        }

        Response.Write("insert data sucessfully");
        Response.Redirect("Login.aspx");
    }
}
