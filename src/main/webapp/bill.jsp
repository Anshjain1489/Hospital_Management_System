<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.dao.AppointmentDAO, com.hospital.model.Appointment"%>
<%
    String idParam = request.getParameter("id");
    if (idParam == null) { response.sendRedirect("appointment.jsp"); return; }

    int appointmentId = Integer.parseInt(idParam);
    Appointment appt  = AppointmentDAO.getById(appointmentId);
    if (appt == null) { response.sendRedirect("error.jsp?msg=Appointment+not+found"); return; }

    double fees  = 0;
    try {
        // Get doctor fees from DAO
        com.hospital.model.Doctor doc = com.hospital.dao.DoctorDAO.getById(appt.getDoctorId());
        if (doc != null) fees = doc.getFees();
    } catch (Exception ignored) {}

    double gst   = fees * 0.18;
    double total = fees + gst;
    String paymentStatus = appt.getPaymentStatus() != null ? appt.getPaymentStatus() : "Unpaid";
%>
<jsp:include page="WEB-INF/header.jsp">
    <jsp:param name="title" value="Invoice"/>
</jsp:include>

<div class="page-header animate-fadeUp">
    <div>
        <h1 class="page-title">🧾 Hospital Invoice</h1>
        <p class="page-subtitle">Invoice for appointment #<%=appointmentId%></p>
    </div>
    <a href="appointment.jsp" class="btn btn-secondary">⬅ Back</a>
</div>

<div class="invoice-box animate-scaleIn" style="max-width:700px;margin:0 auto 2rem;">

    <!-- Invoice Header -->
    <div class="invoice-header">
        <div>
            <div style="font-size:1.5rem;font-weight:800;">🏥 Ansh Hospital</div>
            <div style="opacity:0.85;font-size:0.875rem;margin-top:0.25rem;">Gursarai, India</div>
            <div style="opacity:0.75;font-size:0.8rem;">anshjain1440@gmail.com | +91 9264974887</div>
        </div>
        <div style="text-align:right;">
            <div style="font-size:1.1rem;font-weight:700;">Invoice #<%=appointmentId%></div>
            <div style="margin-top:0.5rem;">
                <span style="padding:0.3rem 0.75rem;border-radius:100px;font-size:0.8rem;font-weight:700;
                             background:<%="Paid".equalsIgnoreCase(paymentStatus)?"rgba(16,185,129,0.25)":"rgba(239,68,68,0.25)"%>;
                             color:<%="Paid".equalsIgnoreCase(paymentStatus)?"#6ee7b7":"#fca5a5"%>;">
                    <%="Paid".equalsIgnoreCase(paymentStatus) ? "✅ PAID" : "⚠ UNPAID"%>
                </span>
            </div>
        </div>
    </div>

    <!-- Invoice Body -->
    <div class="invoice-body">

        <!-- Patient & Doctor Details -->
        <div class="row" style="margin-bottom:1.5rem;">
            <div class="col-md-6">
                <p style="font-size:0.75rem;color:var(--text-muted);font-weight:700;text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.5rem;">Bill To</p>
                <p style="font-weight:700;font-size:1rem;margin-bottom:0.2rem;"><%=appt.getPatientName()%></p>
                <p style="color:var(--text-muted);font-size:0.875rem;">Patient</p>
            </div>
            <div class="col-md-6" style="text-align:right;">
                <p style="font-size:0.75rem;color:var(--text-muted);font-weight:700;text-transform:uppercase;letter-spacing:0.05em;margin-bottom:0.5rem;">Consulting Doctor</p>
                <p style="font-weight:700;font-size:1rem;margin-bottom:0.2rem;"><%=appt.getDoctorName()%></p>
                <p style="color:var(--text-muted);font-size:0.875rem;">Date: <%=appt.getAppointmentDate()%></p>
            </div>
        </div>

        <!-- Bill Table -->
        <table class="table" style="margin-bottom:1.5rem;">
            <thead>
                <tr>
                    <th style="background:var(--primary-light);color:var(--primary);">Description</th>
                    <th style="background:var(--primary-light);color:var(--primary);text-align:right;">Amount (₹)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Consultation Fees — <%=appt.getDoctorName()%></td>
                    <td style="text-align:right;font-weight:600;"><%=String.format("%.2f", fees)%></td>
                </tr>
                <tr>
                    <td style="color:var(--text-muted);">GST (18%)</td>
                    <td style="text-align:right;color:var(--text-muted);"><%=String.format("%.2f", gst)%></td>
                </tr>
                <tr style="background:rgba(16,185,129,0.05);">
                    <td style="font-weight:800;font-size:1.05rem;">Total Amount</td>
                    <td style="text-align:right;font-weight:800;font-size:1.2rem;color:var(--success);">
                        ₹ <%=String.format("%.2f", total)%>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- QR Code -->
        <div style="text-align:center;margin-bottom:1.5rem;padding:1rem;background:var(--bg-body);border-radius:0.75rem;">
            <p style="font-size:0.8rem;color:var(--text-muted);margin-bottom:0.75rem;">Scan to Pay via UPI</p>
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=upi://pay?pa=anshjain@upi&pn=AnshHospital&am=<%=String.format("%.2f",total)%>&cu=INR"
                 alt="UPI QR Code" style="border-radius:0.5rem;">
        </div>

        <!-- Action Buttons -->
        <div style="display:flex;gap:0.75rem;flex-wrap:wrap;">
            <% if (!"Paid".equalsIgnoreCase(paymentStatus)) { %>
            <button onclick="payNow(<%=total%>, <%=appointmentId%>)"
                    class="btn btn-success" style="flex:1;">
                💳 Pay Online (Razorpay)
            </button>
            <% } %>
            <form action="BillServlet" method="post" style="flex:1;">
                <input type="hidden" name="appointment_id" value="<%=appointmentId%>">
                <input type="hidden" name="total" value="<%=total%>">
                <input type="hidden" name="fees"  value="<%=fees%>">
                <input type="hidden" name="gst"   value="<%=gst%>">
                <button type="submit" class="btn btn-primary w-100">📄 Download PDF Invoice</button>
            </form>
        </div>

    </div>
</div>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script src="js/payment.js"></script>

<jsp:include page="WEB-INF/footer.jsp"/>