<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.Appointment, java.util.List"%>
<%-- Dashboard data is set by DashboardServlet via request.setAttribute --%>
<%
    // If accessed directly (not via servlet), redirect to servlet
    if (request.getAttribute("totalPatients") == null) {
        response.sendRedirect("DashboardServlet");
        return;
    }
    int totalPatients     = (int) request.getAttribute("totalPatients");
    int totalDoctors      = (int) request.getAttribute("totalDoctors");
    int totalAppointments = (int) request.getAttribute("totalAppointments");
    double totalRevenue   = (double) request.getAttribute("totalRevenue");
    int[] monthly         = (int[]) request.getAttribute("monthlyData");
    double[] revenue      = (double[]) request.getAttribute("revenueData");

    // Build chart data strings safely
    StringBuilder monthlyJson  = new StringBuilder("[");
    StringBuilder revenueJson  = new StringBuilder("[");
    for (int i = 0; i < 12; i++) {
        monthlyJson.append(monthly != null ? monthly[i] : 0).append(i<11?",":"");
        revenueJson.append(revenue != null ? revenue[i] : 0).append(i<11?",":"");
    }
    monthlyJson.append("]");
    revenueJson.append("]");
%>
<jsp:include page="WEB-INF/header.jsp">
    <jsp:param name="title" value="Dashboard"/>
</jsp:include>

<!-- Page Header -->
<div class="page-header animate-fadeUp">
    <div>
        <h1 class="page-title">📊 Dashboard Overview</h1>
        <p class="page-subtitle">Welcome back! Here's what's happening today.</p>
    </div>
</div>

<!-- Stat Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-3 col-sm-6">
        <div class="stat-card stat-card-patients animate-fadeUp delay-1">
            <span class="stat-icon">👨‍⚕️</span>
            <p class="stat-label">Total Patients</p>
            <div class="stat-value" id="numPatients">0</div>
            <p class="stat-sub">Registered patients</p>
        </div>
    </div>
    <div class="col-md-3 col-sm-6">
        <div class="stat-card stat-card-doctors animate-fadeUp delay-2">
            <span class="stat-icon">🩺</span>
            <p class="stat-label">Total Doctors</p>
            <div class="stat-value" id="numDoctors">0</div>
            <p class="stat-sub">Active physicians</p>
        </div>
    </div>
    <div class="col-md-3 col-sm-6">
        <div class="stat-card stat-card-appointments animate-fadeUp delay-3">
            <span class="stat-icon">📅</span>
            <p class="stat-label">Appointments</p>
            <div class="stat-value" id="numAppt">0</div>
            <p class="stat-sub">Total booked</p>
        </div>
    </div>
    <div class="col-md-3 col-sm-6">
        <div class="stat-card stat-card-revenue animate-fadeUp delay-4">
            <span class="stat-icon">💰</span>
            <p class="stat-label">Total Revenue</p>
            <div class="stat-value">₹<span id="numRevenue">0</span></div>
            <p class="stat-sub">Paid invoices</p>
        </div>
    </div>
</div>

<!-- Charts Row -->
<div class="row g-3 mb-4">
    <div class="col-md-7">
        <div class="card animate-fadeUp">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
                <div>
                    <h3 style="font-size:1rem;font-weight:700;color:var(--text-main);margin:0;">Monthly Appointments</h3>
                    <p style="font-size:0.8rem;color:var(--text-muted);margin:0;">Current year</p>
                </div>
                <span style="font-size:1.5rem;">📅</span>
            </div>
            <div class="chart-container">
                <canvas id="appointmentChart"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-5">
        <div class="card animate-fadeUp delay-2">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
                <div>
                    <h3 style="font-size:1rem;font-weight:700;color:var(--text-main);margin:0;">Revenue (₹)</h3>
                    <p style="font-size:0.8rem;color:var(--text-muted);margin:0;">Current year</p>
                </div>
                <span style="font-size:1.5rem;">💰</span>
            </div>
            <div class="chart-container">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- Quick Actions + Recent -->
