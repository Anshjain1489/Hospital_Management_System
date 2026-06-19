<%-- Shared Sidebar Include — used on all admin pages --%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Session guard — redirect if not logged in
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=Please+login+to+continue&type=warning");
        return;
    }
    String userName = (String) s.getAttribute("user");
    String userInitial = userName != null && !userName.isEmpty() ? String.valueOf(userName.charAt(0)).toUpperCase() : "A";
    String currentPage = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} — Ansh Hospital HMS</title>
    <meta name="description" content="Ansh Hospital Management System Admin Panel">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom Premium CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>

<!-- Mobile Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

<!-- ===== SIDEBAR ===== -->
<aside class="sidebar" id="sidebar">

    <div class="sidebar-brand">
        <div class="sidebar-brand-icon">🏥</div>
        <div>
            <div class="sidebar-brand-text">Ansh Hospital</div>
            <div class="sidebar-brand-sub">Management System</div>
        </div>
    </div>

    <p class="sidebar-section-title">Main Menu</p>

    <ul class="sidebar-nav">
        <li>
            <a href="${pageContext.request.contextPath}/DashboardServlet"
               class="<%=currentPage.contains("dashboard") ? "active" : ""%>">
                <span class="nav-icon">📊</span> Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/patients.jsp"
               class="<%=currentPage.contains("patient") ? "active" : ""%>">
                <span class="nav-icon">👨‍⚕️</span> Patients
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/doctors.jsp"
               class="<%=currentPage.contains("doctor") ? "active" : ""%>">
                <span class="nav-icon">🩺</span> Doctors
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/appointment.jsp"
               class="<%=currentPage.contains("appointment") ? "active" : ""%>">
                <span class="nav-icon">📅</span> Appointments
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/prescription.jsp"
               class="<%=currentPage.contains("prescription") ? "active" : ""%>">
                <span class="nav-icon">📝</span> Prescriptions
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/LogoutServlet"
           onclick="return confirm('Are you sure you want to logout?')">
            <span class="nav-icon">🚪</span> Logout
        </a>
    </div>
</aside>

<!-- ===== MAIN CONTENT WRAPPER ===== -->
<main class="main-content">

    <!-- Topbar -->
    <div class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()" aria-label="Toggle menu">☰</button>
        <div style="flex:1"></div>
        <button class="dark-toggle" id="darkToggle" onclick="toggleDark()" title="Toggle dark mode">🌙</button>
        <div class="topbar-user">
            <div class="topbar-user-avatar"><%=userInitial%></div>
            <%=userName%>
        </div>
    </div>
