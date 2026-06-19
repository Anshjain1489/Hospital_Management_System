<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful — Ansh Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-body);
        }
        .success-box {
            text-align: center;
            max-width: 480px;
            padding: 3rem 2rem;
        }
        .success-icon {
            font-size: 5rem;
            animation: bounceIn 0.8s cubic-bezier(0.36,0.07,0.19,0.97);
        }
        @keyframes bounceIn {
            0%  { transform: scale(0.3); opacity: 0; }
            50% { transform: scale(1.1); }
            70% { transform: scale(0.95); }
            100%{ transform: scale(1);   opacity: 1; }
        }
        .confetti-piece {
            position: fixed;
            width: 12px;
            height: 12px;
            border-radius: 2px;
            animation: confettiFall linear forwards;
            opacity: 1;
            top: -20px;
        }
    </style>
</head>
<body>

<div id="toast-container"></div>

<div class="card success-box animate-scaleIn">
    <div class="success-icon">✅</div>
    <h1 style="font-size:1.75rem;font-weight:800;color:var(--success);margin:1rem 0 0.5rem;">
        Payment Successful!
    </h1>
    <p style="color:var(--text-muted);font-size:0.95rem;margin-bottom:2rem;">
        Your payment has been processed successfully.<br>
        The appointment has been confirmed.
    </p>

    <div style="background:rgba(16,185,129,0.08);border-radius:0.75rem;padding:1rem 1.5rem;
                border:1px solid rgba(16,185,129,0.2);margin-bottom:2rem;">
        <div style="display:flex;justify-content:space-between;font-size:0.875rem;margin-bottom:0.4rem;">
            <span style="color:var(--text-muted);">Payment Reference</span>
            <span style="font-weight:600;"><%=request.getParameter("id") != null ? "#" + request.getParameter("id") : "—"%></span>
        </div>
        <div style="display:flex;justify-content:space-between;font-size:0.875rem;">
            <span style="color:var(--text-muted);">Status</span>
            <span style="color:var(--success);font-weight:700;">✅ Confirmed</span>
        </div>
    </div>

    <div style="display:flex;gap:0.75rem;flex-direction:column;">
        <a href="DashboardServlet" class="btn btn-primary btn-lg">🏠 Back to Dashboard</a>
        <a href="appointment.jsp" class="btn btn-secondary">📅 View Appointments</a>
    </div>
</div>

<script>
(function(){const s=localStorage.getItem('hms-dark');if(s==='true')document.body.classList.add('dark-mode');})();

// Confetti animation
const colors = ['#4f46e5','#10b981','#f59e0b','#ef4444','#06b6d4','#a855f7'];
function launchConfetti() {
    for (let i = 0; i < 60; i++) {
        setTimeout(() => {
            const el = document.createElement('div');
            el.className = 'confetti-piece';
            el.style.left = Math.random() * 100 + 'vw';
            el.style.background = colors[Math.floor(Math.random() * colors.length)];
            el.style.animationDuration = (2 + Math.random() * 3) + 's';
            el.style.animationDelay = Math.random() * 0.5 + 's';
            el.style.transform = 'rotate(' + Math.random() * 360 + 'deg)';
            document.body.appendChild(el);
            setTimeout(() => el.remove(), 5000);
        }, i * 30);
    }
}
launchConfetti();
</script>
</body>
</html>