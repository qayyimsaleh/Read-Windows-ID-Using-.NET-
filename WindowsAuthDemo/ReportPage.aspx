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

        /* Computer Icon Animation */
        @keyframes computerGlow {
            0%, 100% { 
                filter: drop-shadow(0 0 10px rgba(67, 97, 238, 0.3));
                transform: scale(1);
            }
            50% { 
                filter: drop-shadow(0 0 20px rgba(67, 97, 238, 0.6));
                transform: scale(1.05);
            }
        }

        /* Sidebar - Same as Default.aspx */
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
            min-height: 100vh;
            width: calc(100% - 280px)
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

        /* Dashboard Cards - Same as Default.aspx */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 32px;
            margin-bottom: 40px;
        }

        .dashboard-card {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 32px;
            box-shadow: var(--shadow-md);
            border: 2px solid var(--border-color);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .dashboard-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 8px;
            height: 100%;
            background: var(--gradient-primary);
        }

        .dashboard-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }

        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
        }

        .card-icon {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            box-shadow: 0 8px 24px rgba(67, 97, 238, 0.4);
            transition: all 0.3s ease;
        }

        .card-icon:hover {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 12px 32px rgba(67, 97, 238, 0.6);
        }

        /* Filters Section */
        .filters-section {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: var(--shadow-md);
            border: 2px solid var(--border-color);
            animation: fadeInUp 0.6s ease-out;
        }

        .filters-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 28px;
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
            font-weight: 800;
        }

        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 28px;
        }

        .filter-group {
            margin-bottom: 20px;
        }

        .filter-label {
            display: block;
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-secondary);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filter-control {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 1rem;
            color: var(--text-primary);
            background: white;
            transition: all 0.3s ease;
            font-family: 'Comic Sans MS', sans-serif;
        }

        .filter-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.2);
            transform: translateY(-2px);
        }

        .date-range-inputs {
            display: flex;
            gap: 12px;
        }

        .filter-actions {
            display: flex;
            gap: 16px;
            justify-content: flex-end;
        }

        /* KPI Grid */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 28px;
            margin-bottom: 40px;
        }

        .kpi-card {
            background: var(--card-bg);
            border-radius: 18px;
            padding: 28px;
            border: 2px solid var(--border-color);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            animation: fadeInUp 0.6s ease-out;
        }

        .kpi-card:hover {
            transform: translateY(-8px) scale(1.05);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }

        .kpi-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .kpi-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .kpi-icon.total { background: linear-gradient(135deg, var(--primary), var(--secondary)); }
        .kpi-icon.active { background: linear-gradient(135deg, var(--success), #059669); }
        .kpi-icon.pending { background: linear-gradient(135deg, var(--warning), #d97706); }
        .kpi-icon.laptops { background: linear-gradient(135deg, var(--danger), #dc2626); }

        .kpi-trend {
            font-size: 0.9rem;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
        }

        .trend-up { background: rgba(16, 185, 129, 0.15); color: var(--success); }
        .trend-down { background: rgba(239, 68, 68, 0.15); color: var(--danger); }
        .trend-neutral { background: rgba(148, 163, 184, 0.15); color: var(--text-secondary); }

        .kpi-title {
            font-size: 0.95rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            font-weight: 700;
        }

        .kpi-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 8px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .kpi-subtitle {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        /* Charts Grid */
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 32px;
            margin-bottom: 40px;
        }

        .chart-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 28px;
            box-shadow: var(--shadow-md);
            border: 2px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .chart-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .chart-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .chart-period {
            font-size: 0.9rem;
            color: var(--text-secondary);
            padding: 6px 12px;
            background: rgba(67, 97, 238, 0.1);
            border-radius: 12px;
        }

        .chart-container {
            height: 300px;
            position: relative;
        }

        /* Tables Section */
        .tables-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 32px;
            margin-bottom: 40px;
        }

        .table-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 28px;
            box-shadow: var(--shadow-md);
            border: 2px solid var(--border-color);
        }

        .table-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-title i {
            color: var(--primary);
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .data-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 18px 20px;
            text-align: left;
            font-weight: 700;
            color: white;
            font-size: 1rem;
            border-bottom: 3px solid rgba(255, 255, 255, 0.2);
        }

        .data-table td {
            padding: 18px 20px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            font-size: 0.95rem;
        }

        .data-table tr {
            transition: all 0.3s ease;
        }

        .data-table tr:hover {
            background: linear-gradient(90deg, rgba(67, 97, 238, 0.05), transparent);
            transform: translateX(5px);
        }

        /* Status Badges - Same as Default.aspx */
        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 700;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .status-badge:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .status-pending {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(245, 158, 11, 0.05));
            color: var(--warning);
            border: 2px solid rgba(245, 158, 11, 0.3);
        }

        .status-draft {
            background: linear-gradient(135deg, rgba(148, 163, 184, 0.15), rgba(148, 163, 184, 0.05));
            color: #64748b;
            border: 2px solid rgba(148, 163, 184, 0.3);
        }

        .status-approved {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(16, 185, 129, 0.05));
            color: var(--success);
            border: 2px solid rgba(16, 185, 129, 0.3);
        }

        .status-rejected {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(239, 68, 68, 0.05));
            color: var(--danger);
            border: 2px solid rgba(239, 68, 68, 0.3);
        }

        /* Insights Section */
        .insights-section {
            background: linear-gradient(135deg, rgba(240, 249, 255, 0.95), rgba(224, 242, 254, 0.95));
            border-radius: 24px;
            padding: 36px;
            margin-bottom: 40px;
            border-left: 8px solid var(--primary);
            box-shadow: var(--shadow-lg);
            backdrop-filter: blur(10px);
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

        .insights-header {
            display: flex;
            align-items: center;
            gap: 24px;
            margin-bottom: 32px;
        }

        .insights-icon {
            width: 72px;
            height: 72px;
            background: white;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: var(--primary);
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
        }

        .insights-icon:hover {
            transform: scale(1.1) rotate(10deg);
            box-shadow: var(--shadow-lg);
        }

        .insights-title h3 {
            color: var(--text-primary);
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .insights-title p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .insights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }

        .insight-item {
            background: white;
            padding: 24px;
            border-radius: 16px;
            border: 2px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .insight-item:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary);
        }

        .insight-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }

        .insight-header i {
            font-size: 1.5rem;
            color: var(--primary);
            background: rgba(67, 97, 238, 0.1);
            padding: 10px;
            border-radius: 10px;
        }

        .insight-header h4 {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .insight-text {
            color: var(--text-secondary);
            line-height: 1.6;
        }

        .insight-metric {
            font-weight: 800;
            color: var(--primary);
        }

        /* Access Denied */
        .access-denied {
            text-align: center;
            padding: 80px 40px;
            max-width: 800px;
            margin: 60px auto;
            background: var(--card-bg);
            border-radius: 30px;
            box-shadow: var(--shadow-lg);
            animation: fadeInUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
        }

        .access-denied::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background: var(--gradient-primary);
        }

        .denied-icon {
            font-size: 6rem;
            color: var(--danger);
            margin-bottom: 32px;
            animation: shake 0.8s ease-in-out infinite alternate;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0) rotate(0); }
            25% { transform: translateX(-10px) rotate(-5deg); }
            75% { transform: translateX(10px) rotate(5deg); }
        }

        .denied-title {
            font-size: 2.8rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--danger), #dc2626);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .denied-message {
            color: var(--text-secondary);
            margin-bottom: 48px;
            line-height: 1.8;
            font-size: 1.2rem;
        }

        /* Buttons - Same as Default.aspx */
        .btn {
            padding: 16px 32px;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
            overflow: hidden;
            font-family: 'Comic Sans MS', sans-serif;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(67, 97, 238, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #64748b, #475569);
            color: white;
        }

        .btn-secondary:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .btn-export {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
        }

        .btn-export:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(16, 185, 129, 0.4);
        }

        /* Footer - Same as Default.aspx */
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

        .footer p:first-child {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        /* Animations */
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

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* Responsive - Same as Default.aspx */
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
            
            .charts-grid {
                grid-template-columns: 1fr;
            }
            
            .tables-section {
                grid-template-columns: 1fr;
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
            
            .charts-grid {
                grid-template-columns: 1fr;
            }
            
            .tables-section {
                grid-template-columns: 1fr;
            }
            
            .insights-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-actions {
                flex-direction: column;
            }
            
            .filter-actions .btn {
                width: 100%;
            }
            
            .page-title h1 {
                font-size: 1.8rem;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 20px;
            }
            
            .dashboard-card,
            .filters-section,
            .kpi-card,
            .chart-card,
            .table-card,
            .insights-section {
                padding: 24px;
            }
            
            .kpi-grid {
                grid-template-columns: 1fr;
            }
            
            .charts-grid {
                grid-template-columns: 1fr;
            }
            
            .date-range-inputs {
                flex-direction: column;
            }
        }
    </style>
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
            </asp:Panel>

            <div class="footer">
                <p>Reports & Analytics &copy; <%= DateTime.Now.Year %> | Generated on: <%= DateTime.Now.ToString("MMMM dd, yyyy HH:mm:ss") %></p>
                <p style="margin-top: 8px; font-size: 0.8rem; color: rgba(255, 255, 255, 0.8);">
                    Data Source: Hardware Agreements Database | Last updated: Today
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