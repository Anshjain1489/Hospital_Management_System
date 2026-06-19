<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — Ansh Hospital HMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="auth-page">

    <!-- Hero -->
    <div class="auth-hero">
        <div style="text-align:center;position:relative;z-index:1;">
            <div style="font-size:4rem;margin-bottom:1rem;">🏥</div>
            <div class="auth-hero-title">Join HMS</div>
            <p class="auth-hero-subtitle">Create your admin account to start managing your hospital efficiently.</p>
            <ul class="auth-hero-features">
                <li>🔐 Secure OTP verification</li>
                <li>🛡️ BCrypt password encryption</li>
                <li>📊 Full admin dashboard access</li>
                <li>📄 Invoice & PDF generation</li>
            </ul>
        </div>
    </div>

    <!-- Form -->
    <div class="auth-form-panel">
        <div class="auth-logo">🏥 HMS</div>
        <h1 class="auth-title">Create account</h1>
        <p class="auth-sub">Fill in your details to register as an admin</p>

        <form action="RegisterServlet" method="post" id="regForm" novalidate>

            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input type="text" id="name" name="name" class="form-control"
                       placeholder="Ansh Jain" required autocomplete="name">
            </div>

            <div class="form-group">
                <label class="form-label" for="email">Email address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="admin@hospital.com" required autocomplete="email">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div style="position:relative;">
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="Min 6 characters" required minlength="6"
                           style="padding-right:3rem;">
                    <button type="button" onclick="togglePwd()"
                            style="position:absolute;right:0.75rem;top:50%;transform:translateY(-50%);
                                   background:none;border:none;cursor:pointer;font-size:1.1rem;color:var(--text-muted);">
                        👁
                    </button>
                </div>
                <div id="pwdStrength" style="height:4px;border-radius:4px;margin-top:6px;background:var(--border-color);overflow:hidden;">
                    <div id="pwdBar" style="height:100%;width:0;transition:width 0.3s,background 0.3s;border-radius:4px;"></div>
                </div>
                <small id="pwdLabel" style="color:var(--text-muted);font-size:0.75rem;"></small>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-lg mt-2" id="regBtn">
                Create Account
            </button>

            <div style="text-align:center;margin-top:1.5rem;font-size:0.875rem;color:var(--text-muted);">
                Already have an account?
                <a href="login.jsp" style="color:var(--primary);font-weight:600;">Sign in</a>
            </div>
        </form>
    </div>
</div>

<div id="toast-container"></div>

<script>
(function(){const s=localStorage.getItem('hms-dark');if(s==='true')document.body.classList.add('dark-mode');})();

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

(function(){
    const p = new URLSearchParams(window.location.search);
    const msg = p.get('msg'), type = p.get('type');
    if (msg) { showToast(decodeURIComponent(msg.replace(/\+/g,' ')), type||'info'); }
})();

function togglePwd() {
    const p = document.getElementById('password');
    p.type = p.type === 'password' ? 'text' : 'password';
}

// Password strength indicator
document.getElementById('password').addEventListener('input', function() {
    const v = this.value;
    const bar = document.getElementById('pwdBar');
    const label = document.getElementById('pwdLabel');
    let strength = 0;
    if (v.length >= 6)  strength++;
    if (v.length >= 10) strength++;
    if (/[A-Z]/.test(v))strength++;
    if (/\d/.test(v))   strength++;
    if (/[^A-Za-z0-9]/.test(v)) strength++;
    const colors = ['','#ef4444','#f59e0b','#3b82f6','#10b981','#059669'];
    const labels = ['','Weak','Fair','Good','Strong','Very Strong'];
    bar.style.width = (strength * 20) + '%';
    bar.style.background = colors[strength] || '#e2e8f0';
    label.textContent = labels[strength] || '';
    label.style.color = colors[strength] || 'var(--text-muted)';
});

document.getElementById('regForm').addEventListener('submit', function() {
    const btn = document.getElementById('regBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Creating account...';
});
</script>
</body>
</html>