<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.dao.*, com.hospital.model.*, java.util.List"%>
<%
    List<Patient>     patients     = PatientDAO.getAll();
    List<Doctor>      doctorList   = DoctorDAO.getAll();
    List<Appointment> appointments = AppointmentDAO.getAll();

    String filterStatus = request.getParameter("status");
    if (filterStatus != null && !filterStatus.isBlank() && !"All".equals(filterStatus)) {
        appointments = AppointmentDAO.getByStatus(filterStatus);
    }
%>
<jsp:include page="WEB-INF/header.jsp">
    <jsp:param name="title" value="Appointments"/>
</jsp:include>

<div class="page-header animate-fadeUp">
    <div>
        <h1 class="page-title">📅 Appointment Management</h1>
        <p class="page-subtitle"><%=appointments.size()%> appointments found</p>
    </div>
</div>

<!-- Book Appointment Form -->
<div class="card mb-4 animate-fadeUp delay-1">
    <h4 style="font-size:1rem;font-weight:700;margin-bottom:1.25rem;">📋 Book New Appointment</h4>
    <form action="AppointmentServlet" method="post" id="apptForm" novalidate>
        <input type="hidden" name="action" value="insert">
        <div class="row g-3">
            <div class="col-md-3">
                <div class="form-group mb-0">
                    <label class="form-label">Patient <span style="color:var(--danger)">*</span></label>
                    <select name="patient_id" class="form-select" required>
                        <option value="">Select Patient</option>
                        <% for (Patient p : patients) { %>
                        <option value="<%=p.getId()%>"><%=p.getName()%></option>
                        <% } %>
                    </select>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group mb-0">
                    <label class="form-label">Doctor <span style="color:var(--danger)">*</span></label>
                    <select name="doctor_id" class="form-select" required>
                        <option value="">Select Doctor</option>
                        <% for (Doctor d : doctorList) { %>
                        <option value="<%=d.getId()%>"><%=d.getName()%> — <%=d.getSpecialization()%></option>
                        <% } %>
                    </select>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group mb-0">
                    <label class="form-label">Date <span style="color:var(--danger)">*</span></label>
                    <input type="date" name="appointment_date" class="form-control"
                           min="<%=java.time.LocalDate.now()%>" required>
                </div>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">📅 Book Appointment</button>
            </div>
        </div>
    </form>
</div>

<!-- Filter + Table -->
<div class="table-wrapper animate-fadeUp delay-2">
    <div class="table-toolbar">
        <span class="table-title">All Appointments</span>
        <div style="display:flex;gap:0.6rem;align-items:center;flex-wrap:wrap;">
            <!-- Status Filter -->
            <div style="display:flex;gap:0.4rem;">
                <% String[] statuses = {"All","Pending","Confirmed","Cancelled"};
                   for (String st : statuses) {
                       boolean active = st.equals(filterStatus) || (filterStatus == null && "All".equals(st));
                %>
                <a href="appointment.jsp?status=<%=st%>"
                   class="btn btn-sm <%=active ? "btn-primary" : "btn-secondary"%>">
                    <%=st%>
                </a>
                <% } %>
            </div>
            <div class="search-box">
                <input type="text" id="apptSearch" placeholder="Search..." autocomplete="off">
            </div>
        </div>
    </div>
    <div style="overflow-x:auto;">
        <table class="table" id="apptTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Patient</th>
                    <th>Doctor</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Payment</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (appointments.isEmpty()) { %>
                <tr>
                    <td colspan="7" style="text-align:center;padding:3rem;color:var(--text-muted);">
                        No appointments found.
                    </td>
                </tr>
                <% } else {
                    for (Appointment a : appointments) {
                        String st    = a.getStatus()        != null ? a.getStatus()        : "Pending";
                        String psSt  = a.getPaymentStatus() != null ? a.getPaymentStatus() : "Unpaid";
                        String stCls = "pending".equalsIgnoreCase(st) ? "badge-pending"
                                     : "confirmed".equalsIgnoreCase(st) ? "badge-confirmed" : "badge-cancelled";
                        String psCls = "paid".equalsIgnoreCase(psSt) ? "badge-paid" : "badge-unpaid";
                %>
                <tr>
                    <td><span style="color:var(--text-muted);font-size:0.8rem;">#<%=a.getId()%></span></td>
                    <td><strong><%=a.getPatientName()%></strong></td>
                    <td><%=a.getDoctorName()%></td>
                    <td><%=a.getAppointmentDate()%></td>
                    <td>
                        <select class="status-select badge <%=stCls%>"
                                onchange="updateStatus(<%=a.getId()%>, this.value)"
                                title="Change status">
                            <option value="Pending"   <%="Pending"  .equals(st)?"selected":""%>>⏳ Pending</option>
                            <option value="Confirmed" <%="Confirmed".equals(st)?"selected":""%>>✅ Confirmed</option>
                            <option value="Cancelled" <%="Cancelled".equals(st)?"selected":""%>>❌ Cancelled</option>
                        </select>
                    </td>
                    <td><span class="badge <%=psCls%>"><%=psSt%></span></td>
                    <td>
                        <div style="display:flex;gap:0.4rem;flex-wrap:wrap;">
                            <a href="bill.jsp?id=<%=a.getId()%>" class="btn btn-sm btn-success" title="View Invoice">🧾 Bill</a>
                            <a href="prescription.jsp?appointment_id=<%=a.getId()%>&patient=<%=a.getPatientName()%>&doctor=<%=a.getDoctorName()%>"
                               class="btn btn-sm btn-primary" title="Prescription">📝</a>
                            <button class="btn btn-sm btn-danger"
                                    onclick="confirmDelete('AppointmentServlet?action=delete&id=<%=a.getId()%>','appointment #<%=a.getId()%>')"
                                    title="Delete">🗑</button>
                        </div>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </div>
</div>

<script>
// Live search
document.getElementById('apptSearch').addEventListener('input', function() {
    const q = this.value.toLowerCase();
    document.querySelectorAll('#apptTable tbody tr').forEach(r => {
        r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
});

// Inline status update via fetch
function updateStatus(id, status) {
    fetch('AppointmentServlet?action=status&id=' + id + '&val=' + status)
        .then(() => showToast('Status updated to ' + status, 'success'))
        .catch(() => showToast('Failed to update status', 'danger'));
}
</script>

<jsp:include page="WEB-INF/footer.jsp"/>
