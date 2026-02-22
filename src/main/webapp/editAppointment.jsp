<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.hospital.doa.DBConnection"%>
<%
int id = Integer.parseInt(request.getParameter("id"));
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM appointments WHERE appointment_id=?");
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();
rs.next();

int patientId = rs.getInt("patient_id");
int doctorId = rs.getInt("doctor_id");
Date date = rs.getDate("appointment_date");
con.close();
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Appointment</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
	<link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

	<div class="container mt-5 col-md-6">
		<div class="card p-4 shadow">
			<h3>Edit Appointment</h3>

			<form action="AppointmentServlet" method="post">
				<input type="hidden" name="action" value="update"> <input
					type="hidden" name="appointment_id" value="<%=id%>"> <label>Patient
					ID</label> <input type="number" name="patient_id" value="<%=patientId%>"
					class="form-control mb-3"> <label>Doctor ID</label> <input
					type="number" name="doctor_id" value="<%=doctorId%>"
					class="form-control mb-3"> <label>Date</label> <input
					type="date" name="appointment_date" value="<%=date%>"
					class="form-control mb-3">

				<button class="btn btn-success">Update</button>
				<a href="appointments.jsp" class="btn btn-secondary">Back</a>
			</form>

		</div>
	</div>

</body>
</html>