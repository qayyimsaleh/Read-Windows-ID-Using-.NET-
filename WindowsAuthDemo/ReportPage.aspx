<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportPage.aspx.cs" Inherits="WindowsAuthDemo.ReportPage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Reports & Analytics - Hardware Agreement Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            --chart-1: #4361ee;
            --chart-2: #7209b7;
            --chart-3: #10b981;
            --chart-4: #f59e0b;
            --chart-5: #ef4444;
            --chart-6: #8b5cf6;
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

        /* Filters Section */
        .filters-section {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 30px;
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
            margin-bottom: 20px;
        }

        .filter-group {
            margin-bottom: 16px;
        }

        .filter-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
        }

        .filter-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-primary);
            background: white;
            transition: all 0.3s ease;
        }

        .filter-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        .filter-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            padding-top: 20px;
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

        .btn-export {
            background: var(--success);
            color: white;
        }

        .btn-export:hover {
            background: #0da271;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* KPI Cards */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .kpi-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .kpi-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .kpi-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .kpi-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: white;
        }

        .kpi-icon.total { background: linear-gradient(135deg, var(--chart-1), #3a56d4); }
        .kpi-icon.active { background: linear-gradient(135deg, var(--chart-3), #0da271); }
        .kpi-icon.pending { background: linear-gradient(135deg, var(--chart-4), #d97706); }
        .kpi-icon.laptops { background: linear-gradient(135deg, var(--chart-5), #dc2626); }
        .kpi-icon.desktops { background: linear-gradient(135deg, var(--chart-2), #6d28d9); }
        .kpi-icon.others { background: linear-gradient(135deg, var(--chart-6), #7c3aed); }

        .kpi-trend {
            font-size: 0.85rem;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 20px;
        }

        .trend-up { background: rgba(16, 185, 129, 0.1); color: var(--success); }
        .trend-down { background: rgba(239, 68, 68, 0.1); color: var(--danger); }
        .trend-neutral { background: rgba(148, 163, 184, 0.1); color: var(--text-secondary); }

        .kpi-title {
            font-size: 0.9rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .kpi-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
        }

        .kpi-subtitle {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        /* Charts Section */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 24px;
            margin-bottom: 30px;
        }

        @media (max-width: 768px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }
        }

        .chart-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
        }

        .chart-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .chart-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .chart-period {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }

        /* Data Tables */
        .tables-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 24px;
            margin-bottom: 30px;
        }

        @media (max-width: 768px) {
            .tables-section {
                grid-template-columns: 1fr;
            }
        }

        .table-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
        }

        .table-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-title i {
            color: var(--primary);
        }

        .table-responsive {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th {
            background: var(--content-bg);
            padding: 12px 16px;
            text-align: left;
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 2px solid var(--border-color);
            white-space: nowrap;
        }

        .data-table td {
            padding: 12px 16px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .data-table tr:hover {
            background: rgba(67, 97, 238, 0.05);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-draft { background: rgba(148, 163, 184, 0.1); color: var(--text-secondary); }
        .status-pending { background: rgba(245, 158, 11, 0.1); color: var(--warning); }
        .status-approved { background: rgba(16, 185, 129, 0.1); color: var(--success); }
        .status-rejected { background: rgba(239, 68, 68, 0.1); color: var(--danger); }

        /* Insights Section */
        .insights-section {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
            border-left: 4px solid var(--primary);
        }

        .insights-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
        }

        .insights-icon {
            width: 60px;
            height: 60px;
            background: white;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: var(--primary);
            box-shadow: var(--shadow-md);
        }

        .insights-title h3 {
            color: var(--text-primary);
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .insights-title p {
            color: var(--text-secondary);
        }

        .insights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .insight-item {
            background: white;
            padding: 20px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }

        .insight-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }

        .insight-header i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .insight-text {
            color: var(--text-primary);
            line-height: 1.6;
        }

        .insight-metric {
            font-weight: 700;
            color: var(--primary);
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

            .filters-grid {
                grid-template-columns: 1fr;
            }

            .kpi-grid {
                grid-template-columns: repeat(2, 1fr);
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

            .kpi-grid {
                grid-template-columns: 1fr;
            }

            .filter-actions {
                flex-direction: column;
            }

            .filter-actions .btn {
                width: 100%;
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

        .kpi-card,
        .chart-card,
        .table-card,
        .insight-item {
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
                    <a href="ReportPage.aspx" class="nav-link active">
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
                    <h1>Reports & Analytics</h1>
                    <p>Comprehensive insights from hardware agreements data</p>
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

            <!-- Filters Section -->
            <div class="filters-section">
                <div class="filters-header">
                    <i class="fas fa-filter"></i>
                    <h3>Report Filters</h3>
                </div>

                <div class="filters-grid">
                    <div class="filter-group">
                        <label class="filter-label">Date Range</label>
                        <div style="display: flex; gap: 12px;">
                            <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="filter-control"></asp:TextBox>
                            <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="filter-control"></asp:TextBox>
                        </div>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label">Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">All Status</asp:ListItem>
                            <asp:ListItem Value="Draft">Draft</asp:ListItem>
                            <asp:ListItem Value="Pending">Pending</asp:ListItem>
                            <asp:ListItem Value="Approved">Approved</asp:ListItem>
                            <asp:ListItem Value="Rejected">Rejected</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label">Hardware Type</label>
                        <asp:DropDownList ID="ddlHardwareType" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">All Types</asp:ListItem>
                            <asp:ListItem Value="Laptop">Laptop</asp:ListItem>
                            <asp:ListItem Value="Desktop">Desktop</asp:ListItem>
                            <asp:ListItem Value="Tablet">Tablet</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label">IT Staff</label>
                        <asp:DropDownList ID="ddlITStaff" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="">All IT Staff</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="filter-actions">
                    <asp:Button ID="btnApplyFilters" runat="server" Text="Apply Filters" 
                        CssClass="btn btn-primary" OnClick="btnApplyFilters_Click" />
                    <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters" 
                        CssClass="btn btn-secondary" OnClick="btnClearFilters_Click" />
                    <asp:Button ID="btnExport" runat="server" Text="Export to Excel" 
                        CssClass="btn btn-export" OnClick="btnExport_Click" />
                </div>
            </div>

            <!-- KPI Cards -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-header">
                        <div class="kpi-icon total">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <div class="kpi-trend trend-up">+12%</div>
                    </div>
                    <div class="kpi-title">Total Agreements</div>
                    <div class="kpi-value">
                        <asp:Literal ID="litTotalAgreements" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="kpi-subtitle">All time agreements created</div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <div class="kpi-icon active">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="kpi-trend trend-neutral">0%</div>
                    </div>
                    <div class="kpi-title">Active Agreements</div>
                    <div class="kpi-value">
                        <asp:Literal ID="litActiveAgreements" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="kpi-subtitle">Currently active agreements</div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <div class="kpi-icon pending">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="kpi-trend trend-up">+5%</div>
                    </div>
                    <div class="kpi-title">Pending</div>
                    <div class="kpi-value">
                        <asp:Literal ID="litPendingAgreements" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="kpi-subtitle">Awaiting approval</div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <div class="kpi-icon laptops">
                            <i class="fas fa-laptop"></i>
                        </div>
                        <div class="kpi-trend trend-up">+8%</div>
                    </div>
                    <div class="kpi-title">Laptops</div>
                    <div class="kpi-value">
                        <asp:Literal ID="litLaptopCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="kpi-subtitle">Laptop agreements</div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-grid">
                <div class="chart-card">
                    <div class="chart-header">
                        <div class="chart-title">Agreements by Status</div>
                        <div class="chart-period">Last 30 days</div>
                    </div>
                    <div class="chart-container">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-header">
                        <div class="chart-title">Agreements by Hardware Type</div>
                        <div class="chart-period">All time</div>
                    </div>
                    <div class="chart-container">
                        <canvas id="typeChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-header">
                        <div class="chart-title">Monthly Trend</div>
                        <div class="chart-period">Last 6 months</div>
                    </div>
                    <div class="chart-container">
                        <canvas id="trendChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-header">
                        <div class="chart-title">IT Staff Performance</div>
                        <div class="chart-period">Top 5 IT Staff</div>
                    </div>
                    <div class="chart-container">
                        <canvas id="staffChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Data Tables Section -->
            <div class="tables-section">
                <div class="table-card">
                    <div class="table-title">
                        <i class="fas fa-list"></i>
                        Recent Agreements
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvRecentAgreements" runat="server" AutoGenerateColumns="false" 
                            CssClass="data-table" AllowPaging="true" PageSize="5" 
                            OnPageIndexChanging="gvRecentAgreements_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="agreement_number" HeaderText="Agreement No" />
                                <asp:BoundField DataField="employee_name" HeaderText="Employee" />
                                <asp:BoundField DataField="model" HeaderText="Hardware Model" />
                                <asp:BoundField DataField="issue_date" HeaderText="Issue Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='status-badge <%# "status-" + Eval("agreement_status").ToString().ToLower() %>'>
                                            <%# Eval("agreement_status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div style="text-align: center; padding: 20px; color: var(--text-secondary);">
                                    No agreements found
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>

                <div class="table-card">
                    <div class="table-title">
                        <i class="fas fa-chart-pie"></i>
                        Accessories Summary
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvAccessories" runat="server" AutoGenerateColumns="false" 
                            CssClass="data-table">
                            <Columns>
                                <asp:BoundField DataField="item" HeaderText="Accessory Item" />
                                <asp:BoundField DataField="count" HeaderText="Count" />
                                <asp:BoundField DataField="percentage" HeaderText="Percentage" DataFormatString="{0}%" />
                                <asp:TemplateField HeaderText="Trend">
                                    <ItemTemplate>
                                        <span style="color: <%# Convert.ToInt32(Eval("trend")) > 0 ? "var(--success)" : "var(--danger)" %>">
                                            <i class="fas fa-arrow-<%# Convert.ToInt32(Eval("trend")) > 0 ? "up" : "down" %>"></i>
                                            <%# Math.Abs(Convert.ToInt32(Eval("trend"))) %>%
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- Insights Section -->
            <div class="insights-section">
                <div class="insights-header">
                    <div class="insights-icon">
                        <i class="fas fa-lightbulb"></i>
                    </div>
                    <div class="insights-title">
                        <h3>Key Insights</h3>
                        <p>Actionable intelligence from your data</p>
                    </div>
                </div>

                <div class="insights-grid">
                    <div class="insight-item">
                        <div class="insight-header">
                            <i class="fas fa-chart-line"></i>
                            <h4>Peak Activity</h4>
                        </div>
                        <p class="insight-text">
                            Most agreements are created on <span class="insight-metric">Fridays</span> 
                            between <span class="insight-metric">2-4 PM</span>.
                        </p>
                    </div>

                    <div class="insight-item">
                        <div class="insight-header">
                            <i class="fas fa-laptop"></i>
                            <h4>Popular Hardware</h4>
                        </div>
                        <p class="insight-text">
                            <span class="insight-metric">Laptops</span> account for 
                            <span class="insight-metric">
                                <asp:Literal ID="litLaptopPercentage" runat="server" Text="0"></asp:Literal>%
                            </span> of all hardware agreements.
                        </p>
                    </div>

                    <div class="insight-item">
                        <div class="insight-header">
                            <i class="fas fa-user-tie"></i>
                            <h4>Top IT Staff</h4>
                        </div>
                        <p class="insight-text">
                            <span class="insight-metric">
                                <asp:Literal ID="litTopITStaff" runat="server" Text="N/A"></asp:Literal>
                            </span> has processed the most agreements this month.
                        </p>
                    </div>

                    <div class="insight-item">
                        <div class="insight-header">
                            <i class="fas fa-clock"></i>
                            <h4>Processing Time</h4>
                        </div>
                        <p class="insight-text">
                            Average processing time is <span class="insight-metric">
                                <asp:Literal ID="litAvgProcessingTime" runat="server" Text="0"></asp:Literal> days
                            </span> from creation to completion.
                        </p>
                    </div>
                </div>
            </div>

            <div class="footer">
                <p>Reports & Analytics &copy; <%= DateTime.Now.Year %> | Generated on: <%= DateTime.Now.ToString("MMMM dd, yyyy HH:mm:ss") %></p>
                <p style="margin-top: 8px; font-size: 0.8rem; color: #94a3b8;">
                    Data Source: Hardware Agreements Database | Last updated: Today
                </p>
            </div>
        </main>
    </form>

<script>
    // Initialize Charts with static data (will be replaced with real data)
    document.addEventListener('DOMContentLoaded', function () {
        // Chart 1: Agreements by Status
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        const statusChart = new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Pending', 'Draft', 'Approved', 'Rejected'],
                datasets: [{
                    data: [8, 2, 0, 0], // Static data for now
                    backgroundColor: [
                        'rgba(245, 158, 11, 0.8)',
                        'rgba(148, 163, 184, 0.8)',
                        'rgba(16, 185, 129, 0.8)',
                        'rgba(239, 68, 68, 0.8)'
                    ],
                    borderColor: [
                        'rgba(245, 158, 11, 1)',
                        'rgba(148, 163, 184, 1)',
                        'rgba(16, 185, 129, 1)',
                        'rgba(239, 68, 68, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    }
                }
            }
        });

        // Chart 2: Agreements by Hardware Type
        const typeCtx = document.getElementById('typeChart').getContext('2d');
        const typeChart = new Chart(typeCtx, {
            type: 'bar',
            data: {
                labels: ['Laptop', 'Desktop', 'Tablet', 'Other'],
                datasets: [{
                    label: 'Number of Agreements',
                    data: [7, 2, 1, 1], // Static data for now
                    backgroundColor: [
                        'rgba(239, 68, 68, 0.7)',
                        'rgba(114, 9, 183, 0.7)',
                        'rgba(16, 185, 129, 0.7)',
                        'rgba(139, 92, 246, 0.7)'
                    ],
                    borderColor: [
                        'rgba(239, 68, 68, 1)',
                        'rgba(114, 9, 183, 1)',
                        'rgba(16, 185, 129, 1)',
                        'rgba(139, 92, 246, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });

        // Chart 3: Monthly Trend
        const trendCtx = document.getElementById('trendChart').getContext('2d');
        const trendChart = new Chart(trendCtx, {
            type: 'line',
            data: {
                labels: ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'], // Static labels
                datasets: [{
                    label: 'Agreements Created',
                    data: [2, 3, 1, 4, 6, 8], // Static data for now
                    borderColor: 'rgba(67, 97, 238, 1)',
                    backgroundColor: 'rgba(67, 97, 238, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Chart 4: IT Staff Performance
        const staffCtx = document.getElementById('staffChart').getContext('2d');
        const staffChart = new Chart(staffCtx, {
            type: 'horizontalBar',
            data: {
                labels: ['PANCENTURY\\Qayyim', 'Staff2', 'Staff3', 'Staff4', 'Staff5'], // Static labels
                datasets: [{
                    label: 'Agreements Processed',
                    data: [10, 8, 6, 4, 2], // Static data for now
                    backgroundColor: 'rgba(16, 185, 129, 0.7)',
                    borderColor: 'rgba(16, 185, 129, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                indexAxis: 'y',
                scales: {
                    x: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Add active class to current page
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

    // Export data function
    function exportToExcel() {
        // This would typically be handled server-side
        alert('Export feature would generate an Excel file with filtered data.');
    }
</script>
</body>
</html>