<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.dao.*, com.hospital.model.*,java.util.List"%>
<%
    String apptIdParam  = request.getParameter("appointment_id");
    String patientParam = request.getParameter("patient");
    String doctorParam  = request.getParameter("doctor");
    String apptDate     = "";
    int    apptId       = 0;

    if (apptIdParam != null && !apptIdParam.isBlank()) {
        try {
            apptId = Integer.parseInt(apptIdParam);
            Appointment a = AppointmentDAO.getById(apptId);
            if (a != null) {
                if (patientParam == null) patientParam = a.getPatientName();
                if (doctorParam  == null) doctorParam  = a.getDoctorName();
                apptDate = String.valueOf(a.getAppointmentDate());
            }
        } catch (Exception ignored) {}
    }
    if (patientParam == null) patientParam = "";
    if (doctorParam  == null) doctorParam  = "";

    List<Doctor> allDoctors = DoctorDAO.getAll();
    List<Patient> allPatients = PatientDAO.getAll();
%>
<jsp:include page="WEB-INF/header.jsp">
    <jsp:param name="title" value="Prescription"/>
</jsp:include>

<div class="page-header animate-fadeUp">
    <div>
        <h1 class="page-title">📝 Prescription Generator</h1>
        <p class="page-subtitle">Create and print a professional medical prescription</p>
    </div>
    <button class="btn btn-primary" onclick="printPrescription()">🖨️ Print / Save PDF</button>
</div>

<div class="row g-4">
    <!-- Form Panel -->
    <div class="col-md-5">
        <div class="card animate-fadeUp delay-1">
            <h4 style="font-size:1rem;font-weight:700;margin-bottom:1.25rem;">📋 Prescription Details</h4>

            <div class="form-group">
                <label class="form-label">Patient Name</label>
                <input type="text" id="px_patient" class="form-control"
                       value="<%=patientParam%>" placeholder="Patient name">
            </div>
            <div class="form-group">
                <label class="form-label">Consulting Doctor</label>
                <input type="text" id="px_doctor" class="form-control"
                       value="<%=doctorParam%>" placeholder="Doctor name">
            </div>
            <div class="form-group">
                <label class="form-label">Date</label>
                <input type="date" id="px_date" class="form-control"
                       value="<%=apptDate.isEmpty() ? java.time.LocalDate.now() : apptDate%>">
            </div>
            <div class="form-group">
                <label class="form-label">Diagnosis / Chief Complaint</label>
                <textarea id="px_diagnosis" class="form-control" rows="2"
                          placeholder="e.g. Fever, Upper respiratory infection"></textarea>
            </div>

            <h5 style="font-size:0.9rem;font-weight:700;color:var(--text-muted);margin:1rem 0 0.75rem;">💊 Medicines</h5>
            <div id="medicineList">
                <div class="medicine-row row g-2 mb-2">
                    <div class="col-5">
                        <input type="text" class="form-control med-name" placeholder="Medicine name">
                    </div>
                    <div class="col-3">
                        <input type="text" class="form-control med-dose" placeholder="Dose (mg)">
                    </div>
                    <div class="col-3">
                        <input type="text" class="form-control med-freq" placeholder="Frequency">
                    </div>
                    <div class="col-1 d-flex align-items-center">
                        <button type="button" onclick="removeMed(this)" class="btn btn-sm btn-danger">✕</button>
                    </div>
                </div>
            </div>
            <button type="button" onclick="addMedicine()" class="btn btn-sm btn-secondary mt-1">+ Add Medicine</button>

            <div class="form-group" style="margin-top:1rem;">
                <label class="form-label">Additional Instructions</label>
                <textarea id="px_notes" class="form-control" rows="2"
                          placeholder="e.g. Rest for 3 days, drink plenty of fluids..."></textarea>
            </div>

            <button class="btn btn-primary w-100 mt-2" onclick="updatePreview()">🔄 Update Preview</button>
        </div>
    </div>

    <!-- Prescription Preview -->
    <div class="col-md-7">
        <div class="card animate-fadeUp delay-2" id="prescriptionPreview"
             style="font-family:'Outfit',sans-serif;">

            <!-- Rx Header -->
            <div style="display:flex;justify-content:space-between;align-items:flex-start;
                        border-bottom:2px solid var(--primary);padding-bottom:1rem;margin-bottom:1rem;">
                <div>
                    <div style="font-size:1.4rem;font-weight:800;color:var(--primary);">🏥 Ansh Hospital</div>
                    <div style="color:var(--text-muted);font-size:0.8rem;">Gursarai, India | +91 9264974887</div>
                </div>
                <div style="text-align:right;font-size:0.85rem;color:var(--text-muted);">
                    <div>Date: <span id="prev_date" style="font-weight:600;color:var(--text-main);"></span></div>
                    <div>Ref#: <%=apptId > 0 ? apptId : "—"%></div>
                </div>
            </div>

            <!-- Patient / Doctor -->
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-bottom:1rem;
                        background:var(--bg-body);border-radius:0.75rem;padding:1rem;">
                <div>
                    <div style="font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:var(--text-muted);">Patient</div>
                    <div id="prev_patient" style="font-weight:700;font-size:1rem;margin-top:0.25rem;">—</div>
                </div>
                <div>
                    <div style="font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:var(--text-muted);">Doctor</div>
                    <div id="prev_doctor" style="font-weight:700;font-size:1rem;margin-top:0.25rem;">—</div>
                </div>
            </div>

            <!-- Diagnosis -->
            <div style="margin-bottom:1rem;">
                <div style="font-size:0.75rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;
                            color:var(--text-muted);margin-bottom:0.3rem;">Diagnosis</div>
                <div id="prev_diagnosis" style="font-weight:600;color:var(--text-main);">—</div>
            </div>

            <!-- Medicines -->
            <div style="margin-bottom:1rem;">
                <div style="font-size:0.75rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;
                            color:var(--text-muted);margin-bottom:0.75rem;">
                    <span style="font-size:1.25rem;">Rx</span> &nbsp; Medications
                </div>
                <div id="prev_medicines">—</div>
            </div>

            <!-- Notes -->
            <div style="background:rgba(245,158,11,0.08);border-radius:0.75rem;padding:1rem;border-left:4px solid var(--warning);">
                <div style="font-size:0.75rem;font-weight:700;color:var(--warning);margin-bottom:0.3rem;">📋 Instructions</div>
                <div id="prev_notes" style="font-size:0.875rem;color:var(--text-main);">—</div>
            </div>

            <!-- Footer -->
            <div style="margin-top:2rem;padding-top:1rem;border-top:1px solid var(--border-color);
                        display:flex;justify-content:space-between;align-items:center;">
                <div style="font-size:0.75rem;color:var(--text-muted);">
                    This prescription is valid for 30 days only.
                </div>
                <div style="text-align:right;">
                    <div style="border-top:1px solid var(--text-main);padding-top:0.25rem;font-size:0.8rem;
                                color:var(--text-muted);width:120px;">Doctor's Signature</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function addMedicine() {
    const row = document.createElement('div');
    row.className = 'medicine-row row g-2 mb-2';
    row.innerHTML = `
        <div class="col-5"><input type="text" class="form-control med-name" placeholder="Medicine name"></div>
        <div class="col-3"><input type="text" class="form-control med-dose" placeholder="Dose (mg)"></div>
        <div class="col-3"><input type="text" class="form-control med-freq" placeholder="Frequency"></div>
        <div class="col-1 d-flex align-items-center">
            <button type="button" onclick="removeMed(this)" class="btn btn-sm btn-danger">✕</button>
        </div>`;
    document.getElementById('medicineList').appendChild(row);
}

