<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.hospital.doa.DBConnection"%>

<%
// 🔐 Session Security
if (session.getAttribute("user") == null) {
	response.sendRedirect("login.jsp");
	return;
}

int totalPatients = 0;
int totalDoctors = 0;
int totalAppointments = 0;
double totalRevenue = 0;

try {
	Connection con = DBConnection.getConnection();
	Statement st = con.createStatement();

	ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM patients");
	if (rs1.next())
		totalPatients = rs1.getInt(1);

	ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM doctors");
	if (rs2.next())
		totalDoctors = rs2.getInt(1);

	ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM appointments");
	if (rs3.next())
		totalAppointments = rs3.getInt(1);

	ResultSet rs4 = st.executeQuery("SELECT IFNULL(SUM(amount),0) FROM payments WHERE payment_status='Paid'");
	if (rs4.next())
		totalRevenue = rs4.getDouble(1);

	con.close();
} catch (Exception e) {
	e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard - HMS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">

</head>

<body>

	<!-- ================= SIDEBAR ================= -->
	<div class="sidebar">
		<h4>🏥 HMS Admin</h4>
		<a href="dashboard.jsp">📊 Dashboard</a> <a href="patients.jsp">👨‍⚕️
			Patients</a> <a href="doctors.jsp">🩺 Doctors</a> <a
			href="appointment.jsp">📅 Appointments</a> <a href="LogoutServlet">🚪
			Logout</a> <a href="#" onclick="toggleDarkMode()">🌙 Dark Mode</a>
	</div>

	<!-- ================= MAIN CONTENT ================= -->
	<div class="main-content">

		<h2 class="mb-4">📊 Dashboard Overview</h2>

		<div class="row g-4">

			<!-- Patients -->
			<div class="col-md-3">
				<div class="dashboard-card card-patient text-center">
					<h5>Total Patients</h5>
					<h2><%=totalPatients%></h2>
				</div>
			</div>

			<!-- Doctors -->
			<div class="col-md-3">
				<div class="dashboard-card card-doctor text-center">
					<h5>Total Doctors</h5>
					<h2><%=totalDoctors%></h2>
				</div>
			</div>

			<!-- Appointments -->
			<div class="col-md-3">
				<div class="dashboard-card card-appointment text-center">
					<h5>Total Appointments</h5>
					<h2><%=totalAppointments%></h2>
				</div>
			</div>

			<!-- Revenue -->
			<div class="col-md-3">
				<div class="dashboard-card card-revenue text-center">
					<h5>Total Revenue</h5>
					<h2>
						₹
						<%=totalRevenue%></h2>
				</div>
			</div>

		</div>

		<!-- Glassmorphism Welcome Section -->
		<div class="glass-card mt-5">
			<h4>
				Welcome,
				<%=session.getAttribute("user")%>
				👋
			</h4>
			<p>This is your Hospital Management System Admin Panel.</p>
		</div>

	</div>

	<!-- Dark Mode Script -->
	<script>
		function toggleDarkMode() {
			document.body.classList.toggle("dark-mode");
		}
	</script>

</body>
</html>