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

        /* User Management Content */
        .user-management-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Section Headers */
        .section-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 32px;
            animation: fadeInUp 0.6s ease-out;
        }

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

        .section-icon {
            width: 72px;
            height: 72px;
            background: var(--gradient-primary);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.8rem;
            box-shadow: 0 8px 24px rgba(67, 97, 238, 0.4);
            transition: all 0.3s ease;
        }

        .section-icon:hover {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 12px 32px rgba(67, 97, 238, 0.6);
        }

        .section-title h2 {
            color: var(--text-primary);
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .section-title p {
            color: var(--text-secondary);
            margin-top: 8px;
            font-size: 1.1rem;
        }

        /* Form Styles */
        .form-container {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 36px;
            box-shadow: var(--shadow-lg);
            border: 2px solid var(--border-color);
            margin-bottom: 36px;
            animation: fadeInUp 0.6s ease-out 0.2s both;
            position: relative;
            overflow: hidden;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 8px;
            height: 100%;
            background: var(--gradient-primary);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 12px;
            padding-left: 8px;
            border-left: 4px solid var(--primary);
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 1.1rem;
            color: var(--text-primary);
            background: white;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-family: 'Comic Sans MS', sans-serif;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.2);
            transform: translateY(-2px);
        }

        .form-select {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 1.1rem;
            color: var(--text-primary);
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Comic Sans MS', sans-serif;
        }

        .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.2);
            transform: translateY(-2px);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-top: 12px;
        }

        .checkbox-label {
            font-size: 1.05rem;
            color: var(--text-primary);
            cursor: pointer;
            font-weight: 600;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            justify-content: flex-end;
            margin-top: 32px;
            padding-top: 32px;
            border-top: 2px solid var(--border-color);
        }

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
            background: linear-gradient(135deg, #475569, #334155);
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #059669, #047857);
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(16, 185, 129, 0.4);
        }

        /* Table Styles */
        .table-container {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 36px;
            box-shadow: var(--shadow-lg);
            border: 2px solid var(--border-color);
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out 0.3s both;
            position: relative;
        }

        .table-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background: var(--gradient-secondary);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .table-title {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--text-primary);
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .search-box {
            position: relative;
            width: 360px;
        }

        .search-input {
            width: 100%;
            padding: 16px 20px 16px 52px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 1.05rem;
            transition: all 0.3s ease;
            background: white;
            font-family: 'Comic Sans MS', sans-serif;
        }

        .search-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.2);
            transform: translateY(-2px);
        }

        .search-icon {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1.2rem;
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .users-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px 24px;
            text-align: left;
            font-weight: 700;
            color: white;
            font-size: 1.1rem;
            border-bottom: 3px solid rgba(255, 255, 255, 0.2);
            white-space: nowrap;
        }

        .users-table td {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            font-size: 1.05rem;
        }

        .users-table tr {
            transition: all 0.3s ease;
        }

        .users-table tr:hover {
            background: linear-gradient(90deg, rgba(67, 97, 238, 0.05), transparent);
            transform: translateX(5px);
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 700;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .status-badge:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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

        .role-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 700;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .role-badge:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .role-admin {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(16, 185, 129, 0.05));
            color: var(--success);
            border: 2px solid rgba(16, 185, 129, 0.3);
        }

        .role-user {
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(59, 130, 246, 0.05));
            color: var(--info);
            border: 2px solid rgba(59, 130, 246, 0.3);
        }

        .action-buttons {
            display: flex;
            gap: 12px;
        }

        .btn-sm {
            padding: 10px 20px;
            font-size: 0.95rem;
            border-radius: 10px;
            font-weight: 700;
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

        /* Messages */
        .alert {
            padding: 20px 24px;
            border-radius: 16px;
            margin-bottom: 32px;
            display: flex;
            align-items: center;
            gap: 16px;
            animation: slideInRight 0.6s cubic-bezier(0.4, 0, 0.2, 1);
            border: 2px solid;
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.95);
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

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05));
            border-color: rgba(16, 185, 129, 0.4);
            color: var(--success);
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05));
            border-color: rgba(239, 68, 68, 0.4);
            color: var(--danger);
        }

        .alert-warning {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(245, 158, 11, 0.05));
            border-color: rgba(245, 158, 11, 0.4);
            color: var(--warning);
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
                gap: 20px;
                align-items: flex-start;
                padding: 20px;
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
                gap: 20px;
                align-items: flex-start;
            }
            
            .search-box {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 20px;
            }
            
            .page-title h1 {
                font-size: 1.8rem;
            }
            
            .form-container,
            .table-container {
                padding: 24px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-sm {
                width: 100%;
                justify-content: center;
            }
        }

        /* Loading Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-container,
        .table-container {
            animation: fadeIn 0.6s ease-out;
        }

        /* Laptop Typing Animation */
        @keyframes typing {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        .text-truncate {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 300px;
        }

        /* Floating Icons Animation */
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

        /* Create floating icons */
        .floating-icon:nth-child(1) { top: 10%; left: 5%; animation-delay: 0s; }
        .floating-icon:nth-child(2) { top: 20%; right: 10%; animation-delay: 1s; }
        .floating-icon:nth-child(3) { bottom: 30%; left: 15%; animation-delay: 2s; }
        .floating-icon:nth-child(4) { bottom: 20%; right: 20%; animation-delay: 3s; }
        .floating-icon:nth-child(5) { top: 40%; left: 20%; animation-delay: 4s; }
    </style>
</head>
<body>
    <!-- Floating Icons -->
    <i class="fas fa-laptop floating-icon"></i>
    <i class="fas fa-desktop floating-icon"></i>
    <i class="fas fa-server floating-icon"></i>
    <i class="fas fa-keyboard floating-icon"></i>
    <i class="fas fa-mouse floating-icon"></i>

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
                <div style="display: flex; align-items: center; gap: 16px;">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <div class="user-name" style="font-weight: 700; font-size: 1.1rem;">
                            <asp:Label ID="lblUserRoleSidebar" runat="server"></asp:Label>
                        </div>
                        <div style="font-size: 0.95rem; color: #94a3b8;">
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
                        <div style="font-weight: 700; font-size: 1.2rem;">
                            <asp:Label ID="lblUser" runat="server"></asp:Label>
                        </div>
                        <div style="font-size: 0.95rem; color: var(--text-secondary);">
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
                                <small style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 8px; display: block; padding-left: 12px;">
                                    <i class="fas fa-info-circle"></i> Format: DOMAIN\username (e.g., COMPANY\john.doe)
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
                                <small style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 8px; display: block; padding-left: 12px;">
                                    <i class="fas fa-shield-alt"></i> Administrators can access all system features
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
                                    <div style="text-align: center; padding: 60px; color: var(--text-secondary);">
                                        <i class="fas fa-users" style="font-size: 4rem; margin-bottom: 24px; opacity: 0.3;"></i>
                                        <h3 style="font-size: 1.6rem; margin-bottom: 16px; color: var(--text-primary);">No users found</h3>
                                        <p style="font-size: 1.1rem;">Start by adding a new user using the form above.</p>
                                    </div>
                                </EmptyDataTemplate>
                                <PagerStyle CssClass="pagination" />
                            </asp:GridView>
                        </div>
                    </div>

                    <!-- Audit Logs Section -->
                    <div class="table-container" style="margin-top: 40px;">
                        <div class="table-header">
                            <h3 class="table-title">
                                <i class="fas fa-history" style="margin-right: 12px;"></i>
                                Audit Logs
                            </h3>
                            <div style="display: flex; gap: 16px; align-items: center;">
                                <div style="font-size: 0.95rem; color: var(--text-secondary);">
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
                                    <div style="text-align: center; padding: 60px; color: var(--text-secondary);">
                                        <i class="fas fa-history" style="font-size: 4rem; margin-bottom: 24px; opacity: 0.3;"></i>
                                        <h3 style="font-size: 1.6rem; margin-bottom: 16px; color: var(--text-primary);">No audit logs found</h3>
                                        <p style="font-size: 1.1rem;">Audit logs will appear here when actions are performed.</p>
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
                <p style="margin-top: 16px; font-size: 0.9rem; color: rgba(255, 255, 255, 0.8);">
                    <i class="fas fa-lock"></i> Windows Authentication | <i class="fas fa-shield-alt"></i> Secure Enterprise Portal
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
                width: 50px;
                height: 50px;
                border-radius: 12px;
                display: none;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: var(--shadow-lg);
                font-size: 1.4rem;
                transition: all 0.3s ease;
            `;

            document.body.appendChild(sidebarToggle);

            sidebarToggle.addEventListener('click', function () {
                document.querySelector('.sidebar').classList.toggle('mobile-open');
                this.style.transform = 'rotate(90deg)';
                setTimeout(() => {
                    this.style.transform = 'rotate(0)';
                }, 300);
            });

            // Responsive adjustments
            function handleResize() {
                if (window.innerWidth <= 768) {
                    sidebarToggle.style.display = 'flex';
                } else {
                    sidebarToggle.style.display = 'none';
                    document.querySelector('.sidebar').classList.remove('mobile-open');
                }
            }

            window.addEventListener('resize', handleResize);
            handleResize();

            // Add floating effect to cards on hover
            const cards = document.querySelectorAll('.form-container, .table-container, .kpi-card, .chart-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-10px)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Add typing animation to form placeholders
            const inputs = document.querySelectorAll('.form-control[placeholder]');
            inputs.forEach(input => {
                const originalPlaceholder = input.placeholder;
                let i = 0;
                
                input.addEventListener('focus', function() {
                    if (this.placeholder === originalPlaceholder) {
                        this.placeholder = '';
                        const typingInterval = setInterval(() => {
                            if (i < originalPlaceholder.length) {
                                this.placeholder += originalPlaceholder.charAt(i);
                                i++;
                            } else {
                                clearInterval(typingInterval);
                                i = 0;
                            }
                        }, 50);
                    }
                });

                input.addEventListener('blur', function() {
                    this.placeholder = originalPlaceholder;
                    i = 0;
                });
            });

            // Add ripple effect to buttons
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    const ripple = document.createElement('span');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;
                    
                    ripple.style.cssText = `
                        position: absolute;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.5);
                        transform: scale(0);
                        animation: ripple 0.6s linear;
                        width: ${size}px;
                        height: ${size}px;
                        left: ${x}px;
                        top: ${y}px;
                    `;
                    
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            });

            // Add keyframe for ripple animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    to {
                        transform: scale(4);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);

            // Add scroll animation
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animationPlayState = 'running';
                    }
                });
            }, observerOptions);

            // Observe all animated elements
            document.querySelectorAll('.form-container, .table-container, .section-header').forEach(el => {
                observer.observe(el);
            });

            // Add keyboard shortcut for search
            document.addEventListener('keydown', function(e) {
                if (e.ctrlKey && e.key === 'k') {
                    e.preventDefault();
                    const searchInput = document.querySelector('.search-input');
                    if (searchInput) {
                        searchInput.focus();
                    }
                }
            });

            // Add hover effect to table rows
            const tableRows = document.querySelectorAll('.users-table tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transition = 'all 0.3s ease';
                });
            });

            // Add loading animation to form submission
            const saveButton = document.getElementById('<%= btnSave.ClientID %>');
            if (saveButton) {
                saveButton.addEventListener('click', function() {
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
                    this.disabled = true;
                    
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.disabled = false;
                    }, 2000);
                });
            }
        });
    </script>
</body>
</html>