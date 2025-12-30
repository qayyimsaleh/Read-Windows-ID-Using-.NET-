<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExistingAgreements.aspx.cs" Inherits="WindowsAuthDemo.ExistingAgreements" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Existing Agreements</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: 16px 16px 0 0;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            padding: 25px 30px;
            border-bottom: 2px solid #eaeaea;
            margin-bottom: 0;
        }

        .header h1 {
            color: #333;
            font-size: 1.8rem;
            margin-bottom: 8px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header p {
            color: #666;
            font-size: 1rem;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 15px;
            padding: 8px 16px;
            border-radius: 8px;
            background: rgba(102, 126, 234, 0.1);
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background: rgba(102, 126, 234, 0.2);
            transform: translateX(-3px);
        }

        .content-container {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: 0 0 16px 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .filters {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
            align-items: center;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-label {
            font-weight: 500;
            color: #333;
        }

        .filter-select {
            padding: 8px 12px;
            border: 2px solid #eaeaea;
            border-radius: 6px;
            background: white;
            color: #333;
        }

        .search-box {
            flex: 1;
            max-width: 300px;
        }

        .search-input {
            width: 100%;
            padding: 8px 12px;
            border: 2px solid #eaeaea;
            border-radius: 6px;
            background: white;
            color: #333;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-draft {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-pending {
            background-color: #cce5ff;
            color: #004085;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }

        .agreements-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .agreements-table th {
            background: #f8f9ff;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #eaeaea;
        }

        .agreements-table td {
            padding: 15px;
            border-bottom: 1px solid #eaeaea;
            color: #555;
        }

        .agreements-table tr:hover {
            background-color: #f9f9ff;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-small {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
        }

        .btn-edit {
            background: #007bff;
            color: white;
        }

        .btn-edit:hover {
            background: #0056b3;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
        }

        .btn-view {
            background: #6c757d;
            color: white;
        }

        .btn-view:hover {
            background: #5a6268;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 1.1rem;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eaeaea;
        }

        .page-link {
            padding: 8px 16px;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #667eea;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .page-link:hover {
            background: #f0f0ff;
        }

        .page-link.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .header, .content-container {
                padding: 20px;
            }
            
            .filters {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-box {
                max-width: 100%;
            }
            
            .agreements-table {
                display: block;
                overflow-x: auto;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-small {
                width: 100%;
                justify-content: center;
            }
        }

        /* Status row highlighting */
        .draft-row {
            background-color: rgba(255, 243, 205, 0.3) !important;
        }

        .draft-row:hover {
            background-color: rgba(255, 243, 205, 0.5) !important;
        }

        .pending-row {
            background-color: rgba(204, 229, 255, 0.3) !important;
        }

        .pending-row:hover {
            background-color: rgba(204, 229, 255, 0.5) !important;
        }

        .active-row {
            background-color: rgba(212, 237, 218, 0.3) !important;
        }

        .active-row:hover {
            background-color: rgba(212, 237, 218, 0.5) !important;
        }

        .inactive-row {
            background-color: rgba(248, 215, 218, 0.3) !important;
        }

        .inactive-row:hover {
            background-color: rgba(248, 215, 218, 0.5) !important;
        }

        /* Action button visibility */
        .btn-edit.draft-only {
            display: inline-block;
        }

        .btn-edit.non-draft {
            display: none;
        }

        /* Status badges */
        .status-draft {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-pending {
            background-color: #cce5ff;
            color: #004085;
            border: 1px solid #b8daff;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Action buttons container */
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }
    
            .btn-small {
                width: 100%;
                justify-content: center;
            }
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
            text-align: center;
            border-top: 4px solid #667eea;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin: 10px 0;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <a href="Default.aspx" class="back-button">
                    <i class="fas fa-arrow-left"></i> Back to Admin Panel
                </a>
                <h1>
                    <i class="fas fa-file-contract"></i>
                    Existing Agreements
                </h1>
                <p>View and manage all hardware agreements</p>
            </div>

            <div class="content-container">
                <!-- Statistics -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-label">Total Agreements</div>
                        <div class="stat-value"><asp:Literal ID="litTotal" runat="server"></asp:Literal></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Drafts</div>
                        <div class="stat-value"><asp:Literal ID="litDrafts" runat="server"></asp:Literal></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Pending</div>
                        <div class="stat-value"><asp:Literal ID="litPending" runat="server"></asp:Literal></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Active</div>
                        <div class="stat-value"><asp:Literal ID="litActive" runat="server"></asp:Literal></div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="filters">
                    <div class="filter-group">
                        <span class="filter-label">Status:</span>
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                            <asp:ListItem Value="">All Status</asp:ListItem>
                            <asp:ListItem Value="Draft">Draft</asp:ListItem>
                            <asp:ListItem Value="Pending">Pending</asp:ListItem>
                            <asp:ListItem Value="Active">Active</asp:ListItem>
                            <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <div class="filter-group">
                        <span class="filter-label">Sort by:</span>
                        <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">
                            <asp:ListItem Value="created_date">Newest First</asp:ListItem>
                            <asp:ListItem Value="created_date ASC">Oldest First</asp:ListItem>
                            <asp:ListItem Value="agreement_number">Agreement Number</asp:ListItem>
                            <asp:ListItem Value="agreement_status">Status</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <div class="search-box">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" 
                            placeholder="Search by agreement number, serial, or asset..." 
                            AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                    </div>
                </div>

                <!-- Agreements Grid -->
                <asp:GridView ID="gvAgreements" runat="server" CssClass="agreements-table" 
                    AutoGenerateColumns="false" OnRowCommand="gvAgreements_RowCommand"
                    OnRowDataBound="gvAgreements_RowDataBound"
                    EmptyDataText="No agreements found.">
                    <Columns>
                        <asp:BoundField DataField="agreement_number" HeaderText="Agreement Number" />
                        <asp:BoundField DataField="model" HeaderText="Model" />
                        <asp:BoundField DataField="serial_number" HeaderText="Serial Number" />
                        <asp:BoundField DataField="asset_number" HeaderText="Asset Number" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class="status-badge status-<%# Eval("agreement_status").ToString().ToLower() %>">
                                    <%# Eval("agreement_status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="it_staff_win_id" HeaderText="IT Staff" />
                        <asp:BoundField DataField="issue_date" HeaderText="Issue Date" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <!-- Edit button - only for Draft status -->
                                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn-small btn-edit"
                                        CommandName="EditAgreement" CommandArgument='<%# Eval("id") %>'
                                        ToolTip="Edit Agreement" Visible="false">
                                        <i class="fas fa-edit"></i> Edit
                                    </asp:LinkButton>
                    
                                    <!-- View button - for all statuses -->
                                    <asp:LinkButton ID="btnView" runat="server" CssClass="btn-small btn-view"
                                        CommandName="ViewAgreement" CommandArgument='<%# Eval("id") %>'
                                        ToolTip="View Details">
                                        <i class="fas fa-eye"></i> View
                                    </asp:LinkButton>
                    
                                    <!-- Delete button - for all statuses -->
                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn-small btn-delete"
                                        CommandName="DeleteAgreement" CommandArgument='<%# Eval("id") %>'
                                        OnClientClick="return confirm('Are you sure you want to delete this agreement?');"
                                        ToolTip="Delete Agreement">
                                        <i class="fas fa-trash"></i> Delete
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <!-- No Data Message -->
                <asp:Panel ID="pnlNoData" runat="server" CssClass="no-data" Visible="false">
                    <i class="fas fa-file-contract" style="font-size: 3rem; margin-bottom: 15px; color: #ddd;"></i>
                    <p>No agreements found matching your criteria.</p>
                </asp:Panel>

                <!-- Pagination -->
                <div class="pagination">
                    <asp:Repeater ID="rptPagination" runat="server" OnItemCommand="rptPagination_ItemCommand">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkPage" runat="server" 
                                CommandName="Page" 
                                CommandArgument='<%# Eval("PageNumber") %>'
                                Text='<%# Eval("PageNumber") %>'>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </form>
</body>
</html>