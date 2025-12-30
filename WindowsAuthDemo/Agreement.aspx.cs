using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Web.UI;

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
            if (string.IsNullOrEmpty(ddlModel.SelectedValue))
            {
                ShowError("Please select a hardware model.");
                return;
            }

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

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
                                UpdateAgreement(connection, action, agreementId);
                                return;
                            }
                        }
                    }

                    // If no ID or not a draft, CREATE new
                    CreateNewAgreement(connection, action);
                }
                catch (Exception ex)
                {
                    ShowError("Database error: " + ex.Message);
                }
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

        private void AddBackButton()
        {
            // Create a back button for view mode
            Button backButton = new Button();
            backButton.ID = "btnBack";
            backButton.Text = "Back to Agreements";
            backButton.CssClass = "btn btn-outline";
            backButton.OnClientClick = "window.location.href='ExistingAgreements.aspx'; return false;";

            // Add icon using Literal control
            Literal icon = new Literal();
            icon.Text = "<i class='fas fa-arrow-left'></i> ";

            // Add to the button group
            actionButtons.Controls.Add(icon);
            actionButtons.Controls.Add(backButton);
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

            if (txtRemarksControl != null) txtRemarksControl.ReadOnly = readOnly;
            if (txtSerialNumberControl != null) txtSerialNumberControl.ReadOnly = readOnly;
            if (txtAssetNumberControl != null) txtAssetNumberControl.ReadOnly = readOnly;
            if (txtOtherAccessoriesControl != null) txtOtherAccessoriesControl.ReadOnly = readOnly;

            ddlModel.Enabled = !readOnly;
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
                ddlModel.CssClass += " readonly-control";
            }
        }

        // In your LoadExistingAgreement method, find controls like this:
        private void LoadExistingAgreement(int agreementId)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["HardwareAgreementConnection"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    string query = @"
                SELECT a.*, m.model,
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
                                    // Display text for view mode
                                    lblModelDisplay.Text = reader["model"].ToString();
                                }

                                txtSerialNumber.Text = reader["serial_number"].ToString();
                                txtAssetNumber.Text = reader["asset_number"].ToString();

                                // Load accessories
                                bool hasCarryBag = Convert.ToBoolean(reader["has_carry_bag"]);
                                bool hasPowerAdapter = Convert.ToBoolean(reader["has_power_adapter"]);
                                bool hasMouse = Convert.ToBoolean(reader["has_mouse"]);
                                bool hasVGAConverter = Convert.ToBoolean(reader["has_vga_converter"]);

                                chkCarryBag.Checked = hasCarryBag;
                                chkPowerAdapter.Checked = hasPowerAdapter;
                                chkMouse.Checked = hasMouse;
                                chkVGAConverter.Checked = hasVGAConverter;

                                // Set display text for checkboxes
                                lblCarryBagDisplay.Text = hasCarryBag ? "Yes" : "No";
                                lblPowerAdapterDisplay.Text = hasPowerAdapter ? "Yes" : "No";
                                lblMouseDisplay.Text = hasMouse ? "Yes" : "No";
                                lblVGAConverterDisplay.Text = hasVGAConverter ? "Yes" : "No";

                                string mouseType = reader["mouse_type"]?.ToString();
                                rbWired.Checked = (mouseType == "Wired");
                                rbWireless.Checked = (mouseType == "Wireless");

                                // Set display text for mouse type
                                if (hasMouse)
                                {
                                    lblMouseTypeDisplay.Text = mouseType == "Wired" ? "Wired" : "Wireless";
                                    lblWirelessDisplay.Text = mouseType == "Wireless" ? "Wireless" : "";
                                }
                                else
                                {
                                    lblMouseTypeDisplay.Text = "Not Selected";
                                }

                                txtOtherAccessories.Text = reader["other_accessories"]?.ToString();

                                // Load IT details
                                txtITStaff.Text = reader["it_staff_win_id"].ToString();
                                txtDateIssue.Text = Convert.ToDateTime(reader["issue_date"]).ToString("dd/MM/yyyy");

                                // Load remarks - find control if needed
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

                                    // Find display labels
                                    Label lblStatusDisplayControl = (Label)FindControl("lblStatusDisplay");
                                    Label lblInactiveDisplayControl = (Label)FindControl("lblInactiveDisplay");

                                    if (lblStatusDisplayControl != null && lblInactiveDisplayControl != null)
                                    {
                                        lblStatusDisplayControl.Text = isActive ? "Active" : "";
                                        lblInactiveDisplayControl.Text = !isActive ? "Inactive" : "";
                                    }
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
                    string query = "SELECT id, model FROM hardware_model ORDER BY model";
                    
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            ddlModel.Items.Add(new ListItem("-- Select Model --", ""));
                            
                            while (reader.Read())
                            {
                                ddlModel.Items.Add(new ListItem(
                                    reader["model"].ToString(),
                                    reader["id"].ToString()
                                ));
                            }
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

        private void CreateNewAgreement(SqlConnection connection, string action)
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
             issue_date, remarks, agreement_status, submitted_date, created_date)
            VALUES 
            (@agreementNumber, @modelId, @serialNumber, @assetNumber,
             @hasCarryBag, @hasPowerAdapter, @hasMouse, @mouseType,
             @hasVGAConverter, @otherAccessories, @itStaff,
             @issueDate, @remarks, @status, @submittedDate, GETDATE())";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                SetCommandParameters(command, agreementNumber, finalStatus, submittedDate, issueDate);
                
                int rowsAffected = command.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
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

        private void UpdateAgreement(SqlConnection connection, string action, int agreementId)
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
    last_updated = GETDATE()
    WHERE id = @id";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                SetCommandParameters(command, null, finalStatus, submittedDate, issueDate);
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

        private void SetCommandParameters(SqlCommand command, string agreementNumber, string status, DateTime? submittedDate, DateTime issueDate)
        {
            // Basic hardware details
            if (agreementNumber != null)
            {
                command.Parameters.AddWithValue("@agreementNumber", agreementNumber);
            }
            command.Parameters.AddWithValue("@modelId", ddlModel.SelectedValue);
            command.Parameters.AddWithValue("@serialNumber", txtSerialNumber.Text.Trim());
            command.Parameters.AddWithValue("@assetNumber", txtAssetNumber.Text.Trim());

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

            // Remarks and Status
            command.Parameters.AddWithValue("@status", status);

            // Submission date
            command.Parameters.AddWithValue("@submittedDate",
                submittedDate.HasValue ? (object)submittedDate.Value : DBNull.Value);
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

            // Don't set OnClientClick here - it's already set in the ASPX file
            // The confirmation should happen BEFORE reaching server code

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
    }
}