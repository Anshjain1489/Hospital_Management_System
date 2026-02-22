<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.hospital.doa.DBConnection"%>
<!DOCTYPE html>
<html>
<head>
<title>Appointments</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
	<link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

	<div class="container mt-4">

		<h2 class="mb-4">📅 Appointments</h2>
		<a href="dashboard.jsp" class="btn btn-secondary mb-3">⬅ Back</a>

		<!-- Add Appointment Form -->
		<div class="card p-4 mb-4 shadow">
			<h4>Add Appointment</h4>

			<form action="AppointmentServlet" method="post">
				<input type="hidden" name="action" value="insert">

				<div class="row">

					<div class="col-md-4">
						<label>Patient</label> <select name="patient_id"
							class="form-select" required>
							<option value="">Select Patient</option>
							<%
							Connection con = DBConnection.getConnection();
							Statement st = con.createStatement();
							ResultSet rs = st.executeQuery("SELECT * FROM patients");
							while (rs.next()) {
							%>
							<option value="<%=rs.getInt("patient_id")%>">
								<%=rs.getString("name")%>
							</option>
							<%
							}
							%>
						</select>
					</div>

					<div class="col-md-4">
						<label>Doctor</label> <select name="doctor_id" class="form-select"
							required>
							<option value="">Select Doctor</option>
							<%
							ResultSet rs2 = st.executeQuery("SELECT * FROM doctors");
							while (rs2.next()) {
							%>
							<option value="<%=rs2.getInt("doctor_id")%>">
								<%=rs2.getString("name")%>
							</option>
							<%
							}
							con.close();
							%>
						</select>
					</div>

					<div class="col-md-4">
						<label>Date</label> <input type="date" name="appointment_date"
							class="form-control" required>
					</div>

				</div>

				<button class="btn btn-primary mt-3">Book Appointment</button>
			</form>
		</div>

		<!-- Appointment List -->
		<div class="card p-4 shadow">
			<h4>Appointment List</h4>

			<table class="table table-bordered text-center mt-3">
				<thead class="table-dark">
					<tr>
						<th>ID</th>
						<th>Patient</th>
						<th>Doctor</th>
						<th>Date</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>

					<%
					con = DBConnection.getConnection();
					PreparedStatement ps = con.prepareStatement(
							"SELECT a.*, p.name AS patient_name, d.name AS doctor_name FROM appointments a JOIN patients p ON a.patient_id=p.patient_id JOIN doctors d ON a.doctor_id=d.doctor_id ORDER BY appointment_id DESC");
					ResultSet r = ps.executeQuery();
					while (r.next()) {
					%>
					<tr>
						<td><%=r.getInt("appointment_id")%></td>
						<td><%=r.getString("patient_name")%></td>
						<td><%=r.getString("doctor_name")%></td>
						<td><%=r.getDate("appointment_date")%></td>
						<td><a
							href="editAppointment.jsp?id=<%=r.getInt("appointment_id")%>"
							class="btn btn-warning btn-sm">Edit</a> <a
							href="AppointmentServlet?action=delete&id=<%=r.getInt("appointment_id")%>"
							class="btn btn-danger btn-sm">Delete</a> <a
							href="bill.jsp?id=<%=r.getInt("appointment_id")%>"
							class="btn btn-success btn-sm">Generate Bill</a></td>
					</tr>
					<%
					}
					con.close();
					%>

				</tbody>
			</table>
		</div>

	</div>
</body>
</html>

