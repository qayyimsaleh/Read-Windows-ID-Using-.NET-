<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Agreement.aspx.cs" Inherits="WindowsAuthDemo.Agreement" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title><asp:Literal ID="litPageTitle" runat="server"></asp:Literal></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Your existing CSS remains the same */
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
            max-width: 1000px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.98);
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
        }

        .header p {
            color: #666;
            font-size: 1rem;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
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

        .form-container {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 0 0 16px 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-section {
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid #eaeaea;
        }

        .section-title {
            color: #333;
            font-size: 1.3rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
            display: flex;
            align-items: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            color: #333;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 0.95rem;
        }

        .form-control, .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #eaeaea;
            border-radius: 8px;
            font-size: 1rem;
            color: #333;
            background: white;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        /* View mode styles */
        .view-mode .form-control, 
        .view-mode .form-select,
        .view-mode .form-control.auto-fill {
            background-color: #f8f9fa;
            border-color: #dee2e6;
            color: #495057;
            cursor: not-allowed;
        }

        .view-mode .checkbox-group input[type="checkbox"],
        .view-mode .radio-group input[type="radio"] {
            display: none;
        }

        .view-mode .checkbox-group label::before {
            content: attr(data-checked);
            color: #28a745;
            font-weight: bold;
            margin-right: 5px;
        }

        .view-mode .checkbox-group input[type="checkbox"]:checked + label::before {
            content: "✓ ";
        }

        .view-mode .radio-group {
            display: block;
        }

        .view-mode .radio-option label::before {
            content: "○ ";
            color: #666;
        }

        .view-mode .radio-option input[type="radio"]:checked + label::before {
            content: "● ";
            color: #28a745;
        }

        /* Checkbox and Radio display for view mode */
        .checkbox-display, .radio-display {
            display: none;
        }

        .view-mode .checkbox-display,
        .view-mode .radio-display {
            display: inline;
            color: #495057;
            font-weight: 500;
        }

        .view-mode .checkbox-group,
        .view-mode .radio-group {
            pointer-events: none;
        }

        .accessories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            margin-top: 15px;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-right: 8px;
        }

        .radio-group {
            display: flex;
            margin-top: 10px;
        }

        .radio-option {
            display: flex;
            align-items: center;
            margin-right: 20px;
        }

        .radio-option input[type="radio"] {
            margin-right: 8px;
        }

        .auto-fill {
            background-color: #f8f9ff;
            border-color: #d0d7ff;
            color: #555;
        }

        .remarks-box {
            min-height: 120px;
            resize: vertical;
        }

        .status-group {
            display: flex;
            margin-top: 15px;
        }

        .button-group {
            display: flex;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #eaeaea;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            margin-left: 15px;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .btn-outline {
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-outline:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
        }

        .message-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .agreement-info {
            background: #f8f9ff;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }

        .info-item {
            display: flex;
            margin-bottom: 8px;
        }

        .info-label {
            font-weight: 600;
            min-width: 150px;
            color: #495057;
        }

        .info-value {
            color: #212529;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 10px;
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

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .header, .form-container {
                padding: 20px;
            }
            
            .accessories-grid {
                grid-template-columns: 1fr;
            }
            
            .status-group {
                flex-direction: column;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
                margin-left: 0;
                margin-bottom: 10px;
            }
            
            .info-item {
                flex-direction: column;
            }
            
            .info-label {
                min-width: auto;
                margin-bottom: 4px;
            }
        }

        .required::after {
            content: " *";
            color: #dc3545;
        }

        .info-text {
            font-size: 0.85rem;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }

        /* Readonly style for view mode */
        .readonly-control {
            background-color: #f8f9fa !important;
            border-color: #dee2e6 !important;
            color: #495057 !important;
            cursor: not-allowed !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <a href="ExistingAgreements.aspx" class="back-button">
                    <i class="fas fa-arrow-left"></i> Back to Agreements
                </a>
                <h1>
                    <i class="fas fa-file-contract"></i>
                    <asp:Literal ID="litHeaderTitle" runat="server"></asp:Literal>
                    <asp:Literal ID="litStatusBadge" runat="server"></asp:Literal>
                </h1>
                <p><asp:Literal ID="litHeaderDescription" runat="server"></asp:Literal></p>
            </div>

            <div class="form-container" id="formContainer" runat="server">
                <!-- Agreement Info Bar -->
                <div class="agreement-info" id="agreementInfo" runat="server" visible="false">
                    <div class="info-item">
                        <span class="info-label">Agreement Number:</span>
                        <span class="info-value" id="agreementNumberDisplay" runat="server"></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Created:</span>
                        <span class="info-value" id="createdDateDisplay" runat="server"></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Last Updated:</span>
                        <span class="info-value" id="updatedDateDisplay" runat="server"></span>
                    </div>
                </div>

                <!-- Success/Error Messages -->
                <div id="messageSuccess" runat="server" class="message message-success">
                    <i class="fas fa-check-circle"></i>
                    <span id="successText" runat="server"></span>
                </div>
                
                <div id="messageError" runat="server" class="message message-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span id="errorText" runat="server"></span>
                </div>

                <!-- Hardware Details Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-laptop"></i>
                        Laptop/PC Details
                    </h2>
                    
                    <div class="form-group">
                        <label class="form-label required">Laptop/PC Model</label>
                        <asp:DropDownList ID="ddlModel" runat="server" CssClass="form-select" required>
                            <asp:ListItem Value="">-- Select Model --</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label ID="lblModelDisplay" runat="server" CssClass="checkbox-display"></asp:Label>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label required">Laptop/PC Serial Number</label>
                        <asp:TextBox ID="txtSerialNumber" runat="server" CssClass="form-control" 
                            placeholder="Enter serial number" required></asp:TextBox>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label required">Laptop/PC Asset Number</label>
                        <asp:TextBox ID="txtAssetNumber" runat="server" CssClass="form-control" 
                            placeholder="Enter asset number" required></asp:TextBox>
                    </div>
                </div>

                <!-- Accessories Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-box-open"></i>
                        Accessories
                    </h2>
                    <p class="info-text">Select all accessories that came with the laptop/PC</p>
                    
                    <div class="accessories-grid">
                        <div class="checkbox-group">
                            <asp:CheckBox ID="chkCarryBag" runat="server" />
                            <label for="chkCarryBag">Carry Bag</label>
                            <asp:Label ID="lblCarryBagDisplay" runat="server" CssClass="checkbox-display" Text="No"></asp:Label>
                        </div>
    
                        <div class="checkbox-group">
                            <asp:CheckBox ID="chkPowerAdapter" runat="server" />
                            <label for="chkPowerAdapter">Power Adapter</label>
                            <asp:Label ID="lblPowerAdapterDisplay" runat="server" CssClass="checkbox-display" Text="No"></asp:Label>
                        </div>
    
                        <div class="form-group">
                            <div class="checkbox-group">
                                <asp:CheckBox ID="chkMouse" runat="server" />
                                <label for="chkMouse">Mouse</label>
                                <asp:Label ID="lblMouseDisplay" runat="server" CssClass="checkbox-display" Text="No"></asp:Label>
                            </div>
        
                            <div class="radio-group">
                                <div class="radio-option">
                                    <asp:RadioButton ID="rbWired" runat="server" GroupName="MouseType" />
                                    <label for="rbWired">Wired</label>
                                    <asp:Label ID="lblMouseTypeDisplay" runat="server" CssClass="radio-display"></asp:Label>
                                </div>
                                <div class="radio-option">
                                    <asp:RadioButton ID="rbWireless" runat="server" GroupName="MouseType" />
                                    <label for="rbWireless">Wireless</label>
                                    <asp:Label ID="lblWirelessDisplay" runat="server" CssClass="radio-display"></asp:Label>
                                </div>
                            </div>
                        </div>
    
                        <div class="checkbox-group">
                            <asp:CheckBox ID="chkVGAConverter" runat="server" />
                            <label for="chkVGAConverter">VGA Converter</label>
                            <asp:Label ID="lblVGAConverterDisplay" runat="server" CssClass="checkbox-display" Text="No"></asp:Label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Other Accessories</label>
                        <asp:TextBox ID="txtOtherAccessories" runat="server" CssClass="form-control" 
                            placeholder="List any other accessories..." TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                </div>

                <!-- IT Details Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-user-tie"></i>
                        IT Staff Details
                    </h2>
                    
                    <div class="form-group">
                        <label class="form-label">IT Staff</label>
                        <asp:TextBox ID="txtITStaff" runat="server" CssClass="form-control auto-fill" 
                            ReadOnly="true"></asp:TextBox>
                        <p class="info-text">Auto-filled based on your Windows ID</p>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Date Issue</label>
                        <asp:TextBox ID="txtDateIssue" runat="server" CssClass="form-control auto-fill" 
                            ReadOnly="true"></asp:TextBox>
                        <p class="info-text">Auto-filled on submission</p>
                    </div>
                </div>

                <!-- Remarks Section -->
                <div class="form-section">
                    <h2 class="section-title">
                        <i class="fas fa-sticky-note"></i>
                        Remarks
                    </h2>
                    
                    <div class="form-group">
                        <label class="form-label">Remarks</label>
                        <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control remarks-box" 
                            placeholder="Enter any remarks or notes..." TextMode="MultiLine" Rows="4"></asp:TextBox>
                    </div>
                    
                    <div class="form-group" id="statusSection" runat="server">
                        <label class="form-label required">Agreement Status</label>
                        <div class="status-group">
                            <div class="radio-option">
                                <asp:RadioButton ID="rbActive" runat="server" GroupName="AgreementStatus" Checked="true" />
                                <label for="rbActive">Active</label>
                                <asp:Label ID="lblStatusDisplay" runat="server" CssClass="radio-display"></asp:Label>
                            </div>
                            <div class="radio-option">
                                <asp:RadioButton ID="rbInactive" runat="server" GroupName="AgreementStatus" />
                                <label for="rbInactive">Inactive</label>
                                <asp:Label ID="lblInactiveDisplay" runat="server" CssClass="radio-display"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="button-group" id="actionButtons" runat="server">
                    <asp:Button ID="btnSaveDraft" runat="server" Text="Save as Draft" 
                        CssClass="btn btn-outline" OnClick="btnSaveDraft_Click" />
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Agreement" 
                        CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                    <asp:Button ID="btnEdit" runat="server" Text="Edit Agreement" 
                        CssClass="btn btn-outline" OnClick="btnEdit_Click" Visible="false" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>