function removeMed(btn) {
    const rows = document.querySelectorAll('.medicine-row');
    if (rows.length > 1) btn.closest('.medicine-row').remove();
}

function updatePreview() {
    document.getElementById('prev_patient').textContent  = document.getElementById('px_patient').value || '—';
    document.getElementById('prev_doctor').textContent   = document.getElementById('px_doctor').value  || '—';
    document.getElementById('prev_date').textContent     = document.getElementById('px_date').value    || '—';
    document.getElementById('prev_diagnosis').textContent= document.getElementById('px_diagnosis').value || '—';
    document.getElementById('prev_notes').textContent    = document.getElementById('px_notes').value   || '—';

    const names  = document.querySelectorAll('.med-name');
    const doses  = document.querySelectorAll('.med-dose');
    const freqs  = document.querySelectorAll('.med-freq');
    let html = '';
    names.forEach((n, i) => {
        if (n.value.trim()) {
            html += `<div style="padding:0.6rem 0.75rem;border-radius:0.5rem;background:var(--bg-body);margin-bottom:0.4rem;display:flex;align-items:center;gap:0.75rem;">
                <span style="font-size:1.25rem;">💊</span>
                <span style="font-weight:700;">${n.value}</span>
                <span style="color:var(--text-muted);font-size:0.875rem;">${doses[i]?.value || ''} — ${freqs[i]?.value || ''}</span>
            </div>`;
        }
    });
    document.getElementById('prev_medicines').innerHTML = html || '—';
    showToast('Preview updated', 'success');
}

function printPrescription() {
    updatePreview();
    setTimeout(() => {
        const content = document.getElementById('prescriptionPreview').innerHTML;
        const w = window.open('', '_blank');
        w.document.write(`<!DOCTYPE html><html><head>
            <title>Prescription — Ansh Hospital</title>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
            <style>
                body { font-family:'Outfit',sans-serif; padding:2rem; color:#1e293b; }
                @media print { body { padding:0; } }
            </style>
        </head><body>${content}<script>window.print();setTimeout(()=>window.close(),500);<\/script></body></html>`);
        w.document.close();
    }, 300);
}

// Auto-populate preview on load
updatePreview();
</script>

<jsp:include page="WEB-INF/footer.jsp"/>
