<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTP Verification — Ansh Hospital HMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .otp-box {
            max-width: 400px;
            margin: 0 auto;
            text-align: center;
        }
        .otp-inputs {
            display: flex;
            gap: 0.75rem;
            justify-content: center;
            margin: 2rem 0;
        }
        .otp-digit {
            width: 52px; height: 60px;
            border: 2px solid var(--border-color);
            border-radius: 0.75rem;
            font-size: 1.5rem;
            font-weight: 700;
            text-align: center;
            background: var(--input-bg);
            color: var(--text-main);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: 'Outfit', sans-serif;
        }
        .otp-digit:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79,70,229,0.15);
        }
        .otp-digit.filled { border-color: var(--primary); background: var(--primary-light); }
        .shield-icon { font-size: 3.5rem; margin-bottom: 1rem; }
        .timer { font-size: 0.875rem; color: var(--text-muted); margin-top: 1rem; }
        .timer span { color: var(--danger); font-weight: 700; }
    </style>
</head>
<body style="background:var(--bg-body);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:1rem;">

<div id="toast-container"></div>

<div class="card otp-box animate-scaleIn">
    <div class="shield-icon">🔐</div>
    <h2 style="font-weight:800;color:var(--text-main);">OTP Verification</h2>
    <p style="color:var(--text-muted);font-size:0.9rem;margin-top:0.5rem;">
        Enter the 6-digit code sent to your registered email.<br>
        <small style="color:var(--warning);">📋 For testing: check the Tomcat console log</small>
    </p>

    <form action="OTPServlet" method="post" id="otpForm">
        <input type="hidden" name="action" value="verify">
        <!-- Hidden combined OTP field -->
        <input type="hidden" name="otp" id="otpCombined">

        <div class="otp-inputs">
            <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="\d">
            <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="\d">
            <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="\d">
            <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="\d">
            <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="\d">
            <input type="text" class="otp-digit" maxlength="1" inputmode="numeric" pattern="\d">
        </div>

        <button type="submit" class="btn btn-primary w-100 btn-lg" id="verifyBtn">
            Verify OTP
        </button>
    </form>

    <div class="timer">
        Code expires in <span id="countdown">05:00</span>
    </div>

    <div style="margin-top:1.5rem;font-size:0.875rem;color:var(--text-muted);">
        Wrong email? <a href="register.jsp" style="color:var(--primary);font-weight:600;">Go back</a>
    </div>
</div>

<script>
(function(){const s=localStorage.getItem('hms-dark');if(s==='true')document.body.classList.add('dark-mode');})();

function showToast(message, type) {
    const icons = { success: '✅', danger: '❌', warning: '⚠️', info: 'ℹ️' };
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = 'toast ' + (type || 'info');
    toast.innerHTML = `<span class="toast-icon">${icons[type]||'ℹ️'}</span><span class="toast-msg">${message}</span><button class="toast-close" onclick="this.parentElement.remove()">✕</button>`;
    container.appendChild(toast);
    setTimeout(() => toast.style.opacity = '0', 5000);
    setTimeout(() => toast.remove(), 5500);
}

(function(){
    const p = new URLSearchParams(window.location.search);
    const msg = p.get('msg'), type = p.get('type');
    if (msg) { showToast(decodeURIComponent(msg.replace(/\+/g,' ')), type||'info'); }
})();

// OTP Input — auto-advance, backspace, paste support
const digits = document.querySelectorAll('.otp-digit');
digits.forEach((input, i) => {
    input.addEventListener('input', (e) => {
        const v = e.target.value.replace(/\D/g,'');
        e.target.value = v.slice(-1);
        if (v && i < digits.length - 1) digits[i + 1].focus();
        e.target.classList.toggle('filled', !!e.target.value);
    });
    input.addEventListener('keydown', (e) => {
        if (e.key === 'Backspace' && !e.target.value && i > 0) {
            digits[i - 1].focus();
            digits[i - 1].value = '';
            digits[i - 1].classList.remove('filled');
        }
    });
    input.addEventListener('paste', (e) => {
        e.preventDefault();
        const pasted = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g,'');
        pasted.split('').slice(0, 6).forEach((ch, idx) => {
            if (digits[idx]) { digits[idx].value = ch; digits[idx].classList.add('filled'); }
        });
        if (digits[5]) digits[5].focus();
    });
});
digits[0].focus();

// Combine on submit
document.getElementById('otpForm').addEventListener('submit', function() {
    const code = Array.from(digits).map(d => d.value).join('');
    document.getElementById('otpCombined').value = code;
    if (code.length < 6) {
        alert('Please enter all 6 digits');
        return false;
    }
    const btn = document.getElementById('verifyBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Verifying...';
});

// Countdown timer (5 minutes)
let secs = 300;
const cd = document.getElementById('countdown');
const timer = setInterval(() => {
    secs--;
    const m = String(Math.floor(secs/60)).padStart(2,'0');
    const s = String(secs%60).padStart(2,'0');
    cd.textContent = m + ':' + s;
    if (secs <= 0) {
        clearInterval(timer);
        cd.textContent = 'Expired';
        document.getElementById('verifyBtn').disabled = true;
        showToast('OTP expired. Please register again.', 'danger');
    }
}, 1000);
</script>
</body>
</html>