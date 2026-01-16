﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WindowsAuthDemo.Default" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Hardware Agreement Portal</title>
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

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
            margin-bottom: 30px;
        }

        .dashboard-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .card-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .role-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .role-admin {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .role-normal {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .role-new {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }

        .role-error {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .user-details {
            margin: 20px 0;
        }

        .detail-item {
            margin-bottom: 16px;
        }

        .detail-label {
            font-size: 0.85rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
            font-weight: 600;
        }

        .detail-value {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            background: var(--content-bg);
            padding: 14px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid var(--border-color);
        }

        .stat-icon {
            font-size: 1.8rem;
            color: var(--primary);
            margin-bottom: 12px;
        }

        .stat-title {
            font-size: 0.85rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* Admin Panel */
        .admin-panel {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            border-radius: 16px;
            padding: 30px;
            margin: 30px 0;
            border-left: 4px solid var(--primary);
        }

        .admin-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
        }

        .admin-icon {
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

        .admin-title h3 {
            color: var(--text-primary);
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .admin-title p {
            color: var(--text-secondary);
        }

        .admin-controls {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }

        .admin-control {
            background: white;
            padding: 24px;
            border-radius: 12px;
            text-decoration: none;
            color: inherit;
            display: block;
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .admin-control:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }

        .control-icon {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 16px;
        }

        .control-title {
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
            font-size: 1.1rem;
        }

        .control-desc {
            font-size: 0.9rem;
            color: var(--text-secondary);
            line-height: 1.5;
        }

        /* Notices */
        .first-access-notice {
            background: linear-gradient(135deg, #fffbeb, #fef3c7);
            border: 1px solid #fde68a;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
            color: #92400e;
        }

        .error-notice {
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            border: 1px solid #fecaca;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
            color: #991b1b;
        }

        .notice-icon {
            margin-right: 10px;
            font-size: 1.2rem;
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

            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .admin-controls {
                grid-template-columns: 1fr;
            }

            .stats-grid {
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

            .stats-grid {
                grid-template-columns: 1fr;
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

        .dashboard-card,
        .admin-control,
        .stat-card {
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
                    <a href="#" class="nav-link active">
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
                    <h1>Welcome to Hardware Agreement Portal</h1>
                    <p>Manage your hardware agreements and user permissions</p>
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

            <!-- User Info Card -->
            <div class="dashboard-grid">
                <div class="dashboard-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <asp:Label ID="lblUserRole" runat="server" CssClass="role-badge"></asp:Label>
                    </div>
                    
                    <h3 style="margin-bottom: 20px; color: var(--text-primary);">User Information</h3>
                    
                    <div class="user-details">
                        <div class="detail-item">
                            <div class="detail-label">Windows Identity</div>
                            <div class="detail-value">
                                <i class="fas fa-user" style="margin-right: 10px; color: var(--primary);"></i>
                                <asp:Label ID="lblUserName" runat="server"></asp:Label>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Authentication Type</div>
                            <div class="detail-value">
                                <i class="fas fa-lock" style="margin-right: 10px; color: var(--primary);"></i>
                                <div id="infoAuthType" runat="server">Windows Integrated</div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Session Status</div>
                            <div class="detail-value" style="color: var(--success);">
                                <i class="fas fa-check-circle" style="margin-right: 10px;"></i>
                                Active Session
                            </div>
                        </div>
                    </div>

                    <!-- Messages -->
                    <asp:Label ID="lblFirstAccess" runat="server" CssClass="first-access-notice" Visible="false">
                        <i class="fas fa-info-circle notice-icon"></i>
                        First time access detected. You have been registered as a normal user.
                    </asp:Label>
                    
                    <asp:Label ID="lblError" runat="server" CssClass="error-notice" Visible="false">
                        <i class="fas fa-exclamation-triangle notice-icon"></i>
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </asp:Label>
                </div>

                <!-- In the Stats Panel section, replace the.c hardcoded values with ASP.NET Labels -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-title">Total Users</div>
                        <div class="stat-value">
                            <asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label>
                        </div>
                    </div>
    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <div class="stat-title">Agreements</div>
                        <div class="stat-value">
                            <asp:Label ID="lblTotalAgreements" runat="server" Text="0"></asp:Label>
                        </div>
                    </div>
    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-laptop"></i>
                        </div>
                        <div class="stat-title">Devices</div>
                        <div class="stat-value">
                            <asp:Label ID="lblTotalDevices" runat="server" Text="0"></asp:Label>
                        </div>
                    </div>
    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-title">Active</div>
                        <div class="stat-value">
                            <asp:Label ID="lblActiveAgreements" runat="server" Text="0"></asp:Label>
                        </div>
                    </div>
                </div>

            <!-- Admin Panel -->
            <div id="adminPanel" runat="server" class="admin-panel" visible="false">
                <div class="admin-header">
                    <div class="admin-icon">
                        <i class="fas fa-user-cog"></i>
                    </div>
                    <div class="admin-title">
                        <h3>Administrator Controls</h3>
                        <p>Manage system settings and agreements</p>
                    </div>
                </div>
                
                <div class="admin-controls">
                    <a href="Agreement.aspx" class="admin-control">
                        <div class="control-icon">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <div class="control-title">Create New Agreement</div>
                        <div class="control-desc">Generate new hardware agreements for employees</div>
                    </a>

                    <a href="ExistingAgreements.aspx" class="admin-control">
                        <div class="control-icon">
                            <i class="fas fa-list-alt"></i>
                        </div>
                        <div class="control-title">View Existing Agreements</div>
                        <div class="control-desc">Manage and review all hardware agreements</div>
                    </a>

                    <a href="UserManagement.aspx" class="admin-control">
                        <div class="control-icon">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <div class="control-title">User Management</div>
                        <div class="control-desc">Add, remove, or modify user permissions</div>
                    </a>

                    <a href="#" class="admin-control">
                        <div class="control-icon">
                            <i class="fas fa-chart-pie"></i>
                        </div>
                        <div class="control-title">Analytics Dashboard</div>
                        <div class="control-desc">View system usage and agreement statistics</div>
                    </a>
                </div>
            </div>

            <!-- Normal User Content -->
            <div id="normalUserContent" runat="server">
                <div class="dashboard-card">
                    <div class="card-header">
                        <div class="card-icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <div style="font-size: 0.9rem; color: var(--text-secondary);">Quick Actions</div>
                    </div>
                    
                    <h3 style="margin-bottom: 20px; color: var(--text-primary);">Available Actions</h3>
                    
                    <div class="admin-controls">
                        <a href="#" class="admin-control">
                            <div class="control-icon">
                                <i class="fas fa-question-circle"></i>
                            </div>
                            <div class="control-title">View Agreement</div>
                            <div class="control-desc">Check your hardware agreement status</div>
                        </a>

                        <a href="#" class="admin-control">
                            <div class="control-icon">
                                <i class="fas fa-headset"></i>
                            </div>
                            <div class="control-title">Request Support</div>
                            <div class="control-desc">Get help with hardware issues</div>
                        </a>

                        <a href="#" class="admin-control">
                            <div class="control-icon">
                                <i class="fas fa-download"></i>
                            </div>
                            <div class="control-title">Download Documents</div>
                            <div class="control-desc">Access agreement documents</div>
                        </a>

                        <a href="#" class="admin-control">
                            <div class="control-icon">
                                <i class="fas fa-history"></i>
                            </div>
                            <div class="control-title">View History</div>
                            <div class="control-desc">Check your hardware request history</div>
                        </a>
                    </div>
                </div>
            </div>

            <div class="footer">
                <p>Hardware Agreement Portal &copy; <%= DateTime.Now.Year %> | Last updated: <%= DateTime.Now.ToString("MMMM dd, yyyy HH:mm:ss") %></p>
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
                if (link.getAttribute('href') === currentPage ||
                    (currentPage === '' && link.getAttribute('href') === 'Default.aspx')) {
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