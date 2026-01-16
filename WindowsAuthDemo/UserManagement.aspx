<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs" Inherits="WindowsAuthDemo.UserManagement" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>User Management - Hardware Agreement Portal</title>
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
            --info: #3b82f6;
            --warning: #f59e0b;
            --danger: #ef4444;
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

        /* Sidebar - Same as Default.aspx */
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
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .page-title h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .page-title p {
            color: var(--text-secondary);
            margin-top: 4px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            background: white;
            padding: 10px 16px;
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        .user-profile i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        /* User Management Content */
        .user-management-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Section Headers */
        .section-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
        }

        .section-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .section-title h2 {
            color: var(--text-primary);
            font-size: 1.5rem;
            font-weight: 700;
        }

        .section-title p {
            color: var(--text-secondary);
            margin-top: 4px;
        }

        /* Form Styles */
        .form-container {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 30px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            margin-bottom: 30px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-primary);
            background: white;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-primary);
            background: white;
            cursor: pointer;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 8px;
        }

        .checkbox-label {
            font-size: 0.95rem;
            color: var(--text-primary);
            cursor: pointer;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-secondary {
            background: var(--text-secondary);
            color: white;
        }

        .btn-secondary:hover {
            background: #475569;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-success:hover {
            background: #0da271;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Table Styles */
        .table-container {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 30px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .table-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .search-box {
            position: relative;
            width: 300px;
        }

        .search-input {
            width: 100%;
            padding: 12px 16px 12px 40px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.95rem;
        }

        .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }

        .table-responsive {
            overflow-x: auto;
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
        }

        .users-table th {
            background: var(--content-bg);
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 2px solid var(--border-color);
            white-space: nowrap;
        }

        .users-table td {
            padding: 16px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .users-table tr:hover {
            background: rgba(67, 97, 238, 0.05);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .status-inactive {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }

        .role-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }

        .role-admin {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .role-user {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-sm {
            padding: 8px 12px;
            font-size: 0.85rem;
        }

        .btn-edit {
            background: rgba(59, 130, 246, 0.1);
            color: var(--info);
            border: 1px solid rgba(59, 130, 246, 0.2);
        }

        .btn-edit:hover {
            background: var(--info);
            color: white;
        }

        .btn-delete {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
        }

        /* Messages */
        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: var(--success);
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: var(--danger);
        }

        .alert-warning {
            background: rgba(245, 158, 11, 0.1);
            border: 1px solid rgba(245, 158, 11, 0.3);
            color: var(--warning);
        }

        /* Footer */
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        /* Access Denied */
        .access-denied {
            text-align: center;
            padding: 60px 20px;
            max-width: 600px;
            margin: 40px auto;
        }

        .denied-icon {
            font-size: 4rem;
            color: var(--danger);
            margin-bottom: 24px;
        }

        .denied-title {
            font-size: 2rem;
            color: var(--text-primary);
            margin-bottom: 16px;
        }

        .denied-message {
            color: var(--text-secondary);
            margin-bottom: 32px;
            line-height: 1.6;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .sidebar {
                width: 80px;
            }

            .sidebar-header h2,
            .nav-link span,
            .user-info-sidebar .user-name {
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
            }

            .nav-links {
                display: flex;
                overflow-x: auto;
                padding: 10px;
            }

            .nav-item {
                flex-shrink: 0;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .form-actions .btn {
                width: 100%;
            }

            .table-header {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }

            .search-box {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 16px;
            }

            .top-header {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }

            .action-buttons {
                flex-direction: column;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-container,
        .table-container {
            animation: fadeIn 0.5s ease-out;
        }
        .text-truncate {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 300px;
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
                    <a href="Agreement.aspx" class="nav-link">
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
                    <a href="UserManagement.aspx" class="nav-link active">
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
                        <div class="user-name" style="font-weight: 600;">
                            <asp:Label ID="lblUserRoleSidebar" runat="server"></asp:Label>
                        </div>
                        <div style="font-size: 0.85rem; color: #94a3b8;">
                            <asp:Label ID="lblUserSidebar" runat="server"></asp:Label>
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
                    <h1>User Management</h1>
                    <p>Add, remove, or modify user permissions</p>
                </div>
                <div class="user-profile">
                    <i class="fas fa-user-circle"></i>
                    <div>
                        <div style="font-weight: 600;">
                            <asp:Label ID="lblUser" runat="server"></asp:Label>
                        </div>
                        <div style="font-size: 0.85rem; color: var(--text-secondary);">
                            <asp:Label ID="lblStatus" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Access Check -->
            <asp:Panel ID="pnlAccessDenied" runat="server" Visible="false">
                <div class="access-denied">
                    <div class="denied-icon">
                        <i class="fas fa-ban"></i>
                    </div>
                    <h2 class="denied-title">Access Denied</h2>
                    <p class="denied-message">
                        You don't have administrator privileges to access the User Management page.
                        Only users with administrator role can manage user permissions.
                    </p>
                    <a href="Default.aspx" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i>
                        Back to Dashboard
                    </a>
                </div>
            </asp:Panel>

            <!-- User Management Content (Visible only for admins) -->
            <asp:Panel ID="pnlUserManagement" runat="server" Visible="false">
                <div class="user-management-container">
                    <!-- Messages -->
                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert">
                        <i class="fas fa-info-circle"></i>
                        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                    </asp:Panel>

                    <!-- Add/Edit User Form -->
                    <div class="form-container">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-user-edit"></i>
                            </div>
                            <div class="section-title">
                                <h2>
                                    <asp:Literal ID="litFormTitle" runat="server" Text="Add New User"></asp:Literal>
                                </h2>
                                <p>Enter user details below</p>
                            </div>
                        </div>

                        <asp:HiddenField ID="hdnUserId" runat="server" />

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Windows ID *</label>
                                <asp:TextBox ID="txtWinId" runat="server" CssClass="form-control" 
                                    placeholder="DOMAIN\username" required="true"></asp:TextBox>
                                <small style="color: var(--text-secondary); font-size: 0.85rem; margin-top: 4px; display: block;">
                                    Format: DOMAIN\username (e.g., COMPANY\john.doe)
                                </small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Email Address *</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                                    placeholder="user@company.com" TextMode="Email" required="true"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">User Status</label>
                                <asp:DropDownList ID="ddlActive" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="1" Text="Active" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="Inactive"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group">
                                <label class="form-label">User Role</label>
                                <asp:DropDownList ID="ddlAdmin" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="0" Text="Normal User" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Administrator"></asp:ListItem>
                                </asp:DropDownList>
                                <small style="color: var(--text-secondary); font-size: 0.85rem; margin-top: 4px; display: block;">
                                    Administrators can access all system features
                                </small>
                            </div>
                        </div>

                        <div class="form-actions">
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary"
                                OnClick="btnCancel_Click" Visible="false" />
                            <asp:Button ID="btnSave" runat="server" Text="Save User" CssClass="btn btn-success"
                                OnClick="btnSave_Click" />
                            <asp:Button ID="btnClear" runat="server" Text="Clear Form" CssClass="btn btn-secondary"
                                OnClick="btnClear_Click" />
                        </div>
                    </div>

                    <!-- Users List -->
                    <div class="table-container">
                        <div class="table-header">
                            <h3 class="table-title">All Users</h3>
                            <div class="search-box">
                                <i class="fas fa-search search-icon"></i>
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" 
                                    placeholder="Search users..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" 
                                CssClass="users-table" DataKeyNames="win_id"
                                OnRowEditing="gvUsers_RowEditing" OnRowDeleting="gvUsers_RowDeleting"
                                AllowPaging="true" PageSize="10" OnPageIndexChanging="gvUsers_PageIndexChanging">
                                <Columns>
                                    <asp:BoundField DataField="win_id" HeaderText="Windows ID" SortExpression="win_id" />
                                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                                    <asp:TemplateField HeaderText="Status" SortExpression="active">
                                        <ItemTemplate>
                                            <span class='status-badge <%# Convert.ToInt32(Eval("active")) == 1 ? "status-active" : "status-inactive" %>'>
                                                <%# Convert.ToInt32(Eval("active")) == 1 ? "Active" : "Inactive" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Role" SortExpression="admin">
                                        <ItemTemplate>
                                            <span class='role-badge <%# Convert.ToInt32(Eval("admin")) == 1 ? "role-admin" : "role-user" %>'>
                                                <%# Convert.ToInt32(Eval("admin")) == 1 ? "Administrator" : "Normal User" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <div class="action-buttons">
                                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" 
                                                    CssClass="btn btn-sm btn-edit" ToolTip="Edit User">
                                                    <i class="fas fa-edit"></i> Edit
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                                                    CssClass="btn btn-sm btn-delete" ToolTip="Delete User"
                                                    OnClientClick="return confirm('Are you sure you want to delete this user?');">
                                                    <i class="fas fa-trash"></i> Delete
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div style="text-align: center; padding: 40px; color: var(--text-secondary);">
                                        <i class="fas fa-users" style="font-size: 3rem; margin-bottom: 16px; opacity: 0.5;"></i>
                                        <h3>No users found</h3>
                                        <p>Start by adding a new user using the form above.</p>
                                    </div>
                                </EmptyDataTemplate>
                                <PagerStyle CssClass="pagination" />
                            </asp:GridView>
                        </div>
                    </div>

                    <!-- Audit Logs Section -->
                    <div class="table-container" style="margin-top: 30px;">
                        <div class="table-header">
                            <h3 class="table-title">
                                <i class="fas fa-history" style="margin-right: 8px;"></i>
                                Audit Logs
                            </h3>
                            <div style="display: flex; gap: 12px; align-items: center;">
                                <div style="font-size: 0.85rem; color: var(--text-secondary);">
                                    Last 50 actions
                                </div>
                                <asp:Button ID="btnViewLogs" runat="server" Text="Refresh Logs" 
                                    CssClass="btn btn-sm btn-secondary" OnClick="btnViewLogs_Click" />
                            </div>
                        </div>
    
                        <div class="table-responsive">
                            <asp:GridView ID="gvAuditLogs" runat="server" AutoGenerateColumns="false" 
                                CssClass="users-table" AllowPaging="true" PageSize="10">
                                <Columns>
                                    <asp:BoundField DataField="timestamp" HeaderText="Timestamp" 
                                        DataFormatString="{0:dd/MM/yyyy HH:mm:ss}" SortExpression="timestamp" />
                                    <asp:BoundField DataField="admin_user" HeaderText="Admin User" SortExpression="admin_user" />
                                    <asp:TemplateField HeaderText="Action Type" SortExpression="action_type">
                                        <ItemTemplate>
                                            <span class='status-badge 
                                                <%# Eval("action_type").ToString() == "CREATE" ? "status-active" : 
                                                   Eval("action_type").ToString() == "UPDATE" ? "status-inactive" : 
                                                   Eval("action_type").ToString() == "DELETE" ? "role-user" : "" %>'>
                                                <%# Eval("action_type") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="target_user" HeaderText="Target User" SortExpression="target_user" />
                                    <asp:BoundField DataField="description" HeaderText="Description" 
                                        ItemStyle-Width="300px" ItemStyle-CssClass="text-truncate" />
                                </Columns>
                                <EmptyDataTemplate>
                                    <div style="text-align: center; padding: 40px; color: var(--text-secondary);">
                                        <i class="fas fa-history" style="font-size: 3rem; margin-bottom: 16px; opacity: 0.5;"></i>
                                        <h3>No audit logs found</h3>
                                        <p>Audit logs will appear here when actions are performed.</p>
                                    </div>
                                </EmptyDataTemplate>
                                <PagerStyle CssClass="pagination" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <div class="footer">
                <p>User Management &copy; <%= DateTime.Now.Year %> | Last updated: <%= DateTime.Now.ToString("MMMM dd, yyyy HH:mm:ss") %></p>
                <p style="margin-top: 8px; font-size: 0.8rem; color: #94a3b8;">
                    Windows Authentication | Secure Enterprise Portal
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
                if (link.getAttribute('href') === currentPage) {
                    link.classList.add('active');
                }
            });

            // Add sidebar toggle for mobile
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

            // Responsive adjustments
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