<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExistingAgreements.aspx.cs" Inherits="WindowsAuthDemo.ExistingAgreements" %>

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
            font-family: 'Comic Sans MS', 'Segoe UI', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        :root {
            --primary: #4361ee;
            --primary-dark: #3a56d4;
            --secondary: #7209b7;
            --accent: #f72585;
            --sidebar-bg: #1a1b2e;
            --sidebar-text: #e2e8f0;
            --sidebar-hover: #2d2e47;
            --content-bg: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --card-bg: rgba(255, 255, 255, 0.95);
            --text-primary: #1e293b;
            --text-secondary: #4a5568;
            --border-color: rgba(226, 232, 240, 0.8);
            --success: #10b981;
            --info: #3b82f6;
            --warning: #f59e0b;
            --danger: #ef4444;
            --shadow-sm: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 10px 20px rgba(0, 0, 0, 0.15);
            --shadow-lg: 0 20px 40px rgba(0, 0, 0, 0.2);
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-secondary: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        body {
            background: var(--content-bg);
            color: var(--text-primary);
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* Animated Background Elements */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 80%, rgba(103, 126, 234, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(118, 75, 162, 0.1) 0%, transparent 50%);
            z-index: -1;
            animation: floatBackground 20s ease-in-out infinite;
        }

        @keyframes floatBackground {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(20px, 20px); }
        }

        /* Floating Icons */
        .floating-icon {
            position: absolute;
            font-size: 2rem;
            color: rgba(67, 97, 238, 0.2);
            animation: float 8s ease-in-out infinite;
            pointer-events: none;
            z-index: -1;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(20px, -20px) rotate(120deg); }
            66% { transform: translate(-20px, 20px) rotate(240deg); }
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: var(--sidebar-bg);
            color: var(--sidebar-text);
            position: fixed;
            height: 100vh;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1000;
            box-shadow: var(--shadow-lg);
            backdrop-filter: blur(10px);
            border-right: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header {
            padding: 28px 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            gap: 16px;
            background: linear-gradient(135deg, rgba(67, 97, 238, 0.1), rgba(114, 9, 183, 0.1));
        }

        .sidebar-header i {
            font-size: 2rem;
            color: var(--primary);
            background: rgba(255, 255, 255, 0.15);
            padding: 14px;
            border-radius: 14px;
            animation: computerGlow 3s ease-in-out infinite;
            transition: all 0.3s ease;
        }

        .sidebar-header i:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: rotate(15deg);
        }

        .sidebar-header h2 {
            font-size: 1.4rem;
            font-weight: 700;
            color: white;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .nav-links {
            padding: 24px 0;
        }

        .nav-item {
            list-style: none;
            margin: 6px 16px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 16px 20px;
            color: var(--sidebar-text);
            text-decoration: none;
            border-radius: 12px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 1rem;
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transition: left 0.6s;
        }

        .nav-link:hover::before {
            left: 100%;
        }

        .nav-link:hover {
            background: var(--sidebar-hover);
            color: white;
            transform: translateX(10px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .nav-link.active {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 8px 24px rgba(67, 97, 238, 0.4);
            transform: translateX(10px);
        }

        .nav-link i {
            font-size: 1.2rem;
            width: 28px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .nav-link:hover i {
            transform: scale(1.2);
        }

        .nav-divider {
            height: 2px;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            margin: 24px 20px;
        }

        .user-info-sidebar {
            padding: 24px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            position: absolute;
            bottom: 0;
            width: 100%;
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
        }

        .user-avatar {
            width: 48px;
            height: 48px;
            background: var(--gradient-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
        }

        .user-avatar:hover {
            transform: scale(1.1) rotate(10deg);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 32px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow-y: auto;
            max-height: 100vh;
        }

        /* Header */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 36px;
            padding-bottom: 24px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
            background: var(--card-bg);
            border-radius: 20px;
            padding: 24px 32px;
            box-shadow: var(--shadow-md);
            animation: slideDown 0.6s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .page-title h1 {
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--text-primary);
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-title p {
            color: var(--text-secondary);
            margin-top: 8px;
            font-size: 1.1rem;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 16px;
            background: var(--card-bg);
            padding: 16px 24px;
            border-radius: 16px;
            box-shadow: var(--shadow-sm);
            border: 2px solid var(--border-color);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .user-profile::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(67, 97, 238, 0.1), transparent);
            transform: rotate(45deg);
            animation: shine 3s infinite;
        }

        @keyframes shine {
            0% { transform: rotate(45deg) translateX(-100%); }
            100% { transform: rotate(45deg) translateX(100%); }
        }

        .user-profile:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }

        .user-profile i {
            color: var(--primary);
            font-size: 1.8rem;
            transition: transform 0.3s ease;
        }

        .user-profile:hover i {
            transform: scale(1.2) rotate(10deg);
        }

        /* Stats Grid - Enhanced */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 28px;
            margin: 40px 0;
        }

        .stat-card {
            background: var(--card-bg);
            padding: 28px;
            border-radius: 18px;
            text-align: center;
            border: 2px solid var(--border-color);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stat-card:hover {
            transform: translateY(-8px) scale(1.05);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }

        .stat-icon {
            font-size: 2.2rem;
            color: var(--primary);
            margin-bottom: 16px;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.2) rotate(10deg);
            color: var(--secondary);
        }

        .stat-title {
            font-size: 0.95rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-primary);
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-value {
            -webkit-text-fill-color: transparent;
            background-image: linear-gradient(135deg, var(--secondary), var(--accent));
        }

        /* Filters Section */
        .filters-section {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 32px;
            margin-bottom: 36px;
            box-shadow: var(--shadow-md);
            border: 2px solid var(--border-color);
            animation: slideInRight 0.6s ease-out;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(100px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .filters-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
        }

        .filters-header i {
            font-size: 1.8rem;
            color: var(--primary);
            background: rgba(67, 97, 238, 0.1);
            padding: 12px;
            border-radius: 12px;
        }

        .filters-header h3 {
            font-size: 1.4rem;
            color: var(--text-primary);
            font-weight: 700;
        }

        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }

        .filter-group {
            margin-bottom: 0;
        }

        .filter-label {
            display: block;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 10px;
        }

        .filter-select, .search-input {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 1rem;
            color: var(--text-primary);
            background: white;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-family: 'Comic Sans MS', sans-serif;
        }

        .filter-select:focus, .search-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.2);
            transform: translateY(-2px);
        }

        /* Table Container */
        .table-container {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 36px;
            box-shadow: var(--shadow-lg);
            border: 2px solid var(--border-color);
            margin-bottom: 36px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out 0.2s both;
        }

        .table-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 8px;
            height: 100%;
            background: var(--gradient-primary);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
        }

        .table-title {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--text-primary);
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-title i {
            font-size: 1.6rem;
            color: var(--primary);
        }

        .table-controls {
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        /* Table Styles */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 28px;
        }

        .table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 18px 24px;
            text-align: left;
            font-weight: 700;
            color: white;
            font-size: 1rem;
            border-bottom: 3px solid rgba(255, 255, 255, 0.2);
            white-space: nowrap;
        }

        .table td {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            font-size: 1rem;
            background: white;
        }

        .table tr {
            transition: all 0.3s ease;
        }

        .table tr:hover {
            background: linear-gradient(90deg, rgba(67, 97, 238, 0.05), transparent);
            transform: translateX(5px);
        }

        /* Status Badges */
        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .status-draft {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(245, 158, 11, 0.05));
            color: var(--warning);
            border: 2px solid rgba(245, 158, 11, 0.3);
        }

        .status-pending {
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(59, 130, 246, 0.05));
            color: var(--info);
            border: 2px solid rgba(59, 130, 246, 0.3);
        }

        .status-active {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(16, 185, 129, 0.05));
            color: var(--success);
            border: 2px solid rgba(16, 185, 129, 0.3);
        }

        .status-inactive {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(239, 68, 68, 0.05));
            color: var(--danger);
            border: 2px solid rgba(239, 68, 68, 0.3);
        }

        .status-badge:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 10px 16px;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            border: none;
            text-decoration: none;
            position: relative;
            overflow: hidden;
        }

        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s;
        }

        .btn-action:hover::before {
            left: 100%;
        }

        .btn-edit {
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(59, 130, 246, 0.05));
            color: var(--info);
            border: 2px solid rgba(59, 130, 246, 0.3);
        }

        .btn-edit:hover {
            background: var(--info);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(59, 130, 246, 0.4);
        }

        .btn-view {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(16, 185, 129, 0.05));
            color: var(--success);
            border: 2px solid rgba(16, 185, 129, 0.3);
        }

        .btn-view:hover {
            background: var(--success);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }

        .btn-delete {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(239, 68, 68, 0.05));
            color: var(--danger);
            border: 2px solid rgba(239, 68, 68, 0.3);
        }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
        }

        /* No Data State */
        .no-data {
            text-align: center;
            padding: 60px 40px;
            color: var(--text-secondary);
        }

        .no-data-icon {
            font-size: 4rem;
            color: var(--border-color);
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .no-data h3 {
            font-size: 1.5rem;
            color: var(--text-primary);
            margin-bottom: 12px;
        }

        .no-data p {
            font-size: 1rem;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 32px;
        }

        .page-link {
            padding: 10px 18px;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            background: white;
            color: var(--text-primary);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .page-link:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
            transform: translateY(-3px);
            box-shadow: var(--shadow-sm);
        }

        .page-link.active {
            background: var(--gradient-primary);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.4);
        }

        /* Footer */
        .footer {
            text-align: center;
            margin-top: 60px;
            padding-top: 32px;
            border-top: 2px solid rgba(255, 255, 255, 0.2);
            color: white;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.1);
            padding: 32px;
            border-radius: 20px;
            backdrop-filter: blur(10px);
            animation: fadeIn 1s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .footer p:first-child {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .sidebar {
                width: 100px;
            }
            
            .sidebar-header h2,
            .nav-link span,
            .user-info-sidebar .user-name {
                display: none;
            }
            
            .main-content {
                margin-left: 100px;
            }
            
            .sidebar-header {
                justify-content: center;
                padding: 24px 0;
            }
            
            .sidebar-header i {
                margin: 0;
            }
            
            .nav-link {
                justify-content: center;
                padding: 20px;
            }
            
            .nav-link:hover,
            .nav-link.active {
                transform: translateX(0);
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                transform: translateX(-100%);
                transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            }
            
            .sidebar.mobile-open {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                padding: 24px;
            }
            
            .nav-links {
                display: flex;
                overflow-x: auto;
                padding: 16px;
            }
            
            .nav-item {
                flex-shrink: 0;
            }
            
            .top-header {
                flex-direction: column;
                gap: 24px;
                align-items: flex-start;
                padding: 20px;
            }
            
            .table-header {
                flex-direction: column;
                gap: 20px;
                align-items: flex-start;
            }
            
            .filters-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 20px;
            }
            
            .page-title h1 {
                font-size: 1.8rem;
            }
            
            .table-container,
            .filters-section {
                padding: 24px;
            }
            
            .table td, .table th {
                padding: 12px 16px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <!-- Floating Icons -->
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
            <!-- Header -->
            <header class="top-header">
                <div class="page-title">
                    <h1>Agreements Management</h1>
                    <p>View, search, and manage all hardware agreements in the system</p>
                </div>
                <div class="user-profile">
                    <i class="fas fa-user-circle"></i>
                    <div>
                        <div style="font-weight: 600;">
                            <asp:Label ID="lblUser" runat="server"></asp:Label>
                        </div>
                        <div style="font-size: 0.85rem; color: var(--text-secondary);">
                            <asp:Label ID="lblStatus" runat="server" Text="Active Session"></asp:Label>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stat-value">
                        <asp:Literal ID="litTotal" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-title">Total Agreements</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                    <div class="stat-value">
                        <asp:Literal ID="litDrafts" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-title">Drafts</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-value">
                        <asp:Literal ID="litPending" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-title">Pending</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-value">
                        <asp:Literal ID="litActive" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-title">Active</div>
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
                                <span class='status-badge status-<%# Eval("agreement_status").ToString().ToLower() %>'>
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
            <div class="footer">
                <p>Hardware Agreement Portal &copy; <%= DateTime.Now.Year %> | Last updated: <%= DateTime.Now.ToString("MMMM dd, yyyy HH:mm:ss") %></p>
                <p style="margin-top: 8px; font-size: 0.8rem; color: rgba(255, 255, 255, 0.8);">
                    Windows Authentication | Secure Enterprise Portal
                </p>
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

            // Add hover effects to all interactive elements
            const interactiveElements = document.querySelectorAll('.stat-card, .btn-action, .nav-link, .page-link');
            interactiveElements.forEach(element => {
                element.addEventListener('mouseenter', () => {
                    element.style.zIndex = '10';
                });
                element.addEventListener('mouseleave', () => {
                    element.style.zIndex = '';
                });
            });

            // Add email body function for support link
            window.setEmailBody = function(link) {
                const user = document.getElementById('<%= lblUser.ClientID %>')?.textContent || '[Your Windows ID]';
                const page = document.title || '[Current Page]';
                const body = `Hello Support Team,\n\nI need assistance with:\n\n\n\nWindows ID: ${user}\nPage: ${page}`;
                link.href = link.href.replace(/body=.*/, 'body=' + encodeURIComponent(body));
                return true;
            }

            // Parallax effect for floating icons
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
    </script>
</body>
</html>