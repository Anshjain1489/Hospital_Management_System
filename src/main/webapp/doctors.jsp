<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.dao.DoctorDAO, com.hospital.model.Doctor, java.util.List"%>
<%
    List<Doctor> doctors = DoctorDAO.getAll();
%>
<jsp:include page="WEB-INF/header.jsp">
    <jsp:param name="title" value="Doctors"/>
</jsp:include>

<div class="page-header animate-fadeUp">
    <div>
        <h1 class="page-title">🩺 Doctor Management</h1>
        <p class="page-subtitle"><%=doctors.size()%> registered doctors</p>
    </div>
</div>

<!-- Add Doctor Form -->
<div class="card mb-4 animate-fadeUp delay-1">
    <h4 style="font-size:1rem;font-weight:700;margin-bottom:1.25rem;">➕ Add New Doctor</h4>
    <form action="DoctorServlet" method="post" enctype="multipart/form-data" id="addDoctorForm" novalidate>
        <input type="hidden" name="action" value="insert">
        <div class="row g-3">
            <div class="col-md-3">
                <div class="form-group mb-0">
                    <label class="form-label">Doctor Name <span style="color:var(--danger)">*</span></label>
                    <input type="text" name="name" class="form-control" placeholder="Dr. Full Name" required>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group mb-0">
                    <label class="form-label">Specialization <span style="color:var(--danger)">*</span></label>
                    <input type="text" name="specialization" class="form-control" placeholder="e.g. Cardiology" required>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group mb-0">
                    <label class="form-label">Fees (₹) <span style="color:var(--danger)">*</span></label>
                    <input type="number" name="fees" class="form-control" placeholder="500" min="0" step="0.01" required>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group mb-0">
                    <label class="form-label">Mobile <span style="color:var(--danger)">*</span></label>
                    <input type="tel" name="phone" class="form-control" placeholder="10 digits" required>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group mb-0">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="doctor@hospital.com">
                </div>
            </div>
            <div class="col-md-1">
                <div class="form-group mb-0">
                    <label class="form-label">Photo</label>
                    <input type="file" name="image" class="form-control" accept="image/*" style="font-size:0.75rem;padding:0.4rem;">
                </div>
            </div>
        </div>
        <div class="mt-3">
            <button type="submit" class="btn btn-success">➕ Add Doctor</button>
        </div>
    </form>
</div>

<!-- Search -->
<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;" class="animate-fadeUp delay-2">
    <h4 style="font-size:1rem;font-weight:700;color:var(--text-main);margin:0;">Our Medical Team</h4>
    <div class="search-box">
        <input type="text" id="doctorSearch" placeholder="Search doctors..." autocomplete="off">
    </div>
</div>

<!-- Doctor Cards Grid -->
<div class="row g-3" id="doctorGrid">
    <%
    if (doctors.isEmpty()) { %>
    <div class="col-12 text-center" style="padding:3rem;color:var(--text-muted);">
        No doctors added yet. Add your first doctor above.
    </div>
    <% } else {
        for (Doctor d : doctors) {
            String imgSrc = (d.getImage() != null && !d.getImage().isEmpty() && !"null".equals(d.getImage()))
                ? "images/" + d.getImage() : null;
    %>
    <div class="col-md-3 col-sm-6 animate-fadeUp doctor-item">
        <div class="card doctor-card" style="padding:0;">
            <% if (imgSrc != null) { %>
            <img src="<%=imgSrc%>" class="doctor-card-img" alt="<%=d.getName()%>"
                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
            <div style="display:none;height:180px;background:linear-gradient(135deg,#6366f1,#a855f7);
                        align-items:center;justify-content:center;font-size:3rem;color:white;">🩺</div>
            <% } else { %>
            <div style="height:180px;background:linear-gradient(135deg,#6366f1,#a855f7);
                        display:flex;align-items:center;justify-content:center;font-size:3rem;color:white;">🩺</div>
            <% } %>
            <div class="doctor-card-body">
                <div class="doctor-card-name"><%=d.getName()%></div>
                <span class="doctor-card-spec"><%=d.getSpecialization()%></span>
                <p class="doctor-card-fee">💰 ₹ <%=String.format("%.0f", d.getFees())%> / visit</p>
                <% if (d.getMobile() != null && !d.getMobile().isEmpty()) { %>
                <p class="doctor-card-fee" style="margin-top:0.25rem;">📞 <%=d.getMobile()%></p>
                <% } %>
                <div style="margin-top:0.75rem;display:flex;gap:0.4rem;">
                    <button class="btn btn-sm btn-danger" style="flex:1;"
                            onclick="confirmDelete('DoctorServlet?action=delete&id=<%=d.getId()%>','<%=d.getName()%>')">
                        🗑 Delete
                    </button>
                </div>
            </div>
        </div>
    </div>
    <%  }
    } %>
</div>

<script>
// Live search across doctor cards
document.getElementById('doctorSearch').addEventListener('input', function() {
    const q = this.value.toLowerCase();
    document.querySelectorAll('.doctor-item').forEach(card => {
        card.style.display = card.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
});
</script>

<jsp:include page="WEB-INF/footer.jsp"/>