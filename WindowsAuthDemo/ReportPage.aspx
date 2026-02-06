<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportPage.aspx.cs" Inherits="WindowsAuthDemo.ReportPage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Reports & Analytics - Laptop/PC Agreement Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="hardware-portal-styles.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <!-- Floating Icons - Same as Default.aspx -->
    <div class="floating-icon"><i class="fas fa-laptop"></i></div>
    <div class="floating-icon"><i class="fas fa-microchip"></i></div>
    <div class="floating-icon"><i class="fas fa-keyboard"></i></div>
    <div class="floating-icon"><i class="fas fa-server"></i></div>
    <div class="floating-icon"><i class="fas fa-hdd"></i></div>

    <form id="form1" runat="server">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-laptop-code"></i>
                <h2>Laptop/PC Portal</h2>
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
                    <a href="mailto:qayyim@ioioleo.com?subject=Laptop_PC%20Agreement%20Portal%20Support&body=Hello%20Support%20Team,%0A%0AI%20need%20assistance%20with:%0A%0A%0A%0AWindows%20ID:%20[Your%20Windows%20ID]%0APage:%20[Current%20Page]" 
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
                        <div class="user-name" style="font-weight: 600; color: white;">
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
                    <p>Comprehensive insights from Laptop/PC agreements data</p>
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
                        You don't have administrator privileges to access the Reports & Analytics page.
                        Only users with administrator role can view detailed reports.
                    </p>
                    <a href="Default.aspx" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i>
                        Back to Dashboard
                    </a>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlReportManagement" runat="server" Visible="false">
                <!-- Filters Section -->
                <div class="filters-section">
                    <div class="filters-header">
                        <i class="fas fa-filter"></i>
                        <h3>Report Filters</h3>
                    </div>

                    <div class="filters-grid">
                        <div class="filter-group date-range-group">
                            <label class="filter-label">Date Range</label>
                            <div class="date-range-inputs">
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
                            <label class="filter-label">Laptop/PC Type</label>
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
                            <div class="chart-title">Agreements by Laptop/PC Type</div>
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
                                    <asp:BoundField DataField="model" HeaderText="Laptop/PC Model" />
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
                                <h4>Popular Laptop/PC</h4>
                            </div>
                            <p class="insight-text">
                                <span class="insight-metric">Laptops</span> account for 
                                <span class="insight-metric">
                                    <asp:Literal ID="litLaptopPercentage" runat="server" Text="0"></asp:Literal>%
                                </span> of all Laptop/PC agreements.
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
            </asp:Panel>

            <div class="footer">
                <p>Reports & Analytics &copy; <%= DateTime.Now.Year %> | Generated on: <%= DateTime.Now.ToString("MMMM dd, yyyy HH:mm:ss") %></p>
                <p style="margin-top: 8px; font-size: 0.8rem; color: rgba(255, 255, 255, 0.8);">
                    Data Source: Laptop/PC Agreements Database | Last updated: Today
                </p>
            </div>
        </main>
    </form>

    <script>
        // Initialize Charts with static data
        document.addEventListener('DOMContentLoaded', function () {
            // Check if admin panel is visible before initializing charts
            const adminPanel = document.getElementById('<%= pnlReportManagement.ClientID %>');

            if (adminPanel && adminPanel.style.display !== 'none') {
                initializeCharts();
            }

            // Add active class to current page
            const currentPage = window.location.pathname.split('/').pop();
            const navLinks = document.querySelectorAll('.nav-link');

            navLinks.forEach(link => {
                if (link.getAttribute('href') === currentPage) {
                    link.classList.add('active');
                }
            });

            // Mobile sidebar toggle - Same as Default.aspx
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
                transition: all 0.3s ease;
            `;

            sidebarToggle.classList.add('sidebar-toggle');
            document.body.appendChild(sidebarToggle);

            sidebarToggle.addEventListener('click', function () {
                const sidebar = document.querySelector('.sidebar');
                sidebar.classList.toggle('mobile-open');
                this.style.transform = sidebar.classList.contains('mobile-open') ? 'rotate(90deg)' : 'rotate(0)';
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
                    toggleBtn.style.transform = 'rotate(0)';
                }
            });

            // Handle responsive behavior
            function handleResize() {
                const sidebar = document.querySelector('.sidebar');
                const toggleBtn = document.querySelector('.sidebar-toggle');

                if (!toggleBtn) return;

                if (window.innerWidth <= 768) {
                    toggleBtn.style.display = 'flex';
                    sidebar.classList.remove('mobile-open');
                    toggleBtn.style.transform = 'rotate(0)';
                } else {
                    toggleBtn.style.display = 'none';
                    sidebar.classList.remove('mobile-open');
                    sidebar.style.transform = 'none';
                }
            }

            window.addEventListener('resize', handleResize);
            handleResize();

            // Add hover effects to all interactive elements - Same as Default.aspx
            const interactiveElements = document.querySelectorAll('.dashboard-card, .kpi-card, .chart-card, .table-card, .insight-item, .nav-link');
            interactiveElements.forEach(element => {
                element.addEventListener('mouseenter', () => {
                    element.style.zIndex = '10';
                });
                element.addEventListener('mouseleave', () => {
                    element.style.zIndex = '';
                });
            });

            // Animate numbers in KPI cards - Same as Default.aspx
            const kpiValues = document.querySelectorAll('.kpi-value');
            kpiValues.forEach(kpi => {
                const finalValue = parseInt(kpi.textContent);
                if (!isNaN(finalValue) && finalValue > 0) {
                    let startValue = 0;
                    const duration = 1500;
                    const increment = finalValue / (duration / 16);
                    
                    const timer = setInterval(() => {
                        startValue += increment;
                        if (startValue >= finalValue) {
                            kpi.textContent = finalValue.toLocaleString();
                            clearInterval(timer);
                        } else {
                            kpi.textContent = Math.floor(startValue).toLocaleString();
                        }
                    }, 16);
                }
            });

            // Add email body function for support link - Same as Default.aspx
            window.setEmailBody = function(link) {
                const user = document.getElementById('<%= lblUser.ClientID %>')?.textContent || '[Your Windows ID]';
                const page = document.title || '[Current Page]';
                const body = `Hello Support Team,\n\nI need assistance with:\n\n\n\nWindows ID: ${user}\nPage: ${page}`;
                link.href = link.href.replace(/body=.*/, 'body=' + encodeURIComponent(body));
                return true;
            }

            // Parallax effect for floating icons - Same as Default.aspx
            window.addEventListener('scroll', () => {
                const scrolled = window.pageYOffset;
                const floatingIcons = document.querySelectorAll('.floating-icon');
                
                floatingIcons.forEach((icon, index) => {
                    const speed = 0.5 + (index * 0.1);
                    const yPos = -(scrolled * speed);
                    icon.style.transform = `translateY(${yPos}px) rotate(${scrolled * 0.1}deg)`;
                });
            });
        });

        function initializeCharts() {
            // Chart 1: Agreements by Status
            const statusCtx = document.getElementById('statusChart');
            if (statusCtx) {
                new Chart(statusCtx.getContext('2d'), {
                    type: 'doughnut',
                    data: {
                        labels: ['Pending', 'Draft', 'Approved', 'Rejected'],
                        datasets: [{
                            data: [8, 2, 0, 0],
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
            }

            // Chart 2: Agreements by Hardware Type
            const typeCtx = document.getElementById('typeChart');
            if (typeCtx) {
                new Chart(typeCtx.getContext('2d'), {
                    type: 'bar',
                    data: {
                        labels: ['Laptop', 'Desktop', 'Tablet', 'Other'],
                        datasets: [{
                            label: 'Number of Agreements',
                            data: [7, 2, 1, 1],
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
            }

            // Chart 3: Monthly Trend
            const trendCtx = document.getElementById('trendChart');
            if (trendCtx) {
                new Chart(trendCtx.getContext('2d'), {
                    type: 'line',
                    data: {
                        labels: ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'],
                        datasets: [{
                            label: 'Agreements Created',
                            data: [2, 3, 1, 4, 6, 8],
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
            }
        }

        // Export data function
        function exportToExcel() {
            // This would typically be handled server-side
            alert('Export feature would generate an Excel file with filtered data.');
        }
    </script>
</body>
</html>