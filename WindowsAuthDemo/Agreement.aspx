﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Agreement.aspx.cs" Inherits="WindowsAuthDemo.Agreement" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title><asp:Literal ID="litPageTitle" runat="server"></asp:Literal></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        :root {
            --primary: #4361ee;
            --primary-dark: #3a56d4;
            --secondary: #7209b7;
            --sidebar-bg: #1e293b;
            --sidebar-text: #e2e8f0;
            --sidebar-hover: #334155;
            --content-bg: #f8fafc;
            --card-bg: #ffffff;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --border-color: #e2e8f0;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #3b82f6;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        body {
            background-color: var(--content-bg);
            color: var(--text-primary);
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--sidebar-bg);
            color: var(--sidebar-text);
            position: fixed;
            height: 100vh;
            transition: all 0.3s ease;
            z-index: 1000;
            box-shadow: var(--shadow-lg);
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sidebar-header i {
            font-size: 1.8rem;
            color: var(--primary);
            background: rgba(255, 255, 255, 0.1);
            padding: 10px;
            border-radius: 10px;
        }

        .sidebar-header h2 {
            font-size: 1.3rem;
            font-weight: 600;
            color: white;
        }

        .nav-links {
            padding: 20px 0;
        }

        .nav-item {
            list-style: none;
            margin: 4px 12px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            color: var(--sidebar-text);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.2s ease;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .nav-link:hover {
            background: var(--sidebar-hover);
            color: white;
            transform: translateX(5px);
        }

        .nav-link.active {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
        }

        .nav-link i {
            font-size: 1.1rem;
            width: 24px;
            text-align: center;
        }

        .nav-divider {
            height: 1px;
            background: rgba(255, 255, 255, 0.1);
            margin: 20px 16px;
        }

        .user-info-sidebar {
            padding: 20px 16px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            position: absolute;
            bottom: 0;
            width: 100%;
            background: rgba(0, 0, 0, 0.2);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: white;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 24px;
            transition: all 0.3s ease;
        }

        /* Header */
        .page-header {
            margin-bottom: 30px;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 8px;
        }

        .header-title h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .header-title .status-badge {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-draft {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }

        .status-pending {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .status-active {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .status-inactive {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .header-subtitle {
            color: var(--text-secondary);
            font-size: 1rem;
            margin-bottom: 16px;
        }

        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 24px;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .breadcrumb a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .breadcrumb .separator {
            color: var(--border-color);
        }

        /* Form Container */
        .form-container {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        /* Agreement Info Bar */
        .agreement-info-bar {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 0.8rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
            font-weight: 600;
        }

        .info-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* Messages */
        .message {
            padding: 16px 24px;
            border-radius: 8px;
            margin: 16px 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .message-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border: 1px solid #6ee7b7;
        }

        .message-error {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        /* Form Sections */
        .form-sections {
            padding: 24px;
        }

        .form-section {
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 1px solid var(--border-color);
        }

        .form-section:last-child {
            border-bottom: none;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--primary);
        }

        .section-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .section-subtitle {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-top: 4px;
        }

        /* Form Grid */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.95rem;
        }

        .form-label.required::after {
            content: " *";
            color: var(--danger);
        }

        .form-control, .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            font-size: 1rem;
            color: var(--text-primary);
            background: white;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        .form-control.auto-fill {
            background-color: #f8fafc;
            border-color: #e2e8f0;
            color: var(--text-secondary);
        }

        .form-control.readonly, .form-select.readonly {
            background-color: #f8fafc;
            border-color: #e2e8f0;
            color: var(--text-secondary);
            cursor: not-allowed;
        }

        .helper-text {
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-top: 6px;
            font-style: italic;
        }

        /* Other Model Panel */
        .other-model-panel {
            background: linear-gradient(135deg, #f8faff, #f0f4ff);
            border: 2px dashed var(--border-color);
            border-radius: 12px;
            padding: 20px;
            margin-top: 15px;
        }

        .other-model-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
            color: var(--primary);
            font-weight: 600;
        }

        .other-model-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        /* Accessories Grid */
        .accessories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: 16px;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .checkbox-group:hover {
            border-color: var(--primary);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .checkbox-group input[type="checkbox"] {
            width: 20px;
            height: 20px;
            accent-color: var(--primary);
        }

        .checkbox-group label {
            font-weight: 500;
            color: var(--text-primary);
            cursor: pointer;
            flex: 1;
        }

        .radio-group {
            display: flex;
            gap: 16px;
            margin-top: 12px;
        }

        .radio-option {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .radio-option:hover {
            border-color: var(--primary);
        }

        .radio-option input[type="radio"] {
            accent-color: var(--primary);
        }

        /* Textarea */
        .form-control.remarks-box {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
        }

        /* Status Section */
        .status-section {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
        }

        .status-options {
            display: flex;
            gap: 20px;
            margin-top: 12px;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 16px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
        }

        .btn {
            padding: 12px 28px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(67, 97, 238, 0.3);
        }

        .btn-outline {
            background: white;
            color: var(--primary);
            border: 2px solid var(--primary);
        }

        .btn-outline:hover {
            background: var(--primary);
            color: white;
        }

        .btn-secondary {
            background: var(--text-secondary);
            color: white;
        }

        .btn-secondary:hover {
            background: #4b5563;
            transform: translateY(-2px);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger), #dc2626);
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.3);
        }

        /* View Mode */
        .view-mode .form-control,
        .view-mode .form-select,
        .view-mode .checkbox-group,
        .view-mode .radio-option {
            cursor: not-allowed;
            opacity: 0.8;
        }

        .view-mode .checkbox-group:hover,
        .view-mode .radio-option:hover {
            border-color: var(--border-color);
            transform: none;
            box-shadow: none;
        }

        /* Validation */
        .validation-error {
            color: var(--danger);
            font-size: 0.85rem;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .sidebar {
                width: 80px;
            }

            .sidebar-header h2,
            .nav-link span {
                display: none;
            }

            .main-content {
                margin-left: 80px;
            }

            .sidebar-header {
                justify-content: center;
                padding: 20px 0;
            }

            .nav-link {
                justify-content: center;
                padding: 16px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .main-content {
                margin-left: 0;
                padding: 16px;
            }

            .agreement-info-bar {
                grid-template-columns: 1fr;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .accessories-grid {
                grid-template-columns: 1fr;
            }

            .other-model-grid {
                grid-template-columns: 1fr;
            }

            .status-options {
                flex-direction: column;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 12px;
            }

            .form-sections {
                padding: 16px;
            }

            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
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
                    <asp:Literal ID="litHeaderTitle" runat="server"></asp:Literal>
                </span>
            </div>

            <!-- Page Header -->
            <div class="page-header">
                <div class="header-title">
                    <h1>
                        <i class="fas fa-file-contract"></i>
                        <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                    </h1>
                    <asp:Literal ID="litStatusBadge" runat="server"></asp:Literal>
                </div>
                <div class="header-subtitle">
                    <asp:Literal ID="litHeaderDescription" runat="server"></asp:Literal>
                </div>
            </div>

            <!-- Form Container -->
            <div class="form-container">
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
                <div class="form-sections" id="formContainer" runat="server">
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
                                            <asp:DropDownList ID="ddlDeviceType" runat="server" CssClass="form-select">
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

                    <!-- Accessories Section -->
                    <div class="form-section">
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
                                <label for="chkCarryBag">Carry Bag</label>
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
                    </div>

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
                </div>
            </div>

            <!-- Footer -->
            <div style="margin-top: 40px; text-align: center; color: var(--text-secondary); font-size: 0.85rem;">
                <p>Hardware Agreement System &copy; <%= DateTime.Now.Year %> | Secure Enterprise Portal</p>
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

            document.body.appendChild(sidebarToggle);

            sidebarToggle.addEventListener('click', function () {
                document.querySelector('.sidebar').classList.toggle('mobile-open');
            });

            function handleResize() {
                if (window.innerWidth <= 768) {
                    sidebarToggle.style.display = 'flex';
                } else {
                    sidebarToggle.style.display = 'none';
                }
            }

            window.addEventListener('resize', handleResize);
            handleResize();
        });
    </script>
</body>
</html>