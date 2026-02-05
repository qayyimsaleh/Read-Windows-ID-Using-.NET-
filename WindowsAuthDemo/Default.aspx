<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WindowsAuthDemo.Default" %>

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
            min-height: 100vh;
            width: calc(100% - 280px)
        }

        /* Header */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 36px;
            background: var(--card-bg);
            border-radius: 20px;
            padding: 24px 32px;
            box-shadow: var(--shadow-md);
            animation: slideDown 0.6s ease-out;
            width: 100%;
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

        /* Dashboard Grid - Enhanced */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 32px;
            margin-bottom: 40px;
            width: 100%;
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

        .role-badge {
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 800;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .role-badge:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }

        .role-admin {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: 2px solid rgba(16, 185, 129, 0.3);
        }

        .role-normal {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border: 2px solid rgba(59, 130, 246, 0.3);
        }

        .role-new {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            border: 2px solid rgba(245, 158, 11, 0.3);
        }

        .role-error {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            border: 2px solid rgba(239, 68, 68, 0.3);
        }

        .user-details {
            margin: 24px 0;
        }

        .detail-item {
            margin-bottom: 20px;
            animation: fadeInLeft 0.6s ease-out;
            animation-fill-mode: both;
        }

        .detail-item:nth-child(1) { animation-delay: 0.1s; }
        .detail-item:nth-child(2) { animation-delay: 0.2s; }
        .detail-item:nth-child(3) { animation-delay: 0.3s; }

        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .detail-label {
            font-size: 0.9rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            font-weight: 700;
            padding-left: 8px;
            border-left: 3px solid var(--primary);
        }

        .detail-value {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-primary);
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            padding: 18px;
            border-radius: 12px;
            border: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
        }

        .detail-value:hover {
            border-color: var(--primary);
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.1);
        }

        /* Stats Grid - Enhanced */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 28px;
            margin: 40px 0;
            width: 100%;
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

        /* Admin Panel - Enhanced */
        .admin-panel {
            background: linear-gradient(135deg, rgba(240, 249, 255, 0.95), rgba(224, 242, 254, 0.95));
            border-radius: 24px;
            padding: 36px;
            margin: 40px 0;
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

        .admin-header {
            display: flex;
            align-items: center;
            gap: 24px;
            margin-bottom: 32px;
        }

        .admin-icon {
            width: 80px;
            height: 80px;
            background: white;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            color: var(--primary);
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
        }

        .admin-icon:hover {
            transform: scale(1.1) rotate(10deg);
            box-shadow: var(--shadow-lg);
        }

        .admin-title h3 {
            color: var(--text-primary);
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .admin-title p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .admin-controls {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
        }

        .admin-control {
            background: white;
            padding: 28px;
            border-radius: 18px;
            text-decoration: none;
            color: inherit;
            display: block;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 2px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .admin-control::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(67, 97, 238, 0.1), transparent);
            transition: left 0.6s;
        }

        .admin-control:hover::before {
            left: 100%;
        }

        .admin-control:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }

        .control-icon {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .admin-control:hover .control-icon {
            transform: scale(1.2) rotate(5deg);
            color: var(--secondary);
        }

        .control-title {
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 12px;
            font-size: 1.2rem;
            transition: all 0.3s ease;
        }

        .admin-control:hover .control-title {
            color: var(--primary);
        }

        .control-desc {
            font-size: 0.95rem;
            color: var(--text-secondary);
            line-height: 1.6;
        }

        /* Normal User Content - Enhanced */
        #normalUserContent .dashboard-card {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            border: 2px solid #bfdbfe;
        }

        #normalUserContent .card-icon {
            background: linear-gradient(135deg, #8b5cf6, #7c3aed);
        }

        #normalUserContent .admin-control {
            background: white;
            border: 2px solid #e2e8f0;
        }

        #normalUserContent .admin-control:hover {
            border-color: #8b5cf6;
            box-shadow: 0 10px 25px rgba(139, 92, 246, 0.15);
        }

        /* Notices - Enhanced */
        .first-access-notice {
            background: linear-gradient(135deg, rgba(255, 251, 235, 0.95), rgba(254, 243, 199, 0.95));
            border: 2px solid #fde68a;
            border-radius: 16px;
            padding: 24px;
            margin: 24px 0;
            color: #92400e;
            backdrop-filter: blur(10px);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(251, 191, 36, 0.4); }
            50% { box-shadow: 0 0 0 10px rgba(251, 191, 36, 0); }
        }

        .error-notice {
            background: linear-gradient(135deg, rgba(254, 242, 242, 0.95), rgba(254, 226, 226, 0.95));
            border: 2px solid #fecaca;
            border-radius: 16px;
            padding: 24px;
            margin: 24px 0;
            color: #991b1b;
            backdrop-filter: blur(10px);
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        .notice-icon {
            margin-right: 12px;
            font-size: 1.4rem;
        }

        /* Footer - Enhanced */
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

        /* Create floating icons */
        .floating-icon:nth-child(1) { top: 10%; left: 5%; animation-delay: 0s; }
        .floating-icon:nth-child(2) { top: 20%; right: 10%; animation-delay: 1s; }
        .floating-icon:nth-child(3) { bottom: 30%; left: 15%; animation-delay: 2s; }
        .floating-icon:nth-child(4) { bottom: 20%; right: 20%; animation-delay: 3s; }
        .floating-icon:nth-child(5) { top: 40%; left: 20%; animation-delay: 4s; }

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
            
            .dashboard-grid {
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                width: 100%;
            }
            
            .admin-controls {
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
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
                width: 100%;
            }
            
            .dashboard-grid {
                grid-template-columns: 1fr;
                width: 100%;
            }
            
            .admin-controls {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                width: 100%;
            }
            
            .page-title h1 {
                font-size: 1.8rem;
            }
            
            .admin-title h3 {
                font-size: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 20px;
            }
            
            .dashboard-card,
            .stat-card,
            .admin-control {
                padding: 24px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
                width: 100%;
            }
            
            .card-icon {
                width: 60px;
                height: 60px;
                font-size: 1.8rem;
            }
            
            .admin-icon {
                width: 60px;
                height: 60px;
                font-size: 1.8rem;
            }
            
            .stat-value {
                font-size: 1.8rem;
            }
            
            .detail-value {
                font-size: 1.1rem;
                padding: 16px;
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
                    
                    <h3 style="margin-bottom: 20px; color: var(--text-primary); font-size: 1.4rem; font-weight: 800;">User Information</h3>
                    
                    <div class="user-details">
                        <div class="detail-item">
                            <div class="detail-label">Windows Identity</div>
                            <div class="detail-value">
                                <i class="fas fa-user" style="color: var(--primary);"></i>
                                <asp:Label ID="lblUserName" runat="server"></asp:Label>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Authentication Type</div>
                            <div class="detail-value">
                                <i class="fas fa-lock" style="color: var(--primary);"></i>
                                <div id="infoAuthType" runat="server">Windows Integrated</div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">Session Status</div>
                            <div class="detail-value" style="color: var(--success);">
                                <i class="fas fa-check-circle"></i>
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

                <!-- Stats Panel -->
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

                    <a href="ReportPage.aspx" class="admin-control">
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
                        <div class="card-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <div style="font-size: 0.9rem; color: var(--text-secondary);">Quick Actions</div>
                    </div>
                    
                    <h3 style="margin-bottom: 20px; color: var(--text-primary); font-size: 1.4rem; font-weight: 800;">Available Actions</h3>
                    
                    <div class="admin-controls">
                        <a href="ExistingAgreements.aspx" class="admin-control">
                            <div class="control-icon">
                                <i class="fas fa-file-contract"></i>
                            </div>
                            <div class="control-title">View Agreement</div>
                            <div class="control-desc">Check your hardware agreement status</div>
                        </a>

                        <a href="mailto:qayyim@ioioleo.com?subject=Hardware%20Agreement%20Support" class="admin-control">
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
                <p style="margin-top: 8px; font-size: 0.8rem; color: rgba(255, 255, 255, 0.8);">
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
            const interactiveElements = document.querySelectorAll('.dashboard-card, .stat-card, .admin-control, .nav-link');
            interactiveElements.forEach(element => {
                element.addEventListener('mouseenter', () => {
                    element.style.zIndex = '10';
                });
                element.addEventListener('mouseleave', () => {
                    element.style.zIndex = '';
                });
            });

            // Animate numbers in stats
            const statValues = document.querySelectorAll('.stat-value');
            statValues.forEach(stat => {
                const finalValue = parseInt(stat.textContent);
                if (!isNaN(finalValue) && finalValue > 0) {
                    let startValue = 0;
                    const duration = 1500;
                    const increment = finalValue / (duration / 16);
                    
                    const timer = setInterval(() => {
                        startValue += increment;
                        if (startValue >= finalValue) {
                            stat.textContent = finalValue.toLocaleString();
                            clearInterval(timer);
                        } else {
                            stat.textContent = Math.floor(startValue).toLocaleString();
                        }
                    }, 16);
                }
            });

            // Add email body function for support link
            window.setEmailBody = function(link) {
                const user = document.getElementById('<%= lblUser.ClientID %>')?.textContent || '[Your Windows ID]';
                const page = document.title || '[Current Page]';
                const body = `Hello Support Team,\n\nI need assistance with:\n\n\n\nWindows ID: ${user}\nPage: ${page}`;
                link.href = link.href.replace(/body=.*/, 'body=' + encodeURIComponent(body));
                return true;
            }
        });

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
    </script>
</body>
</html>