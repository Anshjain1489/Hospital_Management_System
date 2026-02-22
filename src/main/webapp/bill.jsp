<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.hospital.doa.DBConnection"%>

<%
int appointmentId = Integer.parseInt(request.getParameter("id"));

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
	"SELECT a.*, p.name AS patient_name, d.name AS doctor_name, d.fees " +
	"FROM appointments a " +
	"JOIN patients p ON a.patient_id=p.patient_id " +
	"JOIN doctors d ON a.doctor_id=d.doctor_id " +
	"WHERE a.appointment_id=?");

ps.setInt(1, appointmentId);
ResultSet rs = ps.executeQuery();
rs.next();

String patient = rs.getString("patient_name");
String doctor = rs.getString("doctor_name");
double fees = rs.getDouble("fees");
String paymentStatus = rs.getString("payment_status");

double gst = fees * 0.18;
double total = fees + gst;

con.close();
%>

<!DOCTYPE html>
<html>
<head>
<title>Hospital Invoice</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link rel="stylesheet" href="css/style.css">

<style>
.invoice-box {
	border-radius: 15px;
	background: #ffffff;
	padding: 30px;
	box-shadow: 0 10px 25px rgba(0,0,0,0.1);
}
.logo {
	font-size: 26px;
	font-weight: bold;
	color: #0d6efd;
}
</style>

</head>

<body class="bg-light">

<div class="container mt-5 col-md-8">

	<div class="invoice-box">

		<!-- HEADER -->
		<div class="d-flex justify-content-between align-items-center">
			<div class="logo">🏥 Ansh Hospital</div>

			<div class="text-end">
				<strong>Invoice ID:</strong> #<%=appointmentId%><br>
				<strong>Status:</strong>
				<span class="badge 
					<%="Paid".equalsIgnoreCase(paymentStatus) ? "bg-success" : "bg-danger"%>">
					<%=paymentStatus%>
				</span>
			</div>
		</div>

		<hr>

		<!-- PATIENT DETAILS -->
		<div class="row">
			<div class="col-md-6">
				<p><strong>Patient:</strong> <%=patient%></p>
				<p><strong>Doctor:</strong> <%=doctor%></p>
			</div>
			<div class="col-md-6 text-end">
				<p><strong>Date:</strong> <%=new java.util.Date()%></p>
			</div>
		</div>

		<!-- BILL TABLE -->
		<table class="table table-bordered mt-4">
			<thead class="table-primary">
				<tr>
					<th>Description</th>
					<th class="text-end">Amount (₹)</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Consultation Fees</td>
					<td class="text-end"><%=String.format("%.2f", fees)%></td>
				</tr>
				<tr>
					<td>GST (18%)</td>
					<td class="text-end"><%=String.format("%.2f", gst)%></td>
				</tr>
				<tr class="table-success">
					<th>Total Amount</th>
					<th class="text-end"><%=String.format("%.2f", total)%></th>
				</tr>
			</tbody>
		</table>

		<!-- QR UPI -->
		<div class="text-center mt-4">
			<h6>Scan | Pay via UPI</h6>
			<img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=upi://pay?pa=yourupi@bank&pn=AnshHospital&am=<%=total%>&cu=INR"
				 alt="QR Code">
		</div>

		<!-- ACTION BUTTONS -->
		<div class="mt-4">

			<%
			if (!"Paid".equalsIgnoreCase(paymentStatus)) {
			%>

			<button onclick="payNow(<%=total%>, <%=appointmentId%>)"
					class="btn btn-success w-100 mb-2">
				💳 Pay Online (Razorpay)
			</button>

			<%
			}
			%>

			<form action="BillServlet" method="post">
				<input type="hidden" name="appointment_id"
					   value="<%=appointmentId%>">
				<input type="hidden" name="total"
					   value="<%=total%>">
				<button class="btn btn-primary w-100">
					📄 Download PDF Bill
				</button>
			</form>

			<a href="appointment.jsp"
			   class="btn btn-secondary mt-2 w-100">
			   Back
			</a>

		</div>

	</div>
</div>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script src="js/payment.js"></script>

</body>
</html>