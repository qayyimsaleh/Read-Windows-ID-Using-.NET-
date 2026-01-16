using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace WindowsAuthDemo
{
    public partial class Agreement : System.Web.UI.Page
    {
        private int? currentAgreementId = null;
        private bool isEditMode = false;
        private bool isViewMode = false;
        private string currentStatus = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Add this line to populate the sidebar user name
                lblUserName.Text = User.Identity.Name;

                // Add this line to set the status label in the info bar
                lblCurrentStatus.Text = currentStatus;
                // Check if user is admin
                if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                {
                    Response.Redirect("Default.aspx");
                }

                // Check mode from query string
                string mode = Request.QueryString["mode"];
                isViewMode = (mode == "view");

                // Check if editing/viewing existing agreement
                if (Request.QueryString["id"] != null)
                {
                    int agreementId;
                    if (int.TryParse(Request.QueryString["id"], out agreementId))
                    {
                        currentAgreementId = agreementId;

                        // Load the agreement to check its status
                        LoadAgreementStatus(agreementId);

                        // Set modes based on status and query string
                        if (isViewMode)
                        {
                            isEditMode = false;
                        }
                        else
                        {
                            // Only allow edit mode if status is Draft
                            isEditMode = (currentStatus == "Draft");

                            // If trying to edit a non-draft agreement, force view mode
                            if (!isEditMode)
                            {
                                isViewMode = true;
                                Response.Redirect($"Agreement.aspx?id={agreementId}&mode=view");
                                return;
                            }
                        }
                    }
                }

                // Auto-fill IT Staff (current user)
                txtITStaff.Text = User.Identity.Name;

                // Load hardware models from database
                LoadHardwareModels();

                // Load employee emails from database
                LoadEmployeeEmails();

                // If edit/view mode, load existing data
                if (currentAgreementId.HasValue)
                {
                    LoadExistingAgreement(currentAgreementId.Value);
                }

                // Setup page based on mode
                SetupPageMode();

                // Hide messages initially
                messageSuccess.Visible = false;
                messageError.Visible = false;
            }
        }

        // Handle dropdown selection change
        protected void ddlModel_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Show/hide "Other" model panel based on selection
            pnlOtherModel.Visible = (ddlModel.SelectedValue == "OTHER");

            // Enable/disable validators for "Other" model
            rfvOtherModel.Enabled = (ddlModel.SelectedValue == "OTHER");
            rfvDeviceType.Enabled = (ddlModel.SelectedValue == "OTHER");
        }

        private void LoadAgreementStatus(int agreementId)
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
                        currentStatus = result?.ToString() ?? "";
                    }
                }
                catch (Exception ex)
                {
                    // Log error
                    currentStatus = "";
                }
            }
        }

        private void SetupPageMode()
        {
            if (isViewMode)
            {
                // View Mode - Readonly
                SetFormReadOnly(true);
                litPageTitle.Text = "View Agreement - Windows Auth Demo";
                litHeaderTitle.Text = "View Hardware Agreement";
                litHeaderDescription.Text = "View agreement details (Read-only)";

                // Hide action buttons
                btnSaveDraft.Visible = false;
                btnSubmit.Visible = false;
                btnEdit.Visible = (currentStatus == "Draft"); // Only show Edit if it's a draft

                // Show agreement info
                agreementInfo.Visible = true;
            }
            else if (isEditMode)
            {
                // Edit Mode - but double check it's actually a draft
                if (currentStatus != "Draft")
                {
                    // This shouldn't happen due to redirect in Page_Load, but just in case
                    SetFormReadOnly(true);
                    litPageTitle.Text = "View Agreement - Windows Auth Demo";
                    litHeaderTitle.Text = "View Agreement (Read-only)";
                    litHeaderDescription.Text = "This agreement cannot be edited as it's not in draft status.";

                    // Hide edit buttons
                    btnSaveDraft.Visible = false;
                    btnSubmit.Visible = false;
                    btnEdit.Visible = false;
                }
                else
                {
                    // Valid edit mode for draft
                    SetFormReadOnly(false);
                    litPageTitle.Text = "Edit Agreement - Windows Auth Demo";
                    litHeaderTitle.Text = "Edit Hardware Agreement";
                    litHeaderDescription.Text = "Edit draft agreement details";

                    btnSaveDraft.Text = "Update Draft";
                    btnSubmit.Text = "Update and Submit";
                    btnSaveDraft.Visible = true;
                    btnSubmit.Visible = true;
                    btnEdit.Visible = false;
                }

                // Show agreement info
                agreementInfo.Visible = true;
            }
            else
            {
                // Create Mode
                SetFormReadOnly(false);
                litPageTitle.Text = "Create New Agreement - Windows Auth Demo";
                litHeaderTitle.Text = "Create New Hardware Agreement";
                litHeaderDescription.Text = "Fill in the details for the new laptop/desktop agreement";

                btnSaveDraft.Text = "Save as Draft";
                btnSubmit.Text = "Submit Agreement";
                btnSaveDraft.Visible = true;
                btnSubmit.Visible = true;
                btnEdit.Visible = false;

                // Hide agreement info for new agreements
                agreementInfo.Visible = false;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Additional security check on every postback
            if (currentAgreementId.HasValue && isEditMode)
            {
                string actualStatus = GetCurrentAgreementStatus();
                if (actualStatus != "Draft")
                {
                    // Force view mode if someone tampered with the form
                    isEditMode = false;
                    isViewMode = true;
                    SetFormReadOnly(true);
                    btnSaveDraft.Visible = false;
                    btnSubmit.Visible = false;
                    btnEdit.Visible = (actualStatus == "Draft");

                    ShowError("This agreement cannot be edited as it's not in draft status.");
                }
            }
        }

        private void SaveAgreement(string action)
        {
            // Validate model selection
            if (string.IsNullOrEmpty(ddlModel.SelectedValue))
            {
                ShowError("Please select a hardware model.");
                return;
            }

            // If "Other" is selected, validate the model name and type
            if (ddlModel.SelectedValue == "OTHER")
            {
                if (string.IsNullOrEmpty(txtOtherModel.Text.Trim()))
                {
                    ShowError("Please enter a model name for the 'Other' option.");
                    return;
                }

                if (string.IsNullOrEmpty(ddlDeviceType.SelectedValue))
                {
                    ShowError("Please select a device type for the new model.");
                    return;
                }
            }

            // Validate email fields for submission
            if (action == "Submitted")
            {
                if (string.IsNullOrEmpty(ddlEmployeeEmail.SelectedValue) ||
                    string.IsNullOrEmpty(ddlHODEmail.SelectedValue))
                {
                    ShowError("Both Employee Email and HOD Email are required for submission.");
                    return;
                }
            }

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Get or create model ID
                    int modelId = GetOrCreateModelId(connection);

                    // Check if we have an ID in query string and it's a draft
                    if (Request.QueryString["id"] != null)
                    {
                        int agreementId;
                        if (int.TryParse(Request.QueryString["id"], out agreementId))
                        {
                            // Check if it's actually a draft
                            string status = GetAgreementStatus(agreementId);
                            if (status == "Draft")
                            {
                                // UPDATE existing draft
                                UpdateAgreement(connection, action, agreementId, modelId);
                                return;
                            }
                        }
                    }

                    // If no ID or not a draft, CREATE new
                    CreateNewAgreement(connection, action, modelId);
                }
                catch (Exception ex)
                {
                    ShowError("Database error: " + ex.Message);
                }
            }
        }

        // Get or create model ID
        private int GetOrCreateModelId(SqlConnection connection)
        {
            if (ddlModel.SelectedValue == "OTHER")
            {
                string newModelName = txtOtherModel.Text.Trim();
                string deviceType = ddlDeviceType.SelectedValue;

                if (string.IsNullOrEmpty(newModelName))
                {
                    throw new Exception("Please enter a model name for the 'Other' option.");
                }

                if (string.IsNullOrEmpty(deviceType))
                {
                    throw new Exception("Please select a device type for the new model.");
                }

                // Check if model already exists
                string checkQuery = "SELECT id FROM hardware_model WHERE model = @model";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, connection))
                {
                    checkCmd.Parameters.AddWithValue("@model", newModelName);
                    object existingId = checkCmd.ExecuteScalar();

                    if (existingId != null)
                    {
                        return Convert.ToInt32(existingId);
                    }
                }

                // Insert new model with type
                string insertQuery = "INSERT INTO hardware_model (model, type, created_date) VALUES(@model, @type, GETDATE());SELECT SCOPE_IDENTITY(); ";


                using (SqlCommand insertCmd = new SqlCommand(insertQuery, connection))
                {
                    insertCmd.Parameters.AddWithValue("@model", newModelName);
                    insertCmd.Parameters.AddWithValue("@type", deviceType);
                    return Convert.ToInt32(insertCmd.ExecuteScalar());
                }
            }
            else
            {
                return Convert.ToInt32(ddlModel.SelectedValue);
            }
        }

        private string GetAgreementStatus(int agreementId)
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
                        return result?.ToString() ?? "";
                    }
                }
                catch
                {
                    return "";
                }
            }
        }

        private string GetCurrentAgreementStatus()
        {
            if (!currentAgreementId.HasValue) return "";

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = "SELECT agreement_status FROM hardware_agreements WHERE id = @id";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@id", currentAgreementId.Value);
                        object result = command.ExecuteScalar();
                        return result?.ToString() ?? "";
                    }
                }
                catch
                {
                    return "";
                }
            }
        }

        private void SetFormReadOnly(bool readOnly)
        {
            // Add/remove readonly class to form container
            if (readOnly)
            {
                formContainer.Attributes["class"] = formContainer.Attributes["class"] + " view-mode";
            }

            // Find controls if they're not accessible directly
            TextBox txtRemarksControl = (TextBox)FindControl("txtRemarks");
            TextBox txtSerialNumberControl = (TextBox)FindControl("txtSerialNumber");
            TextBox txtAssetNumberControl = (TextBox)FindControl("txtAssetNumber");
            TextBox txtOtherAccessoriesControl = (TextBox)FindControl("txtOtherAccessories");
            TextBox txtOtherModelControl = (TextBox)FindControl("txtOtherModel");

            if (txtRemarksControl != null) txtRemarksControl.ReadOnly = readOnly;
            if (txtSerialNumberControl != null) txtSerialNumberControl.ReadOnly = readOnly;
            if (txtAssetNumberControl != null) txtAssetNumberControl.ReadOnly = readOnly;
            if (txtOtherAccessoriesControl != null) txtOtherAccessoriesControl.ReadOnly = readOnly;
            if (txtOtherModelControl != null) txtOtherModelControl.ReadOnly = readOnly;

            // Enable/disable dropdowns and other controls
            ddlModel.Enabled = !readOnly;
            ddlDeviceType.Enabled = !readOnly;
            ddlEmployeeEmail.Enabled = !readOnly;
            ddlHODEmail.Enabled = !readOnly;
            chkCarryBag.Enabled = !readOnly;
            chkPowerAdapter.Enabled = !readOnly;
            chkMouse.Enabled = !readOnly;
            rbWired.Enabled = !readOnly;
            rbWireless.Enabled = !readOnly;
            chkVGAConverter.Enabled = !readOnly;
            rbActive.Enabled = !readOnly;
            rbInactive.Enabled = !readOnly;

            // Add readonly CSS class
            if (readOnly)
            {
                if (txtSerialNumberControl != null) txtSerialNumberControl.CssClass += " readonly-control";
                if (txtAssetNumberControl != null) txtAssetNumberControl.CssClass += " readonly-control";
                if (txtOtherAccessoriesControl != null) txtOtherAccessoriesControl.CssClass += " readonly-control";
                if (txtRemarksControl != null) txtRemarksControl.CssClass += " readonly-control";
                if (txtOtherModelControl != null) txtOtherModelControl.CssClass += " readonly-control";
                ddlModel.CssClass += " readonly-control";
                ddlDeviceType.CssClass += " readonly-control";
                ddlEmployeeEmail.CssClass += " readonly-control";
                ddlHODEmail.CssClass += " readonly-control";
            }
        }

        private void LoadExistingAgreement(int agreementId)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = @"
                SELECT a.*, m.model, m.type,
                       CONVERT(varchar, a.created_date, 103) as created_date_display,
                       CONVERT(varchar, a.last_updated, 103) as last_updated_display
                FROM hardware_agreements a
                LEFT JOIN hardware_model m ON a.model_id = m.id
                WHERE a.id = @id";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@id", agreementId);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Store current status
                                currentStatus = reader["agreement_status"].ToString();

                                // Display agreement info
                                agreementNumberDisplay.InnerText = reader["agreement_number"].ToString();
                                createdDateDisplay.InnerText = reader["created_date_display"].ToString();
                                updatedDateDisplay.InnerText = reader["last_updated_display"].ToString();

                                // Add status badge
                                string statusBadgeClass = "status-" + currentStatus.ToLower();
                                litStatusBadge.Text = $"<span class='status-badge {statusBadgeClass}'>{currentStatus}</span>";

                                // Set model - find by value
                                string modelId = reader["model_id"].ToString();
                                if (!string.IsNullOrEmpty(modelId))
                                {
                                    ListItem item = ddlModel.Items.FindByValue(modelId);
                                    if (item != null)
                                    {
                                        ddlModel.SelectedValue = modelId;
                                    }
                                    // REMOVED: lblModelDisplay.Text reference
                                }

                                txtSerialNumber.Text = reader["serial_number"].ToString();
                                txtAssetNumber.Text = reader["asset_number"].ToString();

                                // Load email fields - find by value in dropdown
                                string employeeEmail = reader["employee_email"]?.ToString();
                                string hodEmail = reader["hod_email"]?.ToString();

                                if (!string.IsNullOrEmpty(employeeEmail))
                                {
                                    ListItem empItem = ddlEmployeeEmail.Items.FindByValue(employeeEmail);
                                    if (empItem != null)
                                    {
                                        ddlEmployeeEmail.SelectedValue = employeeEmail;
                                    }
                                    else
                                    {
                                        // If email not in list, add it
                                        ddlEmployeeEmail.Items.Add(new ListItem(employeeEmail + " (Not in list)", employeeEmail));
                                        ddlEmployeeEmail.SelectedValue = employeeEmail;
                                    }
                                }

                                if (!string.IsNullOrEmpty(hodEmail))
                                {
                                    ListItem hodItem = ddlHODEmail.Items.FindByValue(hodEmail);
                                    if (hodItem != null)
                                    {
                                        ddlHODEmail.SelectedValue = hodEmail;
                                    }
                                    else
                                    {
                                        // If email not in list, add it
                                        ddlHODEmail.Items.Add(new ListItem(hodEmail + " (Not in list)", hodEmail));
                                        ddlHODEmail.SelectedValue = hodEmail;
                                    }
                                }

                                // Load accessories
                                bool hasCarryBag = Convert.ToBoolean(reader["has_carry_bag"]);
                                bool hasPowerAdapter = Convert.ToBoolean(reader["has_power_adapter"]);
                                bool hasMouse = Convert.ToBoolean(reader["has_mouse"]);
                                bool hasVGAConverter = Convert.ToBoolean(reader["has_vga_converter"]);

                                chkCarryBag.Checked = hasCarryBag;
                                chkPowerAdapter.Checked = hasPowerAdapter;
                                chkMouse.Checked = hasMouse;
                                chkVGAConverter.Checked = hasVGAConverter;

                                // REMOVED: All display label references
                                // lblCarryBagDisplay.Text = hasCarryBag ? "Yes" : "No";
                                // lblPowerAdapterDisplay.Text = hasPowerAdapter ? "Yes" : "No";
                                // lblMouseDisplay.Text = hasMouse ? "Yes" : "No";
                                // lblVGAConverterDisplay.Text = hasVGAConverter ? "Yes" : "No";

                                string mouseType = reader["mouse_type"]?.ToString();
                                rbWired.Checked = (mouseType == "Wired");
                                rbWireless.Checked = (mouseType == "Wireless");

                                // REMOVED: Mouse type display references
                                // if (hasMouse)
                                // {
                                //     lblMouseTypeDisplay.Text = mouseType == "Wired" ? "Wired" : "Wireless";
                                //     lblWirelessDisplay.Text = mouseType == "Wireless" ? "Wireless" : "";
                                // }
                                // else
                                // {
                                //     lblMouseTypeDisplay.Text = "Not Selected";
                                // }

                                txtOtherAccessories.Text = reader["other_accessories"]?.ToString();

                                // Load IT details
                                txtITStaff.Text = reader["it_staff_win_id"].ToString();
                                txtDateIssue.Text = Convert.ToDateTime(reader["issue_date"]).ToString("dd/MM/yyyy");

                                // Load remarks
                                TextBox txtRemarksControl = (TextBox)FindControl("txtRemarks");
                                if (txtRemarksControl != null)
                                {
                                    txtRemarksControl.Text = reader["remarks"]?.ToString();
                                }

                                string status = reader["agreement_status"].ToString();
                                if (status == "Active" || status == "Pending" || status == "Inactive")
                                {
                                    bool isActive = (status == "Active" || status == "Pending");
                                    rbActive.Checked = isActive;
                                    rbInactive.Checked = !isActive;

                                    // REMOVED: Display label references
                                    // Label lblStatusDisplayControl = (Label)FindControl("lblStatusDisplay");
                                    // Label lblInactiveDisplayControl = (Label)FindControl("lblInactiveDisplay");
                                    // 
                                    // if (lblStatusDisplayControl != null && lblInactiveDisplayControl != null)
                                    // {
                                    //     lblStatusDisplayControl.Text = isActive ? "Active" : "";
                                    //     lblInactiveDisplayControl.Text = !isActive ? "Inactive" : "";
                                    // }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error loading agreement: " + ex.Message);
                }
            }
        }

        private void LoadHardwareModels()
        {
            // Clear existing items first
            ddlModel.Items.Clear();

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = "SELECT id, model, type FROM hardware_model ORDER BY model";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            ddlModel.Items.Add(new ListItem("-- Select Model --", ""));

                            while (reader.Read())
                            {
                                string modelName = reader["model"].ToString();
                                string modelType = reader["type"].ToString();
                                string displayText = $"{modelName} ({modelType})";

                                ddlModel.Items.Add(new ListItem(
                                    displayText,
                                    reader["id"].ToString()
                                ));
                            }

                            // Add "Other" option at the end
                            ddlModel.Items.Add(new ListItem("-- Other (Add New) --", "OTHER"));
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error loading hardware models: " + ex.Message);
                    ddlModel.Items.Add(new ListItem("-- Error loading models --", ""));
                }
            }
        }

        private void LoadEmployeeEmails()
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = "SELECT email, win_id FROM hardware_users WHERE active = 1 AND email IS NOT NULL ORDER BY win_id";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            ddlEmployeeEmail.Items.Clear();
                            ddlHODEmail.Items.Clear();

                            // Add default items
                            ddlEmployeeEmail.Items.Add(new ListItem("-- Select Employee Email --", ""));
                            ddlHODEmail.Items.Add(new ListItem("-- Select HOD Email --", ""));

                            while (reader.Read())
                            {
                                string email = reader["email"].ToString();
                                string winId = reader["win_id"].ToString();
                                string displayText = $"{email} ({winId})";

                                // Add to both dropdowns
                                ddlEmployeeEmail.Items.Add(new ListItem(displayText, email));
                                ddlHODEmail.Items.Add(new ListItem(displayText, email));
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error loading employee emails: " + ex.Message);
                    // Fallback to empty dropdowns
                    ddlEmployeeEmail.Items.Clear();
                    ddlHODEmail.Items.Clear();
                    ddlEmployeeEmail.Items.Add(new ListItem("-- Error loading emails --", ""));
                    ddlHODEmail.Items.Add(new ListItem("-- Error loading emails --", ""));
                }
            }
        }

        // Create new agreement with modelId parameter
        private void CreateNewAgreement(SqlConnection connection, string action, int modelId)
        {
            // Generate agreement number
            string agreementNumber = GenerateAgreementNumber();

            // Determine status and dates
            string finalStatus;
            DateTime? submittedDate = null;
            DateTime issueDate = DateTime.Now;

            if (action == "Draft")
            {
                finalStatus = "Draft";
            }
            else // Submitted
            {
                submittedDate = DateTime.Now;
                issueDate = submittedDate.Value;
                finalStatus = "Pending"; // Always Pending first on submit
            }

            string query = @"
    INSERT INTO hardware_agreements 
    (agreement_number, model_id, serial_number, asset_number, 
     has_carry_bag, has_power_adapter, has_mouse, mouse_type, 
     has_vga_converter, other_accessories, it_staff_win_id, 
     issue_date, remarks, agreement_status, submitted_date, created_date,
     employee_email, hod_email)
    VALUES 
    (@agreementNumber, @modelId, @serialNumber, @assetNumber,
     @hasCarryBag, @hasPowerAdapter, @hasMouse, @mouseType,
     @hasVGAConverter, @otherAccessories, @itStaff,
     @issueDate, @remarks, @status, @submittedDate, GETDATE(),
     @employeeEmail, @hodEmail)";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                // Use the provided modelId parameter
                command.Parameters.AddWithValue("@agreementNumber", agreementNumber);
                command.Parameters.AddWithValue("@modelId", modelId);
                command.Parameters.AddWithValue("@serialNumber", txtSerialNumber.Text.Trim());
                command.Parameters.AddWithValue("@assetNumber", txtAssetNumber.Text.Trim());

                // Email fields
                command.Parameters.AddWithValue("@employeeEmail", ddlEmployeeEmail.SelectedValue);
                command.Parameters.AddWithValue("@hodEmail", ddlHODEmail.SelectedValue);

                // Accessories
                command.Parameters.AddWithValue("@hasCarryBag", chkCarryBag.Checked);
                command.Parameters.AddWithValue("@hasPowerAdapter", chkPowerAdapter.Checked);
                command.Parameters.AddWithValue("@hasMouse", chkMouse.Checked);

                string mouseType = "";
                if (chkMouse.Checked)
                {
                    mouseType = rbWired.Checked ? "Wired" :
                               rbWireless.Checked ? "Wireless" : "";
                }
                command.Parameters.AddWithValue("@mouseType", mouseType);

                command.Parameters.AddWithValue("@hasVGAConverter", chkVGAConverter.Checked);

                // Find txtOtherAccessories control
                TextBox txtOtherAccessoriesControl = (TextBox)FindControl("txtOtherAccessories");
                command.Parameters.AddWithValue("@otherAccessories",
                    (txtOtherAccessoriesControl != null && !string.IsNullOrEmpty(txtOtherAccessoriesControl.Text)) ?
                    (object)txtOtherAccessoriesControl.Text.Trim() : DBNull.Value);

                // IT Details
                command.Parameters.AddWithValue("@itStaff", txtITStaff.Text);
                command.Parameters.AddWithValue("@issueDate", issueDate);

                // Remarks - find control
                TextBox txtRemarksControl = (TextBox)FindControl("txtRemarks");
                command.Parameters.AddWithValue("@remarks",
                    (txtRemarksControl != null && !string.IsNullOrEmpty(txtRemarksControl.Text)) ?
                    (object)txtRemarksControl.Text.Trim() : DBNull.Value);

                // Status and dates
                command.Parameters.AddWithValue("@status", finalStatus);
                command.Parameters.AddWithValue("@submittedDate",
                    submittedDate.HasValue ? (object)submittedDate.Value : DBNull.Value);

                int rowsAffected = command.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    // Send email notification
                    if (action == "Submitted")
                    {
                        SendAgreementEmail(action, agreementNumber, finalStatus);
                    }

                    if (action == "Draft")
                    {
                        ShowSuccess($"Draft saved successfully! Agreement Number: {agreementNumber}");
                        // Redirect to Default.aspx after 2 seconds
                        string script = "<script type='text/javascript'>" +
                                        "setTimeout(function(){ window.location.href = 'Default.aspx'; }, 2000);" +
                                        "</script>";
                        ClientScript.RegisterStartupScript(this.GetType(), "redirect", script);
                    }
                    else
                    {
                        ShowSuccess($"Agreement submitted successfully! Status: {finalStatus}");
                        // Redirect to ExistingAgreements.aspx after 2 seconds
                        string script = "<script type='text/javascript'>" +
                                        "setTimeout(function(){ window.location.href = 'ExistingAgreements.aspx'; }, 2000);" +
                                        "</script>";
                        ClientScript.RegisterStartupScript(this.GetType(), "redirect", script);
                    }
                }
                else
                {
                    ShowError("Failed to save agreement. Please try again.");
                }
            }
        }

        // Update agreement with modelId parameter
        private void UpdateAgreement(SqlConnection connection, string action, int agreementId, int modelId)
        {
            // Get current status from database
            string currentDbStatus = GetAgreementStatus(agreementId);

            // Determine final status and dates
            string finalStatus;
            DateTime? submittedDate = null;
            DateTime issueDate = DateTime.Now;

            if (action == "Draft")
            {
                // Keep as Draft
                finalStatus = "Draft";
            }
            else // Submitted
            {
                if (currentDbStatus == "Draft")
                {
                    // First time submission - set to Pending
                    submittedDate = DateTime.Now;
                    issueDate = submittedDate.Value;
                    finalStatus = "Pending";
                }
                else if (currentDbStatus == "Pending")
                {
                    // Already submitted - update based on radio button selection
                    submittedDate = DateTime.Now;
                    issueDate = submittedDate.Value;
                    finalStatus = rbActive.Checked ? "Active" : "Inactive";
                }
                else
                {
                    // For Active/Inactive status, update based on radio button
                    submittedDate = DateTime.Now;
                    issueDate = submittedDate.Value;
                    finalStatus = rbActive.Checked ? "Active" : "Inactive";
                }
            }

            string query = @"
    UPDATE hardware_agreements SET
    model_id = @modelId,
    serial_number = @serialNumber,
    asset_number = @assetNumber,
    has_carry_bag = @hasCarryBag,
    has_power_adapter = @hasPowerAdapter,
    has_mouse = @hasMouse,
    mouse_type = @mouseType,
    has_vga_converter = @hasVGAConverter,
    other_accessories = @otherAccessories,
    it_staff_win_id = @itStaff,
    issue_date = @issueDate,
    remarks = @remarks,
    agreement_status = @status,
    submitted_date = @submittedDate,
    last_updated = GETDATE(),
    employee_email = @employeeEmail,
    hod_email = @hodEmail
    WHERE id = @id";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                // Use the provided modelId parameter
                command.Parameters.AddWithValue("@modelId", modelId);
                command.Parameters.AddWithValue("@serialNumber", txtSerialNumber.Text.Trim());
                command.Parameters.AddWithValue("@assetNumber", txtAssetNumber.Text.Trim());

                // Email fields
                command.Parameters.AddWithValue("@employeeEmail", ddlEmployeeEmail.SelectedValue);
                command.Parameters.AddWithValue("@hodEmail", ddlHODEmail.SelectedValue);

                // Accessories
                command.Parameters.AddWithValue("@hasCarryBag", chkCarryBag.Checked);
                command.Parameters.AddWithValue("@hasPowerAdapter", chkPowerAdapter.Checked);
                command.Parameters.AddWithValue("@hasMouse", chkMouse.Checked);

                string mouseType = "";
                if (chkMouse.Checked)
                {
                    mouseType = rbWired.Checked ? "Wired" :
                               rbWireless.Checked ? "Wireless" : "";
                }
                command.Parameters.AddWithValue("@mouseType", mouseType);

                command.Parameters.AddWithValue("@hasVGAConverter", chkVGAConverter.Checked);

                // Find txtOtherAccessories control
                TextBox txtOtherAccessoriesControl = (TextBox)FindControl("txtOtherAccessories");
                command.Parameters.AddWithValue("@otherAccessories",
                    (txtOtherAccessoriesControl != null && !string.IsNullOrEmpty(txtOtherAccessoriesControl.Text)) ?
                    (object)txtOtherAccessoriesControl.Text.Trim() : DBNull.Value);

                // IT Details
                command.Parameters.AddWithValue("@itStaff", txtITStaff.Text);
                command.Parameters.AddWithValue("@issueDate", issueDate);

                // Remarks - find control
                TextBox txtRemarksControl = (TextBox)FindControl("txtRemarks");
                command.Parameters.AddWithValue("@remarks",
                    (txtRemarksControl != null && !string.IsNullOrEmpty(txtRemarksControl.Text)) ?
                    (object)txtRemarksControl.Text.Trim() : DBNull.Value);

                // Status and dates
                command.Parameters.AddWithValue("@status", finalStatus);
                command.Parameters.AddWithValue("@submittedDate",
                    submittedDate.HasValue ? (object)submittedDate.Value : DBNull.Value);
                command.Parameters.AddWithValue("@id", agreementId);

                int rowsAffected = command.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    if (action == "Draft")
                    {
                        ShowSuccess("Draft updated successfully!");
                    }
                    else
                    {
                        ShowSuccess($"Agreement updated successfully! Status: {finalStatus}");
                    }

                    // Always redirect to ExistingAgreements.aspx after update
                    string script = "<script type='text/javascript'>" +
                                    "setTimeout(function(){ window.location.href = 'ExistingAgreements.aspx'; }, 2000);" +
                                    "</script>";
                    ClientScript.RegisterStartupScript(this.GetType(), "redirect", script);
                }
                else
                {
                    ShowError("Failed to update agreement. Please try again.");
                }
            }
        }

        private string GenerateAgreementNumber()
        {
            // Generate agreement number: AGREEMENT-YYYYMMDD-XXXX
            string datePart = DateTime.Now.ToString("yyyyMMdd");
            string randomPart = new Random().Next(1000, 9999).ToString();
            return $"AGREEMENT-{datePart}-{randomPart}";
        }

        protected void btnSaveDraft_Click(object sender, EventArgs e)
        {
            SaveAgreement("Draft");
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            SaveAgreement("Submitted");
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            if (!currentAgreementId.HasValue) return;

            // Check if it's actually a draft before allowing edit
            string actualStatus = GetCurrentAgreementStatus();
            if (actualStatus == "Draft")
            {
                // Switch to edit mode
                Response.Redirect($"Agreement.aspx?id={currentAgreementId}");
            }
            else
            {
                ShowError("Only draft agreements can be edited.");
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Delete button clicked");

            if (!currentAgreementId.HasValue)
            {
                ShowError("No agreement selected for deletion.");
                return;
            }

            // Proceed with deletion
            DeleteAgreement();
        }

        private void DeleteAgreement()
        {
            if (!currentAgreementId.HasValue)
            {
                ShowError("No agreement to delete.");
                return;
            }

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = "DELETE FROM hardware_agreements WHERE id = @id";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@id", currentAgreementId.Value);
                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowSuccess("Agreement deleted successfully!");

                            // Redirect to ExistingAgreements.aspx after 2 seconds
                            string script = "<script type='text/javascript'>" +
                                            "setTimeout(function(){ window.location.href = 'ExistingAgreements.aspx'; }, 2000);" +
                                            "</script>";
                            ClientScript.RegisterStartupScript(this.GetType(), "redirect", script);
                        }
                        else
                        {
                            ShowError("Agreement not found or could not be deleted.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error deleting agreement: " + ex.Message);
                    System.Diagnostics.Debug.WriteLine("Delete error: " + ex.Message);
                }
            }
        }

        private void ShowSuccess(string message)
        {
            if (successText != null)
            {
                successText.InnerText = message;
            }
            messageSuccess.Visible = true;
            messageError.Visible = false;
        }

        private void ShowError(string message)
        {
            if (errorText != null)
            {
                errorText.InnerText = message;
            }
            messageError.Visible = true;
            messageSuccess.Visible = false;
        }

        private void SendAgreementEmail(string action, string agreementNumber, string status)
        {
            try
            {
                // Get email addresses from DROPDOWNS
                string employeeEmail = ddlEmployeeEmail.SelectedValue;
                string hodEmail = ddlHODEmail.SelectedValue;

                if (string.IsNullOrEmpty(employeeEmail) || string.IsNullOrEmpty(hodEmail))
                {
                    ShowError("Employee email and HOD email are required for email notification.");
                    return;
                }

                // Get model name for email
                string modelName = "";
                if (ddlModel.SelectedValue == "OTHER")
                {
                    modelName = txtOtherModel.Text.Trim();
                }
                else if (ddlModel.SelectedItem != null)
                {
                    modelName = ddlModel.SelectedItem.Text;
                }

                // Create email message
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("hardware_agreement@ioioleo.com", "Hardware Agreement System");
                mail.To.Add(employeeEmail);
                mail.CC.Add(hodEmail);

                if (action == "Submitted")
                {
                    mail.Subject = $"Hardware Agreement {agreementNumber} - {status}";

                    string body = $@"
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
        .header {{ background-color: #667eea; color: white; padding: 20px; text-align: center; border-radius: 10px 10px 0 0; }}
        .content {{ background-color: #f9f9f9; padding: 20px; border-radius: 0 0 10px 10px; border: 1px solid #ddd; }}
        .status {{ display: inline-block; padding: 5px 15px; border-radius: 20px; font-weight: bold; }}
        .status-draft {{ background-color: #fff3cd; color: #856404; }}
        .status-pending {{ background-color: #cce5ff; color: #004085; }}
        .status-active {{ background-color: #d4edda; color: #155724; }}
        .status-inactive {{ background-color: #f8d7da; color: #721c24; }}
        .details-table {{ width: 100%; border-collapse: collapse; margin: 20px 0; }}
        .details-table th, .details-table td {{ padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }}
        .details-table th {{ background-color: #f2f2f2; }}
        .footer {{ margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>Hardware Agreement Notification</h1>
        </div>
        <div class='content'>
            <h2>Agreement Details</h2>
            <table class='details-table'>
                <tr>
                    <th>Agreement Number:</th>
                    <td>{agreementNumber}</td>
                </tr>
                <tr>
                    <th>Status:</th>
                    <td><span class='status status-{status.ToLower()}'>{status}</span></td>
                </tr>
                <tr>
                    <th>Model:</th>
                    <td>{modelName}</td>
                </tr>
                <tr>
                    <th>Serial Number:</th>
                    <td>{txtSerialNumber.Text}</td>
                </tr>
                <tr>
                    <th>Asset Number:</th>
                    <td>{txtAssetNumber.Text}</td>
                </tr>
                <tr>
                    <th>IT Staff:</th>
                    <td>{txtITStaff.Text}</td>
                </tr>
                <tr>
                    <th>Issue Date:</th>
                    <td>{DateTime.Now.ToString("dd/MM/yyyy")}</td>
                </tr>
            </table>
            
            <div class='footer'>
                <p>This is an automated notification from the Hardware Agreement System.</p>
                <p>Please do not reply to this email.</p>
            </div>
        </div>
    </div>
</body>
</html>";

                    mail.Body = body;
                    mail.IsBodyHtml = true;
                }
                else if (action == "Draft")
                {
                    mail.Subject = $"Hardware Agreement Employee Acceptance - {agreementNumber}";
                    mail.Body = $@"Dear,

This is your laptop/desktop agreement, please browse the url site attached to do the acceptance.

Agreement Number: {agreementNumber}
Model: {modelName}
Serial Number: {txtSerialNumber.Text}

Please contact IT staff if there any concerns.

Best regards,
Hardware Agreement System";
                    mail.IsBodyHtml = false;
                }

                // Configure SMTP client
                SmtpClient smtpClient = new SmtpClient("192.168.90.36", 25);
                smtpClient.EnableSsl = false;
                smtpClient.UseDefaultCredentials = false;
                smtpClient.Credentials = new NetworkCredential("", "");
                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtpClient.Timeout = 10000;

                // Send email
                smtpClient.Send(mail);

                // Log success
                System.Diagnostics.Debug.WriteLine($"Email sent to {employeeEmail} and CC to {hodEmail}");
            }
            catch (SmtpException smtpEx)
            {
                System.Diagnostics.Debug.WriteLine($"SMTP Error: {smtpEx.Message}");
                ShowError($"Failed to send email notification. SMTP Error: {smtpEx.Message}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Email Error: {ex.Message}");
                ShowError($"Failed to send email notification. Error: {ex.Message}");
            }
        }
    }
}