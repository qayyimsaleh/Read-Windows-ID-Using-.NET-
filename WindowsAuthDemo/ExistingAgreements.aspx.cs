using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WindowsAuthDemo
{
    public partial class ExistingAgreements : System.Web.UI.Page
    {
        // Properties using ViewState for persistence
        private int CurrentPage
        {
            get
            {
                object obj = ViewState["CurrentPage"];
                return (obj == null) ? 1 : (int)obj;
            }
            set { ViewState["CurrentPage"] = value; }
        }

        private int PageSize
        {
            get
            {
                object obj = ViewState["PageSize"];
                return (obj == null) ? 10 : (int)obj;
            }
            set { ViewState["PageSize"] = value; }
        }

        private int TotalRecords
        {
            get
            {
                object obj = ViewState["TotalRecords"];
                return (obj == null) ? 0 : (int)obj;
            }
            set { ViewState["TotalRecords"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is admin
                if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                {
                    Response.Redirect("Default.aspx");
                }

                // Initialize page
                CurrentPage = 1;
                LoadStatistics();
                LoadAgreements();
            }
        }

        private void LoadStatistics()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Total agreements
                    string totalQuery = "SELECT COUNT(*) FROM hardware_agreements";
                    using (SqlCommand totalCmd = new SqlCommand(totalQuery, connection))
                    {
                        litTotal.Text = Convert.ToInt32(totalCmd.ExecuteScalar()).ToString();
                    }

                    // Drafts
                    string draftsQuery = "SELECT COUNT(*) FROM hardware_agreements WHERE agreement_status = 'Draft'";
                    using (SqlCommand draftsCmd = new SqlCommand(draftsQuery, connection))
                    {
                        litDrafts.Text = Convert.ToInt32(draftsCmd.ExecuteScalar()).ToString();
                    }

                    // Pending
                    string pendingQuery = "SELECT COUNT(*) FROM hardware_agreements WHERE agreement_status = 'Pending'";
                    using (SqlCommand pendingCmd = new SqlCommand(pendingQuery, connection))
                    {
                        litPending.Text = Convert.ToInt32(pendingCmd.ExecuteScalar()).ToString();
                    }

                    // Active
                    string activeQuery = "SELECT COUNT(*) FROM hardware_agreements WHERE agreement_status = 'Active'";
                    using (SqlCommand activeCmd = new SqlCommand(activeQuery, connection))
                    {
                        litActive.Text = Convert.ToInt32(activeCmd.ExecuteScalar()).ToString();
                    }
                }
                catch (Exception ex)
                {
                    // Log error
                }
            }
        }

        private void LoadAgreements()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Build query with filters
                    string query = BuildQuery();

                    // Get total count for pagination
                    string countQuery = $"SELECT COUNT(*) FROM ({query}) AS CountQuery";
                    using (SqlCommand countCmd = new SqlCommand(countQuery, connection))
                    {
                        AddFilterParameters(countCmd);
                        TotalRecords = Convert.ToInt32(countCmd.ExecuteScalar());
                    }

                    // Add pagination
                    query += $" ORDER BY {GetSortField()} OFFSET {(CurrentPage - 1) * PageSize} ROWS FETCH NEXT {PageSize} ROWS ONLY";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        AddFilterParameters(command);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);

                            gvAgreements.DataSource = dt;
                            gvAgreements.DataBind();

                            // Show/hide no data message
                            pnlNoData.Visible = dt.Rows.Count == 0;
                        }
                    }

                    // Setup pagination
                    SetupPagination();
                }
                catch (Exception ex)
                {
                    // Log error
                }
            }
        }

        private string BuildQuery()
        {
            string query = @"
            SELECT a.id, a.agreement_number, m.model, a.serial_number, 
                   a.asset_number, a.agreement_status, a.it_staff_win_id, 
                   a.issue_date, a.created_date
            FROM hardware_agreements a
            LEFT JOIN hardware_model m ON a.model_id = m.id
            WHERE 1=1";

            // Add status filter
            if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
            {
                query += " AND a.agreement_status = @status";
            }

            // Add search filter
            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                query += @" AND (a.agreement_number LIKE @search 
                          OR a.serial_number LIKE @search 
                          OR a.asset_number LIKE @search
                          OR m.model LIKE @search)";
            }

            return query;
        }

        private void AddFilterParameters(SqlCommand command)
        {
            if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
            {
                command.Parameters.AddWithValue("@status", ddlStatusFilter.SelectedValue);
            }

            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                command.Parameters.AddWithValue("@search", "%" + txtSearch.Text + "%");
            }
        }

        private string GetSortField()
        {
            switch (ddlSortBy.SelectedValue)
            {
                case "created_date ASC":
                    return "a.created_date ASC";
                case "agreement_number":
                    return "a.agreement_number";
                case "agreement_status":
                    return "a.agreement_status";
                default:
                    return "a.created_date DESC";
            }
        }

        private void SetupPagination()
        {
            int totalPages = (int)Math.Ceiling((double)TotalRecords / PageSize);

            if (totalPages <= 1)
            {
                rptPagination.Visible = false;
                return;
            }

            DataTable dtPages = new DataTable();
            dtPages.Columns.Add("PageNumber");

            for (int i = 1; i <= totalPages; i++)
            {
                dtPages.Rows.Add(i);
            }

            rptPagination.DataSource = dtPages;
            rptPagination.DataBind();
            rptPagination.Visible = true;
        }

        protected void gvAgreements_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditAgreement")
            {
                int agreementId = Convert.ToInt32(e.CommandArgument);

                // Always check status before redirecting to edit
                if (IsAgreementDraft(agreementId))
                {
                    Response.Redirect($"Agreement.aspx?id={agreementId}");
                }
                else
                {
                    // Non-draft agreements go to view mode
                    Response.Redirect($"Agreement.aspx?id={agreementId}&mode=view");
                }
            }
            else if (e.CommandName == "ViewAgreement")
            {
                int agreementId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"Agreement.aspx?id={agreementId}&mode=view");
            }
            else if (e.CommandName == "DeleteAgreement")
            {
                int agreementId = Convert.ToInt32(e.CommandArgument);
                DeleteAgreement(agreementId);
            }
        }

        private bool IsAgreementDraft(int agreementId)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = "SELECT agreement_status FROM hardware_agreements WHERE id = @id";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@id", agreementId);
                        object result = command.ExecuteScalar();
                        return result?.ToString() == "Draft";
                    }
                }
                catch
                {
                    return false;
                }
            }
        }

        private void DeleteAgreement(int agreementId)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = "DELETE FROM hardware_agreements WHERE id = @id";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@id", agreementId);
                        command.ExecuteNonQuery();

                        // Reload data
                        LoadStatistics();
                        LoadAgreements();
                    }
                }
                catch (Exception ex)
                {
                    // Log error
                }
            }
        }

        protected void gvAgreements_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Get the status from the data item
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                string status = rowView["agreement_status"].ToString();

                // Find the action buttons
                LinkButton btnEdit = (LinkButton)e.Row.FindControl("btnEdit");
                LinkButton btnView = (LinkButton)e.Row.FindControl("btnView");
                LinkButton btnDelete = (LinkButton)e.Row.FindControl("btnDelete");

                // Only show Edit button for Draft status
                if (btnEdit != null)
                {
                    btnEdit.Visible = (status == "Draft");
                }

                // Show View button for all statuses (already visible by default)

                // Show Delete button for all statuses (already visible by default)

                // Optional: Change button colors based on status
                if (status == "Draft")
                {
                    e.Row.CssClass = "draft-row";
                }
                else if (status == "Pending")
                {
                    e.Row.CssClass = "pending-row";
                }
                else if (status == "Active")
                {
                    e.Row.CssClass = "active-row";
                }
                else if (status == "Inactive")
                {
                    e.Row.CssClass = "inactive-row";
                }
            }
        }
        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadAgreements();
        }

        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAgreements();
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadAgreements();
        }

        protected void rptPagination_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Page")
            {
                CurrentPage = Convert.ToInt32(e.CommandArgument);
                LoadAgreements();
            }
        }
        public string GetPageCssClass(object dataItem)
{
    if (dataItem is DataRowView rowView)
    {
        int pageNumber = Convert.ToInt32(rowView["PageNumber"]);
        return pageNumber == CurrentPage ? "page-link active" : "page-link";
    }
    return "page-link";
}
    }
}