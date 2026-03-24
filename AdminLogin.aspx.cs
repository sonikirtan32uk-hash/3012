using System;
using System.Web.UI;

public partial class AdminLogin : Page
{
    private const string AdminSessionKey = "AdminAuthenticated";
    private const string AdminId = "admin";
    private const string AdminPassword = "admin@123";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session[AdminSessionKey] != null && (bool)Session[AdminSessionKey])
        {
            Response.Redirect("Admin.aspx");
        }
    }

    protected void btnAdminLogin_Click(object sender, EventArgs e)
    {
        if (txtAdminId.Text.Trim() == AdminId && txtAdminPassword.Text == AdminPassword)
        {
            Session[AdminSessionKey] = true;
            Response.Redirect("Admin.aspx");
            return;
        }

        lblAdminLoginMessage.Text = "Invalid admin ID or password.";
        lblAdminLoginMessage.Visible = true;
    }
}
