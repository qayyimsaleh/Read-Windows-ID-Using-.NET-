<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WindowsAuthDemo.Default" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Windows User Info</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            padding: 30px;
            width: 100%;
            max-width: 700px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header {
            text-align: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eaeaea;
        }

        .header h2 {
            color: #333;
            font-size: 1.8rem;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .header p {
            color: #666;
            font-size: 1rem;
            line-height: 1.5;
        }

        .user-info-card {
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            border-radius: 12px;
            padding: 25px;
            margin: 20px 0;
            border-left: 4px solid #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
        }

        .user-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .user-icon {
            font-size: 2.2rem;
            color: #667eea;
            background: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .user-title {
            margin-left: 15px;
        }

        .user-title h3 {
            color: #333;
            font-size: 1.3rem;
            margin-bottom: 4px;
        }

        .user-title p {
            color: #666;
            font-size: 0.9rem;
        }

        .user-details {
            margin-top: 15px;
        }

        .user-label {
            font-size: 0.95rem;
            color: #666;
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }

        .user-value {
            font-size: 1.3rem;
            color: #222;
            font-weight: 600;
            word-break: break-word;
            padding: 14px 18px;
            background: white;
            border-radius: 10px;
            border: 2px solid #eaeaea;
            line-height: 1.4;
            min-height: 60px;
            display: flex;
            align-items: center;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            margin: 30px 0;
        }

        .info-item {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.06);
            text-align: center;
            transition: all 0.2s ease;
            border: 1px solid #f0f0f0;
            margin: 0 8px;
        }

        .info-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 12px rgba(0, 0, 0, 0.1);
            border-color: #e0e0e0;
        }

        .info-icon {
            font-size: 1.6rem;
            color: #764ba2;
            margin-bottom: 12px;
            height: 50px;
            width: 50px;
            background: #f8f4ff;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .info-title {
            font-size: 0.85rem;
            color: #888;
            font-weight: 500;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-value {
            font-size: 1.1rem;
            color: #333;
            font-weight: 600;
            line-height: 1.3;
        }

        .timestamp {
            text-align: center;
            color: #777;
            font-size: 0.85rem;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .footer {
            text-align: center;
            margin-top: 25px;
            color: #666;
            font-size: 0.85rem;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        /* Role styles */
        .role-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 10px;
        }
        
        .role-admin {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .role-normal {
            background-color: #e2e3e5;
            color: #383d41;
            border: 1px solid #d6d8db;
        }
        
        .role-new {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .role-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .status-indicator {
            font-size: 1rem;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 20px;
            display: inline-block;
            margin-top: 10px;
        }
        
        .status-admin {
            background-color: #007bff;
            color: white;
        }
        
        .status-normal {
            background-color: #6c757d;
            color: white;
        }
        
        .admin-panel {
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f0ff 100%);
            border-radius: 12px;
            padding: 25px;
            margin: 25px 0;
            border-left: 4px solid #007bff;
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.15);
        }
        
        .admin-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .admin-icon {
            font-size: 2rem;
            color: #007bff;
            background: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .admin-title {
            margin-left: 15px;
        }
        
        .admin-title h3 {
            color: #007bff;
            font-size: 1.4rem;
            margin-bottom: 4px;
        }
        
        .admin-controls {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            margin-top: 20px;
        }
        
        .admin-control {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            margin: 8px;
        }
        
        .admin-control:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            border-color: #007bff;
        }
        
        .control-icon {
            font-size: 1.8rem;
            color: #007bff;
            margin-bottom: 10px;
        }
        
        .control-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .control-desc {
            font-size: 0.85rem;
            color: #666;
        }
        
        .first-access-notice {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
            color: #856404;
        }
        
        .error-notice {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
            color: #721c24;
        }

        @media (max-width: 768px) {
            .container {
                padding: 22px;
                margin: 10px;
                border-radius: 14px;
            }
            
            .header h2 {
                font-size: 1.6rem;
            }
            
            .user-value {
                font-size: 1.15rem;
                padding: 12px 15px;
                min-height: 55px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .user-header {
                flex-direction: column;
                text-align: center;
            }
            
            .user-icon {
                width: 55px;
                height: 55px;
                font-size: 2rem;
                margin-bottom: 10px;
            }
            
            .user-title {
                margin-left: 0;
            }
            
            .admin-controls {
                grid-template-columns: 1fr;
            }
            
            .role-badge {
                display: block;
                margin-left: 0;
                margin-top: 5px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .container {
                padding: 18px;
                border-radius: 12px;
            }
            
            .header h2 {
                font-size: 1.4rem;
            }
            
            .user-value {
                font-size: 1.05rem;
                padding: 10px 12px;
                min-height: 50px;
            }
            
            .info-item {
                padding: 18px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h2>
                    <i class="fas fa-user-shield"></i>
                    Windows Authentication
                </h2>
                <p>Your Windows identity information</p>
            </div>

            <div class="user-info-card">
                <div class="user-header">
                    <div class="user-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="user-title">
                        <h3>Authenticated User 
                            <asp:Label ID="lblUserRole" runat="server" CssClass="role-badge"></asp:Label>
                        </h3>
                        <p>Windows domain credentials</p>
                        <asp:Label ID="lblStatus" runat="server" CssClass="status-indicator"></asp:Label>
                    </div>
                </div>
                <div class="user-details">
                    <span class="user-label">Currently logged in as:</span>
                    <asp:Label ID="lblUser" runat="server" CssClass="user-value"></asp:Label>
                </div>
                
                <!-- Messages -->
                <asp:Label ID="lblFirstAccess" runat="server" CssClass="first-access-notice" Visible="false">
                    <i class="fas fa-info-circle"></i> First time access detected. You have been registered as a normal user.
                </asp:Label>
                
                <asp:Label ID="lblError" runat="server" CssClass="error-notice" Visible="false"></asp:Label>
            </div>

            <!-- Normal User Content -->
            <div id="normalUserContent" runat="server">
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-lock"></i>
                        </div>
                        <div class="info-title">Authentication Type</div>
                        <div id="infoAuthType" class="info-value" runat="server">Windows Integrated</div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="info-title">Status</div>
                        <div class="info-value">Authenticated</div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="info-title">Session</div>
                        <div class="info-value">Active</div>
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
                        <h3>Administrator Control Panel</h3>
                        <p>Privileged access management</p>
                    </div>
                </div>
                
                <div class="admin-controls">
                    <a href="Agreement.aspx" class="admin-control" style="text-decoration: none; color: inherit;">
                        <div class="control-icon">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <div class="control-title">CREATE NEW AGREEMENT</div>
                        <div class="control-desc">Employee's laptop/desktop agreement</div>
                    </a>
    
                    <a href="ExistingAgreements.aspx" class="admin-control" style="text-decoration: none; color: inherit;">
                        <div class="control-icon">
                            <i class="fas fa-list-alt"></i>
                        </div>
                        <div class="control-title">EXISTING AGREEMENTS</div>
                        <div class="control-desc">View and manage all agreements</div>
                    </a>
                </div>

            <div class="timestamp">
                <i class="far fa-clock"></i> 
                Retrieved: <%= DateTime.Now.ToString("MMMM dd, yyyy HH:mm:ss") %>
            </div>

            <div class="footer">
                <p>Windows Authentication Demo &copy; <%= DateTime.Now.Year %></p>
            </div>
        </div>
    </form>
</body>
</html>