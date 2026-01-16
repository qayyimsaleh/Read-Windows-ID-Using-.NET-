using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WindowsAuthDemo
{
    public partial class ReportPage : System.Web.UI.Page
    {
        private string connectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            if (!IsPostBack)
            {
                string windowsUser = User.Identity.Name;
                lblUser.Text = windowsUser;
                lblUserSidebar.Text = windowsUser;

                // Check if user is admin
                bool isAdmin = CheckUserIsAdmin(windowsUser);
                lblStatus.Text = isAdmin ? "Administrator Access" : "Standard User Access";
                lblUserRoleSidebar.Text = isAdmin ? "Administrator" : "Normal User";

                // Set default date range (last 30 days)
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");

                // Load IT Staff dropdown
                LoadITStaffDropdown();

                // Load initial data
                LoadReportData();
            }
        }

        private bool CheckUserIsAdmin(string windowsUser)
        {
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
                        return result != null && Convert.ToInt32(result) == 1;
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("Admin check error: " + ex.Message);
                    return false;
                }
            }
        }

        private void LoadITStaffDropdown()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = @"SELECT DISTINCT it_staff_win_id 
                                   FROM hardware_agreements 
                                   WHERE it_staff_win_id IS NOT NULL 
                                   AND it_staff_win_id != ''
                                   ORDER BY it_staff_win_id";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            ddlITStaff.Items.Clear();
                            ddlITStaff.Items.Add(new ListItem("All IT Staff", ""));

                            while (reader.Read())
                            {
                                string staffId = reader["it_staff_win_id"].ToString();
                                ddlITStaff.Items.Add(new ListItem(staffId, staffId));
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("IT Staff dropdown error: " + ex.Message);
                }
            }
        }

        protected void btnApplyFilters_Click(object sender, EventArgs e)
        {
            LoadReportData();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
            txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            ddlStatus.SelectedValue = "";
            ddlHardwareType.SelectedValue = "";
            ddlITStaff.SelectedValue = "";

            LoadReportData();
        }

        private void LoadReportData()
        {
            LoadKPIData();
            LoadRecentAgreements();
            LoadAccessoriesSummary();
            LoadInsights();
        }

        private void LoadKPIData()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    DateTime? startDate = null;
                    DateTime? endDate = null;

                    if (!string.IsNullOrEmpty(txtStartDate.Text))
                        startDate = DateTime.Parse(txtStartDate.Text);
                    if (!string.IsNullOrEmpty(txtEndDate.Text))
                        endDate = DateTime.Parse(txtEndDate.Text);

                    // Total Agreements
                    string totalQuery = @"SELECT COUNT(*) FROM hardware_agreements 
                                        WHERE (@startDate IS NULL OR issue_date >= @startDate)
                                        AND (@endDate IS NULL OR issue_date <= @endDate)";

                    // Pending Agreements
                    string pendingQuery = @"SELECT COUNT(*) FROM hardware_agreements 
                                          WHERE agreement_status = 'Pending'
                                          AND (@startDate IS NULL OR issue_date >= @startDate)
                                          AND (@endDate IS NULL OR issue_date <= @endDate)";

                    // Laptop Count
                    string laptopQuery = @"SELECT COUNT(*) FROM hardware_agreements ha
                                         INNER JOIN hardware_model hm ON ha.model_id = hm.id
                                         WHERE hm.type = 'Laptop'
                                         AND (@startDate IS NULL OR ha.issue_date >= @startDate)
                                         AND (@endDate IS NULL OR ha.issue_date <= @endDate)";

                    using (SqlCommand command = new SqlCommand(totalQuery, connection))
                    {
                        AddDateParameters(command, startDate, endDate);
                        litTotalAgreements.Text = command.ExecuteScalar().ToString();
                    }

                    using (SqlCommand command = new SqlCommand(pendingQuery, connection))
                    {
                        AddDateParameters(command, startDate, endDate);
                        litPendingAgreements.Text = command.ExecuteScalar().ToString();
                    }

                    using (SqlCommand command = new SqlCommand(laptopQuery, connection))
                    {
                        AddDateParameters(command, startDate, endDate);
                        litLaptopCount.Text = command.ExecuteScalar().ToString();
                    }

                    // For now, set active agreements same as total
                    litActiveAgreements.Text = litTotalAgreements.Text;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("KPI data error: " + ex.Message);
                    litTotalAgreements.Text = "0";
                    litActiveAgreements.Text = "0";
                    litPendingAgreements.Text = "0";
                    litLaptopCount.Text = "0";
                }
            }
        }

        private void LoadRecentAgreements()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    DateTime? startDate = null;
                    DateTime? endDate = null;

                    if (!string.IsNullOrEmpty(txtStartDate.Text))
                        startDate = DateTime.Parse(txtStartDate.Text);
                    if (!string.IsNullOrEmpty(txtEndDate.Text))
                        endDate = DateTime.Parse(txtEndDate.Text);

                    string query = @"SELECT TOP 10 
                                   ha.agreement_number,
                                   ISNULL(ha.employee_name, 'N/A') as employee_name,
                                   hm.model,
                                   ha.issue_date,
                                   ha.agreement_status
                                   FROM hardware_agreements ha
                                   INNER JOIN hardware_model hm ON ha.model_id = hm.id
                                   WHERE (@startDate IS NULL OR ha.issue_date >= @startDate)
                                   AND (@endDate IS NULL OR ha.issue_date <= @endDate)
                                   AND (@status = '' OR ha.agreement_status = @status)
                                   AND (@itStaff = '' OR ha.it_staff_win_id = @itStaff)
                                   ORDER BY ha.created_date DESC";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        AddDateParameters(command, startDate, endDate);
                        command.Parameters.AddWithValue("@status", ddlStatus.SelectedValue);
                        command.Parameters.AddWithValue("@itStaff", ddlITStaff.SelectedValue);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            gvRecentAgreements.DataSource = dt;
                            gvRecentAgreements.DataBind();
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("Recent agreements error: " + ex.Message);
                }
            }
        }

        private void LoadAccessoriesSummary()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("item");
            dt.Columns.Add("count");
            dt.Columns.Add("percentage");
            dt.Columns.Add("trend");

            // This is sample data - in production, you would query the database
            dt.Rows.Add("Carry Bag", 8, 80, 5);
            dt.Rows.Add("Power Adapter", 9, 90, 8);
            dt.Rows.Add("Mouse", 8, 80, -2);
            dt.Rows.Add("Wireless Mouse", 7, 70, 10);
            dt.Rows.Add("VGA Converter", 4, 40, 15);

            gvAccessories.DataSource = dt;
            gvAccessories.DataBind();
        }

        private void LoadInsights()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    DateTime? startDate = null;
                    DateTime? endDate = null;

                    if (!string.IsNullOrEmpty(txtStartDate.Text))
                        startDate = DateTime.Parse(txtStartDate.Text);
                    if (!string.IsNullOrEmpty(txtEndDate.Text))
                        endDate = DateTime.Parse(txtEndDate.Text);

                    // Laptop Percentage
                    string laptopPercentageQuery = @"SELECT 
                    ISNULL(CAST(COUNT(CASE WHEN hm.type = 'Laptop' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS INT), 0) as laptop_percentage
                    FROM hardware_agreements ha
                    INNER JOIN hardware_model hm ON ha.model_id = hm.id
                    WHERE (@startDate IS NULL OR ha.issue_date >= @startDate)
                    AND (@endDate IS NULL OR ha.issue_date <= @endDate)";

                    // Top IT Staff
                    string topITStaffQuery = @"SELECT TOP 1 it_staff_win_id
                    FROM hardware_agreements
                    WHERE (@startDate IS NULL OR issue_date >= @startDate)
                    AND (@endDate IS NULL OR issue_date <= @endDate)
                    AND it_staff_win_id IS NOT NULL
                    AND it_staff_win_id != ''
                    GROUP BY it_staff_win_id
                    ORDER BY COUNT(*) DESC";

                    using (SqlCommand command = new SqlCommand(laptopPercentageQuery, connection))
                    {
                        AddDateParameters(command, startDate, endDate);
                        object result = command.ExecuteScalar();
                        litLaptopPercentage.Text = result != null ? result.ToString() : "0";
                    }

                    using (SqlCommand command = new SqlCommand(topITStaffQuery, connection))
                    {
                        AddDateParameters(command, startDate, endDate);
                        object result = command.ExecuteScalar();
                        litTopITStaff.Text = result != null ? result.ToString() : "N/A";
                    }

                    // Average processing time (sample calculation)
                    litAvgProcessingTime.Text = "2.5";
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("Insights error: " + ex.Message);
                    litLaptopPercentage.Text = "0";
                    litTopITStaff.Text = "N/A";
                    litAvgProcessingTime.Text = "0";
                }
            }
        }

        private void AddDateParameters(SqlCommand command, DateTime? startDate, DateTime? endDate)
        {
            if (startDate.HasValue)
                command.Parameters.AddWithValue("@startDate", startDate.Value);
            else
                command.Parameters.AddWithValue("@startDate", DBNull.Value);

            if (endDate.HasValue)
                command.Parameters.AddWithValue("@endDate", endDate.Value);
            else
                command.Parameters.AddWithValue("@endDate", DBNull.Value);
        }

        protected void gvRecentAgreements_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvRecentAgreements.PageIndex = e.NewPageIndex;
            LoadRecentAgreements();
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            ExportToExcel();
        }

        private void ExportToExcel()
        {
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Hardware_Agreements_Report_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";

                DataTable dt = GetExportData();

                // Build HTML table
                StringBuilder sb = new StringBuilder();
                sb.Append("<table border='1' cellpadding='5' cellspacing='0'>");
                sb.Append("<tr>");

                // Add headers
                foreach (DataColumn column in dt.Columns)
                {
                    sb.Append("<th style='background-color: #D3D3D3;font-weight:bold;'>" + column.ColumnName + "</th>");
                }
                sb.Append("</tr>");

                // Add rows
                foreach (DataRow row in dt.Rows)
                {
                    sb.Append("<tr>");
                    foreach (DataColumn column in dt.Columns)
                    {
                        sb.Append("<td>" + row[column].ToString() + "</td>");
                    }
                    sb.Append("</tr>");
                }
                sb.Append("</table>");

                Response.Output.Write(sb.ToString());
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine("Export error: " + ex.Message);
                // Handle export error
            }
        }

        private DataTable GetExportData()
        {
            DataTable dt = new DataTable();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    DateTime? startDate = null;
                    DateTime? endDate = null;

                    if (!string.IsNullOrEmpty(txtStartDate.Text))
                        startDate = DateTime.Parse(txtStartDate.Text);
                    if (!string.IsNullOrEmpty(txtEndDate.Text))
                        endDate = DateTime.Parse(txtEndDate.Text);

                    string query = @"SELECT 
                    ha.agreement_number,
                    ISNULL(ha.employee_name, 'N/A') as employee_name,
                    hm.model,
                    hm.type as hardware_type,
                    ha.issue_date,
                    ha.agreement_status,
                    ISNULL(ha.it_staff_win_id, 'N/A') as it_staff,
                    ISNULL(ha.employee_email, 'N/A') as employee_email,
                    CASE WHEN ha.has_carry_bag = 1 THEN 'Yes' ELSE 'No' END as carry_bag,
                    CASE WHEN ha.has_power_adapter = 1 THEN 'Yes' ELSE 'No' END as power_adapter,
                    CASE WHEN ha.has_mouse = 1 THEN 'Yes' ELSE 'No' END as mouse,
                    ISNULL(ha.mouse_type, 'N/A') as mouse_type,
                    CASE WHEN ha.has_vga_converter = 1 THEN 'Yes' ELSE 'No' END as vga_converter
                    FROM hardware_agreements ha
                    INNER JOIN hardware_model hm ON ha.model_id = hm.id
                    WHERE (@startDate IS NULL OR ha.issue_date >= @startDate)
                    AND (@endDate IS NULL OR ha.issue_date <= @endDate)
                    AND (@status = '' OR ha.agreement_status = @status)
                    AND (@itStaff = '' OR ha.it_staff_win_id = @itStaff)
                    ORDER BY ha.issue_date DESC";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        AddDateParameters(command, startDate, endDate);
                        command.Parameters.AddWithValue("@status", ddlStatus.SelectedValue);
                        command.Parameters.AddWithValue("@itStaff", ddlITStaff.SelectedValue);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                        {
                            adapter.Fill(dt);
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("Export data error: " + ex.Message);
                }
            }

            return dt;
        }
    }
}