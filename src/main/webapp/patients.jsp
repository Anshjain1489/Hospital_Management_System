<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.dao.PatientDAO, com.hospital.model.Patient, java.util.List"%>
<%
    List<Patient> patients = PatientDAO.getAll();
%>
<jsp:include page="WEB-INF/header.jsp">
    <jsp:param name="title" value="Patients"/>
</jsp:include>

<div class="page-header animate-fadeUp">
    <div>
        <h1 class="page-title">👨‍⚕️ Patient Management</h1>
        <p class="page-subtitle"><%=patients.size()%> registered patients</p>
    </div>
</div>

<!-- Add Patient Card -->
<div class="card mb-4 animate-fadeUp delay-1">
    <h4 style="font-size:1rem;font-weight:700;margin-bottom:1.25rem;">➕ Add New Patient</h4>
    <form action="PatientServlet" method="post" id="addPatientForm" novalidate>
        <input type="hidden" name="action" value="insert">
        <div class="row g-3">
            <div class="col-md-3">
                <div class="form-group mb-0">
                    <label class="form-label">Full Name <span style="color:var(--danger)">*</span></label>
                    <input type="text" name="name" class="form-control" placeholder="Patient name" required>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group mb-0">
                    <label class="form-label">Age <span style="color:var(--danger)">*</span></label>
                    <input type="number" name="age" class="form-control" placeholder="Age" min="0" max="150" required>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group mb-0">
                    <label class="form-label">Gender <span style="color:var(--danger)">*</span></label>
                    <select name="gender" class="form-select" required>
                        <option value="">Select</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group mb-0">
                    <label class="form-label">Mobile <span style="color:var(--danger)">*</span></label>
                    <input type="tel" name="mobile" class="form-control" placeholder="10-digit number"
                           pattern="\d{10}" maxlength="10" required>
                </div>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">Add Patient</button>
            </div>
        </div>
    </form>
</div>

<!-- Patient Table -->
<div class="table-wrapper animate-fadeUp delay-2">
    <div class="table-toolbar">
        <span class="table-title">All Patients</span>
        <div class="search-box">
            <input type="text" id="patientSearch" placeholder="Search patients..." autocomplete="off">
        </div>
    </div>
    <div style="overflow-x:auto;">
        <table class="table" id="patientTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Age</th>
                    <th>Gender</th>
                    <th>Mobile</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                if (patients.isEmpty()) { %>
                <tr>
                    <td colspan="6" style="text-align:center;padding:3rem;color:var(--text-muted);">
                        No patients found. Add your first patient above.
                    </td>
                </tr>
                <% } else {
                    for (Patient p : patients) { %>
                <tr>
                    <td><span style="color:var(--text-muted);font-size:0.8rem;">#<%=p.getId()%></span></td>
                    <td>
                        <div style="display:flex;align-items:center;gap:0.6rem;">
                            <div style="width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#a855f7);
                                        display:flex;align-items:center;justify-content:center;color:white;font-weight:700;font-size:0.85rem;flex-shrink:0;">
                                <%=p.getName().charAt(0)%>
                            </div>
                            <span style="font-weight:600;"><%=p.getName()%></span>
                        </div>
                    </td>
                    <td><%=p.getAge()%> yrs</td>
                    <td>
                        <span class="badge" style="background:<%="Male".equals(p.getGender())?"rgba(59,130,246,0.12)":"rgba(236,72,153,0.12)"%>;
                              color:<%="Male".equals(p.getGender())?"#2563eb":"#db2777"%>">
                            <%=p.getGender()%>
                        </span>
                    </td>
                    <td><%=p.getMobile()%></td>
                    <td>
                        <div style="display:flex;gap:0.4rem;">
                            <a href="appointment.jsp" class="btn btn-sm btn-primary" title="Book Appointment">📅</a>
                            <button class="btn btn-sm btn-danger"
                                    onclick="confirmDelete('PatientServlet?action=delete&id=<%=p.getId()%>','<%=p.getName()%>')"
                                    title="Delete">🗑</button>
                        </div>
                    </td>
                </tr>
                <%  }
                } %>
            </tbody>
        </table>
    </div>
</div>

<script>
// Live search
document.getElementById('patientSearch').addEventListener('input', function() {
    const q = this.value.toLowerCase();
    document.querySelectorAll('#patientTable tbody tr').forEach(row => {
        row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
});
</script>

<jsp:include page="WEB-INF/footer.jsp"/>