﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExistingAgreements.aspx.cs" Inherits="WindowsAuthDemo.ExistingAgreements" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Agreements Management</title>
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

        /* Statistics Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 24px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            text-align: center;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 1.4rem;
            color: white;
        }

        .stat-icon.total { background: linear-gradient(135deg, var(--primary), var(--secondary)); }
        .stat-icon.draft { background: linear-gradient(135deg, #f59e0b, #d97706); }
        .stat-icon.pending { background: linear-gradient(135deg, #3b82f6, #1d4ed8); }
        .stat-icon.active { background: linear-gradient(135deg, #10b981, #059669); }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-primary);
            margin: 8px 0;
        }

        .stat-label {
            font-size: 0.85rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        /* Filters Section */
        .filters-section {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
        }

        .filters-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .filters-header i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .filters-header h3 {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .filter-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .filter-select, .search-input {
            width: 100%;
            padding: 10px 14px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.95rem;
            color: var(--text-primary);
            background: white;
            transition: all 0.2s ease;
        }

        .filter-select:focus, .search-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        /* Agreements Table */
        .table-container {
            background: var(--card-bg);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
        }

        .table-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-controls {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table thead {
            background: #f8fafc;
        }

        .table th {
            padding: 16px 20px;
            text-align: left;
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 2px solid var(--border-color);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-secondary);
            vertical-align: middle;
        }

        .table tbody tr {
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
        }

        /* Status Badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-draft {
            background: linear-gradient(135deg, #fffbeb, #fef3c7);
            color: #92400e;
            border: 1px solid #fde68a;
        }

        .status-pending {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            color: #1e40af;
            border: 1px solid #93c5fd;
        }

        .status-active {
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            color: #065f46;
            border: 1px solid #6ee7b7;
        }

        .status-inactive {
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            width: 36px;
            height: 36px;
            border: none;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            color: white;
            font-size: 0.9rem;
        }

        .btn-edit {
            background: var(--primary);
        }

        .btn-edit:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .btn-view {
            background: var(--text-secondary);
        }

        .btn-view:hover {
            background: #4b5563;
            transform: translateY(-2px);
        }

        .btn-delete {
            background: var(--danger);
        }

        .btn-delete:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }

        /* No Data Message */
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-secondary);
        }

        .no-data-icon {
            font-size: 3rem;
            color: var(--border-color);
            margin-bottom: 16px;
        }

        .no-data h3 {
            font-size: 1.2rem;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }

        .no-data p {
            color: var(--text-secondary);
            opacity: 0.7;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            padding: 24px;
            border-top: 1px solid var(--border-color);
            background: #f8fafc;
        }

        .page-link {
            padding: 8px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            text-decoration: none;
            transition: all 0.2s ease;
            font-size: 0.9rem;
            min-width: 40px;
            text-align: center;
        }

        .page-link:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .page-link.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
            font-weight: 600;
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

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .filters-grid {
                grid-template-columns: 1fr;
            }

            .table-container {
                overflow-x: auto;
            }

            .table {
                min-width: 800px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 4px;
            }

            .btn-action {
                width: 32px;
                height: 32px;
                font-size: 0.8rem;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 12px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .pagination {
                flex-wrap: wrap;
                gap: 8px;
            }

            .page-link {
                padding: 6px 12px;
                min-width: 36px;
            }
        }

        /* Loading Animation */
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

        .stat-card, .filters-section, .table-container {
            animation: fadeIn 0.5s ease-out;
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
                    <a href="ExistingAgreements.aspx" class="nav-link active">
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
                <span style="color: var(--text-secondary);">Agreements Management</span>
            </div>

            <!-- Page Header -->
            <div class="page-header">
                <div class="header-title">
                    <h1>
                        <i class="fas fa-file-contract"></i>
                        Agreements Management
                    </h1>
                </div>
                <div class="header-subtitle">
                    View, search, and manage all hardware agreements in the system
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon total">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stat-value">
                        <asp:Literal ID="litTotal" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Total Agreements</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon draft">
                        <i class="fas fa-edit"></i>
                    </div>
                    <div class="stat-value">
                        <asp:Literal ID="litDrafts" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Drafts</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon pending">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-value">
                        <asp:Literal ID="litPending" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Pending</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon active">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-value">
                        <asp:Literal ID="litActive" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Active</div>
                </div>
            </div>

            <!-- Filters Section -->
            <div class="filters-section">
                <div class="filters-header">
                    <i class="fas fa-filter"></i>
                    <h3>Filter Agreements</h3>
                </div>
                <div class="filters-grid">
                    <div class="filter-group">
                        <label class="filter-label">Status</label>
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="filter-select" 
                            AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                            <asp:ListItem Value="">All Status</asp:ListItem>
                            <asp:ListItem Value="Draft">Draft</asp:ListItem>
                            <asp:ListItem Value="Pending">Pending</asp:ListItem>
                            <asp:ListItem Value="Active">Active</asp:ListItem>
                            <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label">Sort By</label>
                        <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="filter-select" 
                            AutoPostBack="true" OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">
                            <asp:ListItem Value="created_date">Newest First</asp:ListItem>
                            <asp:ListItem Value="created_date ASC">Oldest First</asp:ListItem>
                            <asp:ListItem Value="agreement_number">Agreement Number</asp:ListItem>
                            <asp:ListItem Value="agreement_status">Status</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label">Search</label>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" 
                            placeholder="Search by agreement number, serial, or asset..." 
                            AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Agreements Table -->
            <div class="table-container">
                <div class="table-header">
                    <div class="table-title">
                        <i class="fas fa-list"></i>
                        All Agreements
                    </div>
                    <div class="table-controls">
                        <span class="filter-label" style="font-size: 0.85rem;">
                            Showing <strong><asp:Literal ID="litShowingCount" runat="server" Text="0"></asp:Literal></strong> of <strong><asp:Literal ID="litTotalCount" runat="server" Text="0"></asp:Literal></strong> agreements
                        </span>
                    </div>
                </div>

                <!-- Agreements Grid -->
                <asp:GridView ID="gvAgreements" runat="server" CssClass="table" 
                    AutoGenerateColumns="false" OnRowCommand="gvAgreements_RowCommand"
                    OnRowDataBound="gvAgreements_RowDataBound"
                    ShowHeaderWhenEmpty="true">
                    <Columns>
                        <asp:TemplateField HeaderText="Agreement Number">
                            <ItemTemplate>
                                <div style="font-weight: 600; color: var(--text-primary);">
                                    <%# Eval("agreement_number") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="model" HeaderText="Model" 
                            ItemStyle-CssClass="text-secondary" />

                        <asp:TemplateField HeaderText="Serial / Asset">
                            <ItemTemplate>
                                <div style="font-size: 0.85rem;">
                                    <div><strong>S/N:</strong> <%# Eval("serial_number") %></div>
                                    <div><strong>A/N:</strong> <%# Eval("asset_number") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class="status-badge status-<%# Eval("agreement_status").ToString().ToLower() %>">
                                    <i class="fas fa-circle" style="font-size: 0.5rem;"></i>
                                    <%# Eval("agreement_status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="IT Staff">
                            <ItemTemplate>
                                <div style="font-size: 0.85rem;">
                                    <i class="fas fa-user" style="color: var(--text-secondary); margin-right: 6px;"></i>
                                    <%# Eval("it_staff_win_id") %>
                                </div>
                                <div style="font-size: 0.75rem; color: var(--text-secondary);">
                                    <i class="fas fa-calendar" style="margin-right: 4px;"></i>
                                    <%# Convert.ToDateTime(Eval("issue_date")).ToString("dd MMM yyyy") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <!-- Edit button - only for Draft status -->
                                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn-action btn-edit"
                                        CommandName="EditAgreement" CommandArgument='<%# Eval("id") %>'
                                        ToolTip="Edit Agreement" Visible="false">
                                        <i class="fas fa-edit"></i>
                                    </asp:LinkButton>
                    
                                    <!-- View button - for all statuses -->
                                    <asp:LinkButton ID="btnView" runat="server" CssClass="btn-action btn-view"
                                        CommandName="ViewAgreement" CommandArgument='<%# Eval("id") %>'
                                        ToolTip="View Details">
                                        <i class="fas fa-eye"></i>
                                    </asp:LinkButton>
                    
                                    <!-- Delete button - for all statuses -->
                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn-action btn-delete"
                                        CommandName="DeleteAgreement" CommandArgument='<%# Eval("id") %>'
                                        OnClientClick="return confirm('Are you sure you want to delete this agreement? This action cannot be undone.');"
                                        ToolTip="Delete Agreement">
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-data">
                            <div class="no-data-icon">
                                <i class="fas fa-file-contract"></i>
                            </div>
                            <h3>No Agreements Found</h3>
                            <p>Try adjusting your filters or create a new agreement</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>

                <!-- Pagination -->
                <div class="pagination">
                    <asp:Repeater ID="rptPagination" runat="server" OnItemCommand="rptPagination_ItemCommand">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkPage" runat="server" 
                                CommandName="Page" 
                                CommandArgument='<%# Eval("PageNumber") %>'
                                CssClass='<%# Container.DataItem != null && Convert.ToInt32(((System.Data.DataRowView)Container.DataItem)["PageNumber"]) == CurrentPage ? "page-link active" : "page-link" %>'
                                Text='<%# Eval("PageNumber") %>'>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Footer -->
            <div style="margin-top: 40px; text-align: center; color: var(--text-secondary); font-size: 0.85rem;">
                <p>Hardware Agreement System &copy; <%= DateTime.Now.Year %> | Last updated: <%= DateTime.Now.ToString("dd MMM yyyy HH:mm") %></p>
            </div>
        </main>
    </form>

    <script>
        // Add active class to current page
        document.addEventListener('DOMContentLoaded', function() {
            const currentPage = window.location.pathname.split('/').pop();
            const navLinks = document.querySelectorAll('.nav-link');
            
            navLinks.forEach(link => {
                if (link.getAttribute('href') === currentPage) {
                    link.classList.add('active');
                }
            });

            // Update showing count
            const tableRows = document.querySelectorAll('.table tbody tr');
            const showingCount = tableRows.length;
            if (document.getElementById('<%= litShowingCount.ClientID %>')) {
                document.getElementById('<%= litShowingCount.ClientID %>').textContent = showingCount;
            }

            // Enhanced search with debounce
            const searchInput = document.getElementById('<%= txtSearch.ClientID %>');
            if (searchInput) {
                let searchTimeout;
                searchInput.addEventListener('input', function () {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => {
                        if (this.value.length >= 3 || this.value.length === 0) {
                            this.form.submit();
                        }
                    }, 500);
                });
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

            // Add row hover effects
            const rows = document.querySelectorAll('.table tbody tr');
            rows.forEach(row => {
                row.addEventListener('mouseenter', function () {
                    this.style.backgroundColor = '#f8fafc';
                });
                row.addEventListener('mouseleave', function () {
                    this.style.backgroundColor = '';
                });
            });

            // Add keyboard shortcuts
            document.addEventListener('keydown', function (e) {
                // Ctrl+F for search focus
                if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
                    e.preventDefault();
                    const searchInput = document.getElementById('<%= txtSearch.ClientID %>');
                    if (searchInput) {
                        searchInput.focus();
                    }
                }
            });
        });
    </script>
</body>
</html>