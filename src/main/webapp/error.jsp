<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="false"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error — Ansh Hospital HMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { min-height:100vh;display:flex;align-items:center;justify-content:center;background:var(--bg-body); }
    </style>
</head>
<body>
<%
    String errMsg = request.getParameter("msg");
    if (errMsg == null || errMsg.isBlank()) errMsg = "Something went wrong. Please try again.";
    errMsg = errMsg.replace("+", " ");
%>
<div class="card animate-scaleIn" style="max-width:480px;text-align:center;padding:3rem 2rem;">
    <div style="font-size:4rem;margin-bottom:1rem;">⚠️</div>
    <h1 style="font-size:1.5rem;font-weight:800;color:var(--danger);margin-bottom:0.75rem;">Oops! An Error Occurred</h1>
    <p style="color:var(--text-muted);margin-bottom:2rem;"><%=errMsg%></p>
    <div style="display:flex;gap:0.75rem;justify-content:center;flex-wrap:wrap;">
        <button onclick="history.back()" class="btn btn-secondary">⬅ Go Back</button>
        <a href="DashboardServlet" class="btn btn-primary">🏠 Dashboard</a>
    </div>
</div>
<script>
(function(){const s=localStorage.getItem('hms-dark');if(s==='true')document.body.classList.add('dark-mode');})();
</script>
</body>
</html>