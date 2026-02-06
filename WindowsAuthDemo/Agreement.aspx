﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Agreement.aspx.cs" Inherits="WindowsAuthDemo.Agreement" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title><asp:Literal ID="litPageTitle" runat="server"></asp:Literal></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="hardware-portal-styles.css">
    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.3/dist/signature_pad.umd.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Hidden fields for backup -->
        <asp:HiddenField ID="hdnEmpNameBackup" runat="server" />
        <asp:HiddenField ID="hdnEmpPositionBackup" runat="server" />
        <asp:HiddenField ID="hdnEmpDepartmentBackup" runat="server" />
        
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-laptop-code"></i>
                <h2>Hardware Portal</h2>
            </div>

            <ul class="nav-links">
                <li class="nav-item">
                    <a href="Default.aspx" class="nav-link">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="Agreement.aspx" class="nav-link active">
                        <i class="fas fa-file-contract"></i>
                        <span>New Agreement</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="ExistingAgreements.aspx" class="nav-link">
                        <i class="fas fa-list-alt"></i>
                        <span>Agreements</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="UserManagement.aspx" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Users</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="ReportPage.aspx" class="nav-link">
                        <i class="fas fa-chart-bar"></i>
                        <span>Reports</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>

            <div class="nav-divider"></div>

            <div class="nav-links">
                <div class="nav-item">
                    <a href="mailto:qayyim@ioioleo.com?subject=Hardware%20Agreement%20Portal%20Support&body=Hello%20Support%20Team,%0A%0AI%20need%20assistance%20with:%0A%0A%0A%0AWindows%20ID:%20[Your%20Windows%20ID]%0APage:%20[Current%20Page]" 
                       class="nav-link" 
                       onclick="return setEmailBody(this)">
                        <i class="fas fa-question-circle"></i>
                        <span>Help & Support</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>

            <div class="user-info-sidebar">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <div style="font-weight: 600; color: white;">
                            <asp:Label ID="lblUserRole" runat="server" Text="Administrator"></asp:Label>
                        </div>
                        <div style="font-size: 0.85rem; color: #94a3b8;">
                            <asp:Label ID="lblUserName" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="top-header">
                <div class="page-title">
                    <h1>
                        <asp:Literal ID="litHeaderTitle" runat="server"></asp:Literal>
                    </h1>
                    <p>
                        <asp:Literal ID="litHeaderDescription" runat="server"></asp:Literal>
                    </p>
                </div>
                <div class="user-profile">
                    <i class="fas fa-user-circle"></i>
                    <div>
                        <div style="font-weight: 600;">
                            <asp:Label ID="lblTopUserName" runat="server"></asp:Label>
                        </div>
                        <div style="font-size: 0.85rem; color: var(--text-secondary);">
                            <asp:Label ID="lblTopUserRole" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Breadcrumb -->
            <div class="breadcrumb">
                <a href="Default.aspx">
                    <i class="fas fa-home"></i>
                    Dashboard
                </a>
                <span class="separator">/</span>
                <a href="Default.aspx">Computer Panel</a>
                <span class="separator">/</span>
                <span style="color: var(--text-secondary);">
                    <asp:Literal ID="litBreadcrumbTitle" runat="server"></asp:Literal>
                </span>
            </div>

            <!-- Status Badge -->
            <div style="margin-bottom: 24px;">
                <asp:Literal ID="litStatusBadge" runat="server"></asp:Literal>
            </div>

            <!-- Form Container -->
            <div class="form-container" id="formContainer" runat="server">
                <!-- Agreement Info Bar -->
                <div class="agreement-info-bar" id="agreementInfo" runat="server" visible="false">
                    <div class="info-item">
                        <span class="info-label">Agreement Number</span>
                        <span class="info-value" id="agreementNumberDisplay" runat="server"></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Created Date</span>
                        <span class="info-value" id="createdDateDisplay" runat="server"></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Last Updated</span>
                        <span class="info-value" id="updatedDateDisplay" runat="server"></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Status</span>
                        <span class="info-value">
                            <asp:Label ID="lblCurrentStatus" runat="server"></asp:Label>
                        </span>
                    </div>
                </div>

                <!-- Messages -->
                <div id="messageSuccess" runat="server" class="message message-success">
                    <i class="fas fa-check-circle"></i>
                    <span id="successText" runat="server"></span>
                </div>
                
                <div id="messageError" runat="server" class="message message-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span id="errorText" runat="server"></span>
                </div>

                <!-- Form Sections -->
                <div class="form-sections">
                    <!-- Hardware Details Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-laptop"></i>
                            </div>
                            <div>
                                <div class="section-title">Hardware Details</div>
                                <div class="section-subtitle">Enter laptop/desktop specifications</div>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label required">Model</label>
                                <asp:DropDownList ID="ddlModel" runat="server" CssClass="form-select" 
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlModel_SelectedIndexChanged">
                                    <asp:ListItem Value="">-- Select Model --</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvModel" runat="server" 
                                    ControlToValidate="ddlModel" InitialValue=""
                                    ErrorMessage="Please select a model" 
                                    Display="Dynamic" ForeColor="#ef4444">
                                </asp:RequiredFieldValidator>
                                
                                <!-- Other Model Panel -->
                                <asp:Panel ID="pnlOtherModel" runat="server" Visible="false" CssClass="other-model-panel">
                                    <div class="other-model-header">
                                        <i class="fas fa-plus-circle"></i>
                                        Add New Model
                                    </div>
                                    <div class="other-model-grid">
                                        <div class="form-group">
                                            <label class="form-label required">Model Name</label>
                                            <asp:TextBox ID="txtOtherModel" runat="server" CssClass="form-control" 
                                                placeholder="Enter new model name"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvOtherModel" runat="server" 
                                                ControlToValidate="txtOtherModel" ErrorMessage="Please enter model name"
                                                Display="Dynamic" ForeColor="#ef4444" Enabled="false">
                                            </asp:RequiredFieldValidator>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label class="form-label required">Device Type</label>
                                            <asp:DropDownList ID="ddlDeviceType" runat="server" CssClass="form-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlDeviceType_SelectedIndexChanged">
                                                <asp:ListItem Value="">-- Select Type --</asp:ListItem>
                                                <asp:ListItem Value="Laptop">Laptop</asp:ListItem>
                                                <asp:ListItem Value="Desktop">Desktop</asp:ListItem>
                                                <asp:ListItem Value="All-in-One">All-in-One PC</asp:ListItem>
                                                <asp:ListItem Value="Workstation">Workstation</asp:ListItem>
                                                <asp:ListItem Value="Tablet">Tablet</asp:ListItem>
                                                <asp:ListItem Value="Other">Other</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rfvDeviceType" runat="server" 
                                                ControlToValidate="ddlDeviceType" InitialValue=""
                                                ErrorMessage="Please select device type"
                                                Display="Dynamic" ForeColor="#ef4444" Enabled="false">
                                            </asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <small class="helper-text">This model will be added to the database for future use</small>
                                </asp:Panel>
                            </div>

                            <div class="form-group">
                                <label class="form-label required">Serial Number</label>
                                <asp:TextBox ID="txtSerialNumber" runat="server" CssClass="form-control" 
                                    placeholder="Enter serial number"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvSerialNumber" runat="server" 
                                    ControlToValidate="txtSerialNumber" ErrorMessage="Serial number is required"
                                    Display="Dynamic" ForeColor="#ef4444">
                                </asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label class="form-label required">Asset Number</label>
                                <asp:TextBox ID="txtAssetNumber" runat="server" CssClass="form-control" 
                                    placeholder="Enter asset number"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAssetNumber" runat="server" 
                                    ControlToValidate="txtAssetNumber" ErrorMessage="Asset number is required"
                                    Display="Dynamic" ForeColor="#ef4444">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <!-- Accessories Section (Wrapped in Panel) -->
                    <asp:Panel ID="accessoriesSection" runat="server" CssClass="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-box-open"></i>
                            </div>
                            <div>
                                <div class="section-title">Accessories</div>
                                <div class="section-subtitle">Select all included accessories</div>
                            </div>
                        </div>

                        <div class="accessories-grid">
                            <div class="checkbox-group">
                                <asp:CheckBox ID="chkCarryBag" runat="server" />
                                <label for="chkCarryBag">Bag</label>
                            </div>

                            <div class="checkbox-group">
                                <asp:CheckBox ID="chkPowerAdapter" runat="server" />
                                <label for="chkPowerAdapter">Power Adapter</label>
                            </div>

                            <div class="checkbox-group">
                                <asp:CheckBox ID="chkMouse" runat="server" />
                                <label for="chkMouse">Mouse</label>
                            </div>

                            <div class="checkbox-group">
                                <asp:CheckBox ID="chkVGAConverter" runat="server" />
                                <label for="chkVGAConverter">VGA Converter</label>
                            </div>
                        </div>

                        <!-- Mouse Type -->
                        <div class="form-group" style="margin-top: 16px;">
                            <label class="form-label">Mouse Type</label>
                            <div class="radio-group">
                                <div class="radio-option">
                                    <asp:RadioButton ID="rbWired" runat="server" GroupName="MouseType" />
                                    <label for="rbWired">Wired</label>
                                </div>
                                <div class="radio-option">
                                    <asp:RadioButton ID="rbWireless" runat="server" GroupName="MouseType" />
                                    <label for="rbWireless">Wireless</label>
                                </div>
                            </div>
                        </div>

                        <!-- Other Accessories -->
                        <div class="form-group">
                            <label class="form-label">Other Accessories</label>
                            <asp:TextBox ID="txtOtherAccessories" runat="server" CssClass="form-control" 
                                placeholder="List any other accessories..." TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </asp:Panel>

                    <!-- IT Details Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-user-tie"></i>
                            </div>
                            <div>
                                <div class="section-title">IT Staff Details</div>
                                <div class="section-subtitle">Information about the issuing IT staff</div>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">IT Staff</label>
                                <asp:TextBox ID="txtITStaff" runat="server" CssClass="form-control auto-fill" 
                                    ReadOnly="true"></asp:TextBox>
                                <div class="helper-text">Auto-filled based on your Windows ID</div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Issue Date</label>
                                <asp:TextBox ID="txtDateIssue" runat="server" CssClass="form-control auto-fill" 
                                    ReadOnly="true"></asp:TextBox>
                                <div class="helper-text">Auto-filled on submission</div>
                            </div>
                        </div>
                    </div>

                    <!-- Employee Information -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div>
                                <div class="section-title">Employee Information</div>
                                <div class="section-subtitle">Contact details for notification</div>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label required">Employee Email</label>
                                <asp:DropDownList ID="ddlEmployeeEmail" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="">-- Select Employee Email --</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvEmployeeEmail" runat="server" 
                                    ControlToValidate="ddlEmployeeEmail" InitialValue=""
                                    ErrorMessage="Please select an employee email" 
                                    Display="Dynamic" ForeColor="#ef4444">
                                </asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label class="form-label required">HOD Email</label>
                                <asp:DropDownList ID="ddlHODEmail" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="">-- Select HOD Email --</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvHODEmail" runat="server" 
                                    ControlToValidate="ddlHODEmail" InitialValue=""
                                    ErrorMessage="Please select an HOD email" 
                                    Display="Dynamic" ForeColor="#ef4444">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <!-- Remarks Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-sticky-note"></i>
                            </div>
                            <div>
                                <div class="section-title">Remarks & Status</div>
                                <div class="section-subtitle">Additional notes and agreement status</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Remarks</label>
                            <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control remarks-box" 
                                placeholder="Enter any remarks or notes..." TextMode="MultiLine" Rows="4"></asp:TextBox>
                        </div>

                        <!-- Status Section (only for edit mode) -->
                        <asp:Panel ID="statusSection" runat="server" CssClass="status-section" Visible="false">
                            <label class="form-label required">Agreement Status</label>
                            <div class="status-options">
                                <div class="radio-option">
                                    <asp:RadioButton ID="rbActive" runat="server" GroupName="AgreementStatus" Checked="true" />
                                    <label for="rbActive">Active</label>
                                </div>
                                <div class="radio-option">
                                    <asp:RadioButton ID="rbInactive" runat="server" GroupName="AgreementStatus" />
                                    <label for="rbInactive">Inactive</label>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                    <!-- Employee Signature Section -->
                    <asp:Panel ID="pnlEmployeeSignature" runat="server" CssClass="form-section" Visible="false">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-signature"></i>
                            </div>
                            <div>
                                <div class="section-title">Employee Agreement & Signature</div>
                                <div class="section-subtitle">Fill in your details, review and sign the hardware agreement</div>
                            </div>
                        </div>

                        <!-- Employee Information Section -->
                        <div class="employee-details-section" style="background: #f0f9ff; padding: 20px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #bfdbfe;">
                            <h4 style="color: var(--primary); margin-bottom: 15px;">
                                <i class="fas fa-user-circle" style="margin-right: 8px;"></i>Employee Information
                            </h4>
                            <div class="employee-info-grid">
                                <div class="form-group">
                                    <label class="form-label required">Employee Name</label>
                                    <asp:TextBox ID="txtEmpName" runat="server" CssClass="form-control" 
                                        placeholder="Enter your full name"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmpName" runat="server" 
                                        ControlToValidate="txtEmpName"
                                        ErrorMessage="Employee name is required"
                                        Display="Dynamic" ForeColor="#ef4444"
                                        ValidationGroup="EmployeeValidation">
                                    </asp:RequiredFieldValidator>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Employee ID (Windows ID)</label>
                                    <asp:TextBox ID="txtEmpId" runat="server" CssClass="form-control" 
                                        ReadOnly="true" style="background-color: #f1f5f9;"></asp:TextBox>
                                    <small style="color: var(--text-secondary); font-size: 0.8rem;">
                                        <i class="fas fa-info-circle"></i> Automatically captured from your Windows login
                                    </small>
                                </div>

                                <div class="form-group">
                                    <label class="form-label required">Position / Job Title</label>
                                    <asp:TextBox ID="txtEmpPosition" runat="server" CssClass="form-control" 
                                        placeholder="Enter your job title"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmpPosition" runat="server" 
                                        ControlToValidate="txtEmpPosition"
                                        ErrorMessage="Position is required"
                                        Display="Dynamic" ForeColor="#ef4444"
                                        ValidationGroup="EmployeeValidation">
                                    </asp:RequiredFieldValidator>
                                </div>

                                <div class="form-group">
                                    <label class="form-label required">Department</label>
                                    <asp:TextBox ID="txtEmpDepartment" runat="server" CssClass="form-control" 
                                        placeholder="Enter your department"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmpDepartment" runat="server" 
                                        ControlToValidate="txtEmpDepartment"
                                        ErrorMessage="Department is required"
                                        Display="Dynamic" ForeColor="#ef4444"
                                        ValidationGroup="EmployeeValidation">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <div class="agreement-terms">
                            <h3 style="color: var(--primary); margin-bottom: 15px;">Hardware Usage Agreement</h3>
        
                            <!-- Agreement Terms Text -->
                            <div style="line-height: 1.6; margin-bottom: 20px;">
                                <p><strong>In acceptance of this device (Laptop/PC) for usage, I agree to the terms and conditions stated below:</strong></p>
                                <ol style="margin-left: 20px; margin-bottom: 15px;">
                                    <li>I understand that I am responsible for the laptop/PC whilst in my possession.</li>
                                    <li>I am responsible for keeping the laptop/PC in good condition while using it and until the time of return.</li>
                                    <li>I understand that I should not install any program or software that is not permitted to use by the company, for privacy and security reasons.</li>
                                    <li>I should be the only authorized person to have access to and use this laptop/PC. Any unauthorized access to this laptop/PC is a violation of this company's policy, employment regulation and employment contract.</li>
                                    <li>I should remove all data that is not company or work-related before turning over the laptop/PC to the designated department.</li>
                                    <li>In the event of loss, theft, or damage, this must be reported to the police within 24-48 hours, and a copy of a Police report or incident report must be submitted to the company for verification purposes.</li>
                                    <li>I understand that any violation of these policies is a violation and I am subject to any disciplinary action by the company.</li>
                                </ol>
                            </div>

                            <!-- Digital Signature -->
                            <div class="signature-section">
                                <label class="form-label required">Digital Signature</label>
                                <div class="signature-canvas-container">
                                    <canvas id="signatureCanvas" class="signature-canvas"></canvas>
                                    <div class="signature-actions">
                                        <button type="button" id="clearSignature" class="btn btn-outline" style="padding: 8px 16px;">
                                            <i class="fas fa-eraser"></i> Clear
                                        </button>
                                        <button type="button" id="saveSignature" class="btn btn-secondary" style="padding: 8px 16px;">
                                            <i class="fas fa-save"></i> Save Signature
                                        </button>
                                    </div>
                                </div>
            
                                <!-- Signature Preview -->
                                <div class="signature-preview">
                                    <label class="form-label">Signature Preview:</label>
                                    <div class="signature-display">
                                        <img id="signaturePreview" src="" alt="Signature Preview" style="max-width: 100%; display: none;" />
                                        <p id="noSignatureText" style="color: var(--text-secondary); font-style: italic;">No signature saved yet</p>
                                    </div>
                                </div>
            
                                <!-- Hidden fields for signature -->
                                <asp:HiddenField ID="hdnSignatureData" runat="server" />
                                <asp:HiddenField ID="hdnIsSigned" runat="server" Value="false" />
                                <asp:HiddenField ID="hdnAgreementId" runat="server" Value="" />
            
                                <!-- Signature date and signed by fields (auto-filled) -->
                                <div class="employee-info-grid" style="margin-top: 20px;">
                                    <div class="form-group">
                                        <label class="form-label">Signature Date</label>
                                        <asp:TextBox ID="txtEmpSignatureDate" runat="server" CssClass="form-control" 
                                            ReadOnly="true"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                            <!-- Agreement Acceptance -->
                            <div class="terms-acceptance">
                                <div style="display: flex; align-items: flex-start; gap: 10px;">
                                    <asp:CheckBox ID="chkAgreeTerms" runat="server" />
                                    <div>
                                        <label for="chkAgreeTerms" style="font-weight: 600; color: #2e7d32;">
                                            I have read, understood, and agree to all the terms and conditions stated above
                                        </label>
                                        <asp:CustomValidator ID="cvAgreeTerms" runat="server" 
                                            ErrorMessage="You must agree to the terms and conditions"
                                            ClientValidationFunction="validateEmployeeAgreement"
                                            Display="Dynamic" ForeColor="#ef4444">
                                        </asp:CustomValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons" id="actionButtons" runat="server">
                    <asp:Button ID="btnSaveDraft" runat="server" Text="Save as Draft" 
                        CssClass="btn btn-outline" OnClick="btnSaveDraft_Click" />
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Agreement" 
                        CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                    <asp:Button ID="btnEdit" runat="server" Text="Edit Agreement" 
                        CssClass="btn btn-outline" OnClick="btnEdit_Click" Visible="false" />
                    <asp:Button ID="btnDelete" runat="server" Text="Delete" 
                        CssClass="btn btn-danger" OnClick="btnDelete_Click" Visible="false" />
                    <asp:Button ID="btnSubmitEmployee" runat="server" Text="Submit Employee Agreement" 
                        CssClass="btn btn-primary" OnClick="btnSubmitEmployee_Click" Visible="false" 
                        CausesValidation="true" ValidationGroup="EmployeeValidation" />
                </div>
            </div>

            <!-- Footer -->
            <div class="footer">
                <p>Hardware Agreement System &copy; <%= DateTime.Now.Year %> | Secure Enterprise Portal</p>
                <p style="margin-top: 8px; font-size: 0.8rem; color: #94a3b8;">
                    Windows Authentication | Last updated: <%= DateTime.Now.ToString("MMMM dd, yyyy HH:mm") %>
                </p>
            </div>
        </main>
    </form>

    <script>
        // Add active class to current page
        document.addEventListener('DOMContentLoaded', function () {
            const currentPage = window.location.pathname.split('/').pop();
            const navLinks = document.querySelectorAll('.nav-link');

            navLinks.forEach(link => {
                if (link.getAttribute('href') === currentPage ||
                    (currentPage === '' && link.getAttribute('href') === 'Default.aspx')) {
                    link.classList.add('active');
                }
            });

            // Auto-fill current date
            const dateIssue = document.getElementById('<%= txtDateIssue.ClientID %>');
            if (dateIssue && !dateIssue.value) {
                const now = new Date();
                dateIssue.value = now.toLocaleDateString('en-GB');
            }

            // Enhanced form validation
            const form = document.getElementById('form1');
            if (form) {
                form.addEventListener('submit', function (e) {
                    const modelSelect = document.getElementById('<%= ddlModel.ClientID %>');
                    const serialNumber = document.getElementById('<%= txtSerialNumber.ClientID %>');
                    const assetNumber = document.getElementById('<%= txtAssetNumber.ClientID %>');

                    let isValid = true;

                    if (modelSelect && modelSelect.value === '') {
                        isValid = false;
                        highlightError(modelSelect);
                    }

                    if (serialNumber && !serialNumber.value.trim()) {
                        isValid = false;
                        highlightError(serialNumber);
                    }

                    if (assetNumber && !assetNumber.value.trim()) {
                        isValid = false;
                        highlightError(assetNumber);
                    }

                    if (!isValid) {
                        e.preventDefault();
                        showValidationMessage();
                    }
                });
            }

            function highlightError(element) {
                element.style.borderColor = '#ef4444';
                element.style.boxShadow = '0 0 0 3px rgba(239, 68, 68, 0.1)';

                element.addEventListener('input', function () {
                    this.style.borderColor = '';
                    this.style.boxShadow = '';
                });
            }

            function showValidationMessage() {
                // You can add a toast notification here
                console.log('Please fill in all required fields');
            }

            // Mobile sidebar toggle
            const sidebarToggle = document.createElement('button');
            sidebarToggle.innerHTML = '<i class="fas fa-bars"></i>';
            sidebarToggle.style.cssText = `
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1001;
                background: var(--primary);
                color: white;
                border: none;
                width: 40px;
                height: 40px;
                border-radius: 8px;
                display: none;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: var(--shadow-lg);
            `;

            // Add the class name for selection
            sidebarToggle.classList.add('sidebar-toggle');
            document.body.appendChild(sidebarToggle);

            sidebarToggle.addEventListener('click', function () {
                document.querySelector('.sidebar').classList.toggle('mobile-open');
            });

            // Close sidebar when clicking outside on mobile
            document.addEventListener('click', function (e) {
                const sidebar = document.querySelector('.sidebar');
                const toggleBtn = document.querySelector('.sidebar-toggle');

                if (window.innerWidth <= 768 &&
                    sidebar.classList.contains('mobile-open') &&
                    !sidebar.contains(e.target) &&
                    e.target !== toggleBtn &&
                    !toggleBtn.contains(e.target)) {
                    sidebar.classList.remove('mobile-open');
                }
            });

            function handleResize() {
                const sidebar = document.querySelector('.sidebar');
                const toggleBtn = document.querySelector('.sidebar-toggle');

                if (!toggleBtn) return; // Add null check

                if (window.innerWidth <= 768) {
                    toggleBtn.style.display = 'flex';
                    sidebar.classList.remove('mobile-open');
                } else {
                    toggleBtn.style.display = 'none';
                    sidebar.classList.remove('mobile-open');
                    sidebar.style.transform = 'none';
                }
            }

            window.addEventListener('resize', handleResize);
            handleResize();

            // Initialize signature pad
            const canvas = document.getElementById('signatureCanvas');
            if (canvas) {
                let signaturePad = new SignaturePad(canvas, {
                    backgroundColor: 'white',
                    penColor: 'rgb(0, 0, 0)',
                    throttle: 16
                });

                // Handle clear button
                document.getElementById('clearSignature').addEventListener('click', function () {
                    signaturePad.clear();
                    document.getElementById('signaturePreview').style.display = 'none';
                    document.getElementById('noSignatureText').style.display = 'block';
                    document.getElementById('<%= hdnSignatureData.ClientID %>').value = '';
                    document.getElementById('<%= hdnIsSigned.ClientID %>').value = 'false';
                });
                
                // Handle save button
                document.getElementById('saveSignature').addEventListener('click', function () {
                    if (signaturePad.isEmpty()) {
                        alert('Please provide your signature first.');
                        return;
                    }
                    
                    const signatureData = signaturePad.toDataURL('image/png');
                    document.getElementById('<%= hdnSignatureData.ClientID %>').value = signatureData;
                    document.getElementById('<%= hdnIsSigned.ClientID %>').value = 'true';
                    
                    // Show preview
                    const previewImg = document.getElementById('signaturePreview');
                    previewImg.src = signatureData;
                    previewImg.style.display = 'block';
                    document.getElementById('noSignatureText').style.display = 'none';
                    
                    alert('Signature saved successfully!');
                });
                
                // Resize canvas
                function resizeCanvas() {
                    const ratio = Math.max(window.devicePixelRatio || 1, 1);
                    canvas.width = canvas.offsetWidth * ratio;
                    canvas.height = canvas.offsetHeight * ratio;
                    canvas.getContext("2d").scale(ratio, ratio);
                    signaturePad.clear();
                }
                
                window.addEventListener('resize', resizeCanvas);
                resizeCanvas();
            }
            
            // Employee agreement validation
            window.validateEmployeeAgreement = function(source, args) {
                const isAgreed = document.getElementById('<%= chkAgreeTerms.ClientID %>').checked;
                const isSigned = document.getElementById('<%= hdnIsSigned.ClientID %>').value === 'true';
                
                if (!isAgreed || !isSigned) {
                    args.IsValid = false;
                    alert('Please agree to the terms and provide your signature.');
                } else {
                    args.IsValid = true;
                }
            }
            
            // CRITICAL FIX: Remove view-mode class from employee fields
            setTimeout(function() {
                const empName = document.getElementById('<%= txtEmpName.ClientID %>');
                const empPosition = document.getElementById('<%= txtEmpPosition.ClientID %>');
                const empDepartment = document.getElementById('<%= txtEmpDepartment.ClientID %>');
                
                if (empName) {
                    empName.classList.remove('readonly-control');
                    empName.style.cursor = 'text';
                    empName.readOnly = false;
                    empName.disabled = false;
                    empName.style.pointerEvents = 'auto';
                }
                if (empPosition) {
                    empPosition.classList.remove('readonly-control');
                    empPosition.style.cursor = 'text';
                    empPosition.readOnly = false;
                    empPosition.disabled = false;
                    empPosition.style.pointerEvents = 'auto';
                }
                if (empDepartment) {
                    empDepartment.classList.remove('readonly-control');
                    empDepartment.style.cursor = 'text';
                    empDepartment.readOnly = false;
                    empDepartment.disabled = false;
                    empDepartment.style.pointerEvents = 'auto';
                }
                
                const isEmployeeMode = window.location.href.includes('token=');

                if (isEmployeeMode) {
                    const formContainer = document.getElementById('<%= formContainer.ClientID %>');
                    if (formContainer) {
                        formContainer.classList.remove('view-mode');
                    }
                }
            }, 100);
            
            // Backup employee field values before PostBack
            const btnSubmitEmployee = document.getElementById('<%= btnSubmitEmployee.ClientID %>');
            if (btnSubmitEmployee) {
                btnSubmitEmployee.addEventListener('click', function(e) {
                    // Backup values to hidden fields
                    const empName = document.getElementById('<%= txtEmpName.ClientID %>').value;
                    const empPosition = document.getElementById('<%= txtEmpPosition.ClientID %>').value;
                    const empDepartment = document.getElementById('<%= txtEmpDepartment.ClientID %>').value;
                    
                    document.getElementById('<%= hdnEmpNameBackup.ClientID %>').value = empName;
                    document.getElementById('<%= hdnEmpPositionBackup.ClientID %>').value = empPosition;
                    document.getElementById('<%= hdnEmpDepartmentBackup.ClientID %>').value = empDepartment;
                    
                    console.log('Backup values:', {
                        name: empName,
                        position: empPosition,
                        department: empDepartment
                    });
                });
            }
            
            // Restore values on page load if they were backed up AND fix field states
            window.addEventListener('load', function() {
                const backupName = document.getElementById('<%= hdnEmpNameBackup.ClientID %>').value;
                const backupPosition = document.getElementById('<%= hdnEmpPositionBackup.ClientID %>').value;
                const backupDepartment = document.getElementById('<%= hdnEmpDepartmentBackup.ClientID %>').value;
    
                if (backupName) {
                    document.getElementById('<%= txtEmpName.ClientID %>').value = backupName;
                }
                if (backupPosition) {
                    document.getElementById('<%= txtEmpPosition.ClientID %>').value = backupPosition;
                }
                if (backupDepartment) {
                    document.getElementById('<%= txtEmpDepartment.ClientID %>').value = backupDepartment;
                }
    
                // Only run if we're in employee mode (check URL for token)
                const isEmployeeMode = window.location.href.includes('token=');
    
                if (isEmployeeMode) {
                    // Safely check field status
                    const empNameField = document.getElementById('<%= txtEmpName.ClientID %>');
                    if (empNameField) {
                        console.log('Employee Name field status:');
                        console.log('- disabled:', empNameField.disabled);
                        console.log('- readonly:', empNameField.readOnly);
                        console.log('- class:', empNameField.className);
            
                        // Ensure field is not disabled
                        if (empNameField.disabled) {
                            empNameField.disabled = false;
                            empNameField.readOnly = false;
                            empNameField.classList.remove('aspNetDisabled');
                            empNameField.classList.add('form-control');
                        }
                    }
        
                    // Also fix other employee fields
                    const empPositionField = document.getElementById('<%= txtEmpPosition.ClientID %>');
                    if (empPositionField && empPositionField.disabled) {
                        empPositionField.disabled = false;
                        empPositionField.readOnly = false;
                        empPositionField.classList.remove('aspNetDisabled');
                        empPositionField.classList.add('form-control');
                    }
        
                    const empDepartmentField = document.getElementById('<%= txtEmpDepartment.ClientID %>');
                    if (empDepartmentField && empDepartmentField.disabled) {
                        empDepartmentField.disabled = false;
                        empDepartmentField.readOnly = false;
                        empDepartmentField.classList.remove('aspNetDisabled');
                        empDepartmentField.classList.add('form-control');
                    }
        
                    // Remove view-mode class from form container
                    const formContainer = document.getElementById('<%= formContainer.ClientID %>');
                    if (formContainer && formContainer.classList.contains('view-mode')) {
                        formContainer.classList.remove('view-mode');
                    }
                }
            });
        });
    </script>
</body>
</html>