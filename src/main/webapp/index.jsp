<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.dao.DoctorDAO, com.hospital.model.Doctor, java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ansh Hospital — Advanced Healthcare Management System</title>
    <meta name="description" content="Ansh Hospital — World-class healthcare with experienced doctors, advanced appointments, and seamless billing.">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        :root { --sidebar-w: 0px; }
        .main-content { margin-left: 0; }
        /* Hero */
        .hero {
            min-height: 100vh;
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 40%, #4f46e5 100%);
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(79,70,229,0.3) 0%, transparent 70%);
            top: -100px; right: -100px;
            border-radius: 50%;
        }
        .hero::after {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(99,102,241,0.2) 0%, transparent 70%);
            bottom: -50px; left: 100px;
            border-radius: 50%;
        }
        .hero-content { position: relative; z-index: 1; }
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(79,70,229,0.2);
            border: 1px solid rgba(79,70,229,0.4);
            border-radius: 100px;
            padding: 0.4rem 1rem;
            font-size: 0.85rem;
            color: #a5b4fc;
            font-weight: 600;
            margin-bottom: 1.5rem;
        }
        .hero-title {
            font-size: clamp(2.5rem, 6vw, 4rem);
            font-weight: 900;
            color: white;
            line-height: 1.1;
            margin-bottom: 1.25rem;
        }
        .hero-title span { color: #818cf8; }
        .hero-sub {
            font-size: 1.1rem;
            color: rgba(255,255,255,0.7);
            line-height: 1.8;
            max-width: 520px;
            margin-bottom: 2rem;
        }
        .hero-actions { display: flex; gap: 1rem; flex-wrap: wrap; }
        .hero-stats {
            display: flex;
            gap: 2.5rem;
            margin-top: 3rem;
            flex-wrap: wrap;
        }
        .hero-stat-num {
            font-size: 2rem;
            font-weight: 800;
            color: white;
        }
        .hero-stat-lbl {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.6);
            margin-top: 0.1rem;
        }
        .hero-visual {
            position: relative;
            z-index: 1;
            text-align: center;
        }
        /* Navbar */
        .navbar {
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 100;
            padding: 1rem 0;
            transition: background 0.3s, box-shadow 0.3s;
        }
        .navbar.scrolled {
            background: rgba(15,23,42,0.95);
            backdrop-filter: blur(12px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        /* Sections */
        .section { padding: 5rem 0; }
        .section-title { font-size: 2rem; font-weight: 800; margin-bottom: 0.5rem; }
        .section-sub { color: var(--text-muted); font-size: 1rem; margin-bottom: 3rem; }
        /* Service Cards */
        .service-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 1.25rem;
            padding: 2rem 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
        }
        .service-card:hover {
            border-color: var(--primary);
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(79,70,229,0.15);
        }
        .service-icon { font-size: 2.5rem; margin-bottom: 1rem; display: block; }
        .service-title { font-weight: 700; font-size: 1rem; margin-bottom: 0.4rem; }
        .service-desc { color: var(--text-muted); font-size: 0.875rem; }
        /* Contact */
        .contact-item { display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem; }
        .contact-icon {
            width: 44px; height: 44px;
            background: var(--primary-light);
            border-radius: 0.75rem;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem; flex-shrink: 0;
        }
        /* Footer */
        .footer {
            background: #0f172a;
            color: rgba(255,255,255,0.7);
            padding: 2rem 0;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>

<!-- Toast Container -->
<div id="toast-container"></div>

<!-- ===== NAVBAR ===== -->
<nav class="navbar" id="navbar">
    <div class="container d-flex justify-content-between align-items-center">
        <a href="index.jsp" style="font-size:1.1rem;font-weight:800;color:white;text-decoration:none;">
            🏥 Ansh Hospital
        </a>
        <div class="d-flex align-items-center gap-3">
            <a href="#about"    style="color:rgba(255,255,255,0.8);font-size:0.9rem;font-weight:500;">About</a>
            <a href="#doctors"  style="color:rgba(255,255,255,0.8);font-size:0.9rem;font-weight:500;">Doctors</a>
            <a href="#services" style="color:rgba(255,255,255,0.8);font-size:0.9rem;font-weight:500;">Services</a>
            <a href="#contact"  style="color:rgba(255,255,255,0.8);font-size:0.9rem;font-weight:500;">Contact</a>
            <a href="login.jsp" class="btn btn-primary btn-sm">Login →</a>
            <button onclick="toggleDark()" id="darkToggle"
                    style="background:rgba(255,255,255,0.1);border:1px solid rgba(255,255,255,0.2);
                           border-radius:50%;width:36px;height:36px;cursor:pointer;font-size:1rem;
                           color:white;">🌙</button>
        </div>
    </div>
</nav>

<!-- ===== HERO ===== -->
<section class="hero" id="home">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-7 hero-content">
                <div class="hero-badge">🏥 Premium Hospital Management System</div>
                <h1 class="hero-title">
                    Advanced Healthcare<br>
                    <span>You Can Trust</span>
                </h1>
                <p class="hero-sub">
                    Ansh Hospital provides world-class healthcare services with experienced doctors,
                    advanced technology, 24/7 emergency support, and a fully digital management system.
                </p>
                <div class="hero-actions">
                    <a href="login.jsp" class="btn btn-primary btn-lg">Get Started →</a>
                    <a href="#doctors" class="btn btn-lg"
                       style="background:rgba(255,255,255,0.1);border:1px solid rgba(255,255,255,0.3);color:white;">
                        Meet Our Doctors
                    </a>
                </div>
                <div class="hero-stats">
                    <div>
                        <div class="hero-stat-num">500+</div>
                        <div class="hero-stat-lbl">Happy Patients</div>
                    </div>
                    <div>
                        <div class="hero-stat-num">20+</div>
                        <div class="hero-stat-lbl">Expert Doctors</div>
                    </div>
                    <div>
                        <div class="hero-stat-num">24/7</div>
                        <div class="hero-stat-lbl">Emergency Care</div>
                    </div>
                </div>
            </div>
            <div class="col-lg-5 d-none d-lg-block hero-visual">
                <div style="font-size:10rem;filter:drop-shadow(0 20px 40px rgba(79,70,229,0.5));">🏥</div>
            </div>
        </div>
    </div>
</section>

<!-- ===== ABOUT ===== -->
<section id="about" class="section">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">About Ansh Hospital</h2>
            <p class="section-sub">Delivering excellence in healthcare since 2020</p>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="service-card">
                    <span class="service-icon">🛡️</span>
                    <div class="service-title">Trusted & Certified</div>
                    <p class="service-desc">Fully certified medical facility with ISO-compliant processes and trained staff.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="service-card">
                    <span class="service-icon">💻</span>
                    <div class="service-title">Digital-First</div>
                    <p class="service-desc">Paperless workflows — online appointments, digital billing, and PDF prescriptions.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="service-card">
                    <span class="service-icon">🚑</span>
                    <div class="service-title">24/7 Emergency</div>
                    <p class="service-desc">Round-the-clock emergency care with rapid response teams always on standby.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== DOCTORS ===== -->
<section id="doctors" class="section" style="background:var(--bg-body);">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">Meet Our Specialist Doctors</h2>
            <p class="section-sub">Experienced, compassionate, and dedicated to your health</p>
        </div>
        <div class="row g-4">
            <%
            try {
                List<Doctor> topDoctors = DoctorDAO.getFirst3();
                for (Doctor d : topDoctors) {
                    String img = (d.getImage() != null && !d.getImage().isEmpty() && !"null".equals(d.getImage()))
                        ? "images/" + d.getImage() : null;
            %>
            <div class="col-md-4">
                <div class="card doctor-card" style="padding:0;">
                    <% if (img != null) { %>
                    <img src="<%=img%>" class="doctor-card-img" alt="<%=d.getName()%>"
                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                    <div style="display:none;height:200px;background:linear-gradient(135deg,#6366f1,#a855f7);
                                align-items:center;justify-content:center;font-size:4rem;color:white;">🩺</div>
                    <% } else { %>
                    <div style="height:200px;background:linear-gradient(135deg,#6366f1,#a855f7);
                                display:flex;align-items:center;justify-content:center;font-size:4rem;color:white;">🩺</div>
                    <% } %>
                    <div class="doctor-card-body">
                        <div class="doctor-card-name"><%=d.getName()%></div>
                        <span class="doctor-card-spec"><%=d.getSpecialization()%></span>
                        <p class="doctor-card-fee">💰 ₹ <%=String.format("%.0f",d.getFees())%> / visit</p>
                        <a href="login.jsp" class="btn btn-sm btn-outline-primary mt-2 w-100">Book Appointment →</a>
                    </div>
                </div>
            </div>
            <% }
            } catch (Exception e) {
                out.println("<div class='col-12 text-center' style='color:var(--text-muted)'>Doctors coming soon!</div>");
            } %>
        </div>
    </div>
</section>

<!-- ===== SERVICES ===== -->
<section id="services" class="section">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="section-title">Our Medical Services</h2>
            <p class="section-sub">Comprehensive care across all specializations</p>
        </div>
        <div class="row g-3">
            <% String[][] services = {
                {"❤️","Cardiology","Heart disease diagnosis & treatment"},
                {"🦴","Orthopedics","Bone, joint & muscle care"},
                {"🧠","Neurology","Brain & nervous system treatment"},
                {"🧪","Pathology","Advanced lab testing & analysis"},
                {"👁️","Ophthalmology","Eye care & vision correction"},
                {"🫁","Pulmonology","Respiratory & lung health"},
                {"🦷","Dentistry","Complete dental care"},
                {"🤰","Gynecology","Women's health & maternity"},
            };
            for (String[] svc : services) { %>
            <div class="col-md-3 col-sm-6">
                <div class="service-card">
                    <span class="service-icon"><%=svc[0]%></span>
                    <div class="service-title"><%=svc[1]%></div>
                    <p class="service-desc"><%=svc[2]%></p>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- ===== CONTACT ===== -->
<section id="contact" class="section" style="background:var(--bg-body);">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h2 class="section-title">Get In Touch</h2>
                <p class="section-sub">We're here to help 24/7</p>
                <div class="contact-item">
                    <div class="contact-icon">📧</div>
                    <div>
                        <div style="font-weight:600;font-size:0.875rem;color:var(--text-muted);">Email</div>
                        <div style="font-weight:700;">anshjain1440@gmail.com</div>
                    </div>
                </div>
                <div class="contact-item">
                    <div class="contact-icon">📞</div>
                    <div>
                        <div style="font-weight:600;font-size:0.875rem;color:var(--text-muted);">Phone</div>
                        <div style="font-weight:700;">+91 9264974887</div>
                    </div>
                </div>
                <div class="contact-item">
                    <div class="contact-icon">📍</div>
                    <div>
                        <div style="font-weight:600;font-size:0.875rem;color:var(--text-muted);">Address</div>
                        <div style="font-weight:700;">Gursarai, Jhansi, Uttar Pradesh, India</div>
                    </div>
                </div>
                <div class="contact-item">
                    <div class="contact-icon">🕐</div>
                    <div>
                        <div style="font-weight:600;font-size:0.875rem;color:var(--text-muted);">Hours</div>
                        <div style="font-weight:700;">24/7 — Emergency Always Open</div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 d-flex align-items-center justify-content-center">
                <div class="card" style="max-width:360px;width:100%;text-align:center;padding:2.5rem;">
                    <div style="font-size:3rem;margin-bottom:1rem;">🚀</div>
                    <h4 style="font-weight:800;margin-bottom:0.5rem;">Ready to get started?</h4>
                    <p style="color:var(--text-muted);font-size:0.9rem;margin-bottom:1.5rem;">
                        Login to the admin panel and manage your hospital digitally.
                    </p>
                    <a href="login.jsp" class="btn btn-primary btn-lg w-100">Login to HMS →</a>
                    <a href="register.jsp" class="btn btn-secondary mt-2 w-100">Register Admin Account</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer class="footer">
    <div class="container d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>© 2026 Ansh Hospital. Developed by <strong style="color:white;">Ansh Jain</strong> (BCA Student)</div>
        <div style="display:flex;gap:1rem;">
            <a href="login.jsp" style="color:rgba(255,255,255,0.7);">Admin Login</a>
            <a href="#about"    style="color:rgba(255,255,255,0.7);">About</a>
            <a href="#contact"  style="color:rgba(255,255,255,0.7);">Contact</a>
        </div>
    </div>
</footer>

<script>
// Dark mode
(function(){const s=localStorage.getItem('hms-dark');if(s==='true')document.body.classList.add('dark-mode');})();
function toggleDark(){
    document.body.classList.toggle('dark-mode');
    const isDark=document.body.classList.contains('dark-mode');
    localStorage.setItem('hms-dark',isDark);
    document.getElementById('darkToggle').textContent=isDark?'☀️':'🌙';
}

// Navbar scroll effect
window.addEventListener('scroll', () => {
    document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 50);
});

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', e => {
        e.preventDefault();
        const t = document.querySelector(a.getAttribute('href'));
        if (t) t.scrollIntoView({behavior:'smooth'});
    });
});

function showToast(m,t){
    const icons={success:'✅',danger:'❌',warning:'⚠️',info:'ℹ️'};
    const c=document.getElementById('toast-container');
    const el=document.createElement('div');
    el.className='toast '+(t||'info');
    el.innerHTML=`<span class="toast-icon">${icons[t]||'ℹ️'}</span><span class="toast-msg">${m}</span><button class="toast-close" onclick="this.parentElement.remove()">✕</button>`;
    c.appendChild(el);
    setTimeout(()=>el.style.opacity='0',4000);
    setTimeout(()=>el.remove(),4500);
}
</script>
</body>
</html>