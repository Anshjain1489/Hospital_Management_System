<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Ansh Hospital HMS</title>
    <meta name="description" content="Secure login to Ansh Hospital Management System">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="auth-page">

    <!-- Left Hero Panel -->
    <div class="auth-hero">
        <div style="text-align:center; position:relative; z-index:1;">
            <div style="font-size:4rem; margin-bottom:1rem;">🏥</div>
            <div class="auth-hero-title">Ansh Hospital</div>
            <p class="auth-hero-subtitle">Your trusted partner in healthcare management. Secure, modern, and efficient.</p>
            <ul class="auth-hero-features">
                <li>✅ Patient & Doctor Management</li>
                <li>✅ Online Appointment Booking</li>
                <li>✅ Razorpay Payment Gateway</li>
                <li>✅ PDF Invoice Generation</li>
                <li>✅ Real-time Dashboard Analytics</li>
            </ul>
        </div>
    </div>

    <!-- Right Form Panel -->
    <div class="auth-form-panel">
        <div class="auth-logo">🏥 HMS</div>
        <h1 class="auth-title">Welcome back</h1>
        <p class="auth-sub">Sign in to access your admin dashboard</p>

        <form action="LoginServlet" method="post" id="loginForm" novalidate>

            <div class="form-group">
                <label class="form-label" for="email">Email address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="admin@hospital.com" required autocomplete="email">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div style="position:relative;">
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="••••••••" required autocomplete="current-password"
                           style="padding-right:3rem;">
                    <button type="button" onclick="togglePwd()" id="eyeBtn"
                            style="position:absolute;right:0.75rem;top:50%;transform:translateY(-50%);
                                   background:none;border:none;cursor:pointer;font-size:1.1rem;color:var(--text-muted);">
                        👁
                    </button>
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-lg mt-2" id="loginBtn">
                Sign In
            </button>

            <div style="text-align:center;margin-top:1.5rem;font-size:0.875rem;color:var(--text-muted);">
                Don't have an account?
                <a href="register.jsp" style="color:var(--primary);font-weight:600;">Create one</a>
            </div>
        </form>
    </div>
</div>

<!-- Toast container -->
<div id="toast-container"></div>

<script>
// Dark mode init
(function(){const s=localStorage.getItem('hms-dark');if(s==='true')document.body.classList.add('dark-mode');})();

// Toast system
function showToast(message, type) {
    const icons = { success: '✅', danger: '❌', warning: '⚠️', info: 'ℹ️' };
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = 'toast ' + (type || 'info');
    toast.innerHTML = `<span class="toast-icon">${icons[type]||'ℹ️'}</span><span class="toast-msg">${message}</span><button class="toast-close" onclick="this.parentElement.remove()">✕</button>`;
    container.appendChild(toast);
    setTimeout(() => toast.style.opacity = '0', 4000);
    setTimeout(() => toast.remove(), 4500);
}

// Show message from URL param
(function(){
    const p = new URLSearchParams(window.location.search);
    const msg = p.get('msg'), type = p.get('type');
    if (msg) {
        showToast(decodeURIComponent(msg.replace(/\+/g,' ')), type||'info');
        const u = new URL(window.location); u.searchParams.delete('msg'); u.searchParams.delete('type');
        window.history.replaceState({}, '', u);
    }
})();

// Toggle password visibility
function togglePwd() {
    const p = document.getElementById('password');
    p.type = p.type === 'password' ? 'text' : 'password';
}

// Button loading state
document.getElementById('loginForm').addEventListener('submit', function() {
    const btn = document.getElementById('loginBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Signing in...';
});
</script>
</body>
</html>