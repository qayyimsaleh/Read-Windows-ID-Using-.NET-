using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WindowsAuthDemo
{
    public partial class Default : System.Web.UI.Page
    {
        protected Label lblUserRole;
        protected Label lblStatus;
        protected Label lblFirstAccess;
        protected Label lblError;
        protected System.Web.UI.HtmlControls.HtmlGenericControl normalUserContent;
        protected System.Web.UI.HtmlControls.HtmlGenericControl adminPanel;
        protected System.Web.UI.HtmlControls.HtmlGenericControl infoAuthType;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string windowsUser = User.Identity.Name;
                lblUser.Text = "Logged in as: " + windowsUser;

                // Check if user is admin and set session
                bool isAdmin = CheckUserIsAdmin(windowsUser);
                Session["IsAdmin"] = isAdmin;

                // Find controls
                lblUserRole = (Label)FindControl("lblUserRole");
                lblStatus = (Label)FindControl("lblStatus");
                lblFirstAccess = (Label)FindControl("lblFirstAccess");
                lblError = (Label)FindControl("lblError");
                normalUserContent = (System.Web.UI.HtmlControls.HtmlGenericControl)FindControl("normalUserContent");
                adminPanel = (System.Web.UI.HtmlControls.HtmlGenericControl)FindControl("adminPanel");
                infoAuthType = (System.Web.UI.HtmlControls.HtmlGenericControl)FindControl("infoAuthType");

                // Check user role and redirect accordingly
                CheckUserRoleAndRedirect(windowsUser);
            }
        }

        private bool CheckUserIsAdmin(string windowsUser)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = "SELECT admin FROM hardware_users WHERE win_id = @win_id";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@win_id", windowsUser);
                        object result = command.ExecuteScalar();

                        if (result != null && Convert.ToInt32(result) == 1)
                        {
                            return true;
                        }
                    }
                }
                catch
                {
                    // Log error
                }
            }
            return false;
        }
        private void CheckUserRoleAndRedirect(string windowsUser)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // First, check if user exists in database
                    string checkUserQuery = "SELECT admin FROM hardware_users WHERE win_id = @win_id";

                    using (SqlCommand command = new SqlCommand(checkUserQuery, connection))
                    {
                        command.Parameters.AddWithValue("@win_id", windowsUser);

                        object result = command.ExecuteScalar();

                        if (result != null)
                        {
                            // User exists, check if admin
                            int adminValue = Convert.ToInt32(result);

                            if (adminValue == 1)
                            {
                                // User is admin
                                DisplayAdminInterface();
                                if (lblUserRole != null) lblUserRole.Text = "Administrator";
                                if (lblUserRole != null) lblUserRole.CssClass = "role-admin";
                            }
                            else
                            {
                                // User is normal user
                                DisplayNormalUserInterface();
                                if (lblUserRole != null) lblUserRole.Text = "Normal User";
                                if (lblUserRole != null) lblUserRole.CssClass = "role-normal";
                            }
                        }
                        else
                        {
                            // User doesn't exist, insert as normal user
                            // Try to extract email from Windows ID (domain\username -> username@company.com)
                            string email = windowsUser.Contains("\\")
                                ? windowsUser.Split('\\')[1] + "@yourcompany.com"
                                : windowsUser + "@yourcompany.com";

                            string insertUserQuery = "INSERT INTO hardware_users (win_id, active, admin, email) VALUES (@win_id, 1, 0, @email)";

                            using (SqlCommand insertCommand = new SqlCommand(insertUserQuery, connection))
                            {
                                insertCommand.Parameters.AddWithValue("@win_id", windowsUser);
                                insertCommand.Parameters.AddWithValue("@email", email);
                                insertCommand.ExecuteNonQuery();
                            }

                            // Display normal user interface for first-time access
                            DisplayNormalUserInterface();
                            if (lblUserRole != null) lblUserRole.Text = "Normal User (First Access)";
                            if (lblUserRole != null) lblUserRole.CssClass = "role-new";
                            if (lblFirstAccess != null) lblFirstAccess.Visible = true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Log error and display normal interface as fallback
                    System.Diagnostics.Trace.WriteLine("Database error: " + ex.Message);
                    DisplayNormalUserInterface();
                    if (lblUserRole != null) lblUserRole.Text = "Normal User (Error)";
                    if (lblUserRole != null) lblUserRole.CssClass = "role-error";
                    if (lblError != null)
                    {
                        if (lblError != null)
                        {
                            lblError.Text = "Database connection error. Showing normal user interface.";
                            // OR use InnerHtml if you want HTML formatting:
                            // lblError.InnerHtml = "<strong>Error:</strong> Database connection error.";
                        }
                        lblError.Visible = true;
                    }
                }
            }
        }

        private void DisplayAdminInterface()
        {
            // Hide normal user elements
            if (normalUserContent != null) normalUserContent.Visible = false;

            // Show admin elements
            if (adminPanel != null)
            {
                adminPanel.Visible = true;
            }

            // Update UI indicators
            if (lblStatus != null)
            {
                lblStatus.Text = "Administrator Access";
                lblStatus.CssClass = "status-admin";
            }

            if (infoAuthType != null) infoAuthType.InnerText = "Windows Integrated (Admin)";
        }

        private void DisplayNormalUserInterface()
        {
            // Show normal user elements
            if (normalUserContent != null) normalUserContent.Visible = true;

            // Hide admin elements
            if (adminPanel != null) adminPanel.Visible = false;

            // Update UI indicators
            if (lblStatus != null)
            {
                lblStatus.Text = "Standard User Access";
                lblStatus.CssClass = "status-normal";
            }

            if (infoAuthType != null) infoAuthType.InnerText = "Windows Integrated";
        }
    }
}