<div class="row g-3">
    <div class="col-md-4">
        <div class="card animate-fadeUp">
            <h3 style="font-size:1rem;font-weight:700;margin-bottom:1.25rem;">⚡ Quick Actions</h3>
            <div style="display:flex;flex-direction:column;gap:0.75rem;">
                <a href="patients.jsp" class="btn btn-primary" style="justify-content:flex-start;">
                    👨‍⚕️ &nbsp; Add Patient
                </a>
                <a href="doctors.jsp" class="btn btn-success" style="justify-content:flex-start;">
                    🩺 &nbsp; Add Doctor
                </a>
                <a href="appointment.jsp" class="btn btn-warning" style="justify-content:flex-start;">
                    📅 &nbsp; Book Appointment
                </a>
                <a href="prescription.jsp" class="btn btn-secondary" style="justify-content:flex-start;">
                    📝 &nbsp; New Prescription
                </a>
            </div>
        </div>
    </div>

    <div class="col-md-8">
        <div class="table-wrapper animate-fadeUp delay-2">
            <div class="table-toolbar">
                <span class="table-title">🕐 Recent Appointments</span>
                <a href="appointment.jsp" class="btn btn-sm btn-outline-primary">View All</a>
            </div>
            <div style="overflow-x:auto;">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        @SuppressWarnings("unchecked")
                        List<Appointment> recentList = (List<Appointment>) request.getAttribute("recentAppointments");
                        int shown = 0;
                        if (recentList != null) {
                            for (Appointment a : recentList) {
                                if (shown++ >= 5) break;
                                String st = a.getStatus() != null ? a.getStatus() : "Pending";
                                String badgeCls = "pending".equalsIgnoreCase(st) ? "badge-pending"
                                    : "confirmed".equalsIgnoreCase(st) ? "badge-confirmed" : "badge-cancelled";
                        %>
                        <tr>
                            <td><span style="color:var(--text-muted);font-size:0.8rem;">#<%=a.getId()%></span></td>
                            <td><strong><%=a.getPatientName()%></strong></td>
                            <td><%=a.getDoctorName()%></td>
                            <td><%=a.getAppointmentDate()%></td>
                            <td><span class="badge <%=badgeCls%>"><%=st%></span></td>
                        </tr>
                        <%
                            }
                        }
                        if (shown == 0) { %>
                        <tr><td colspan="5" style="text-align:center;padding:2rem;color:var(--text-muted);">No appointments yet</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
// Animated counter
function animateCount(id, target, isFloat) {
    const el = document.getElementById(id);
    if (!el) return;
    let start = 0, duration = 1200, step = 16;
    const inc = target / (duration / step);
    const t = setInterval(() => {
        start += inc;
        if (start >= target) { start = target; clearInterval(t); }
        el.textContent = isFloat
            ? parseFloat(start).toLocaleString('en-IN', {maximumFractionDigits:0})
            : Math.floor(start);
    }, step);
}

window.addEventListener('DOMContentLoaded', () => {
    animateCount('numPatients', <%=totalPatients%>);
    animateCount('numDoctors',  <%=totalDoctors%>);
    animateCount('numAppt',     <%=totalAppointments%>);
    animateCount('numRevenue',  <%=totalRevenue%>, true);
});

// Chart.js — Appointments bar chart
const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
const monthlyData = <%=monthlyJson%>;
const revenueData = <%=revenueJson%>;

const isDark = () => document.body.classList.contains('dark-mode');
const gridColor = () => isDark() ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.05)';
const labelColor = () => isDark() ? '#94a3b8' : '#64748b';

function buildApptChart() {
    const ctx = document.getElementById('appointmentChart').getContext('2d');
    return new Chart(ctx, {
        type: 'bar',
        data: {
            labels: months,
            datasets: [{
                label: 'Appointments',
                data: monthlyData,
                backgroundColor: 'rgba(79,70,229,0.75)',
                borderRadius: 6,
                borderSkipped: false,
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { color: labelColor(), stepSize: 1 }, grid: { color: gridColor() } },
                x: { ticks: { color: labelColor() }, grid: { display: false } }
            }
        }
    });
}

function buildRevChart() {
    const ctx = document.getElementById('revenueChart').getContext('2d');
    const grad = ctx.createLinearGradient(0, 0, 0, 200);
    grad.addColorStop(0, 'rgba(16,185,129,0.4)');
    grad.addColorStop(1, 'rgba(16,185,129,0)');
    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: months,
            datasets: [{
                label: 'Revenue (₹)',
                data: revenueData,
                borderColor: '#10b981',
                backgroundColor: grad,
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: '#10b981',
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { color: labelColor() }, grid: { color: gridColor() } },
                x: { ticks: { color: labelColor() }, grid: { display: false } }
            }
        }
    });
}

let apptChart = buildApptChart();
let revChart  = buildRevChart();

// Rebuild charts on dark mode toggle to refresh colors
const originalToggle = window.toggleDark;
window.toggleDark = function() {
    if (originalToggle) originalToggle();
    setTimeout(() => {
        apptChart.destroy(); revChart.destroy();
        apptChart = buildApptChart(); revChart = buildRevChart();
    }, 350);
};
</script>

<jsp:include page="WEB-INF/footer.jsp"/>