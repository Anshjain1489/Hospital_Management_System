<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.hospital.doa.DBConnection"%>

<%
if (session.getAttribute("user") == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctors Management</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f4f6f9;
}

.card {
	border-radius: 15px;
}

.doctor-img {
	width: 70px;
	height: 70px;
	object-fit: cover;
	border-radius: 50%;
}
</style>

</head>
<body>

	<div class="container mt-4">

		<!-- Header -->
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2>👨‍⚕ Doctors Management</h2>
			<a href="dashboard.jsp" class="btn btn-secondary">⬅ Back</a>
		</div>

		<!-- Add Doctor -->
		<div class="card p-4 mb-4 shadow">
			<h4>Add New Doctor</h4>

			<form action="DoctorServlet" method="post"
				enctype="multipart/form-data">
				<input type="hidden" name="action" value="insert">

				<div class="row">

					<div class="col-md-3 mb-3">
						<input type="text" name="name" class="form-control"
							placeholder="Doctor Name" required>
					</div>

					<div class="col-md-2 mb-3">
						<input type="text" name="specialization" class="form-control"
							placeholder="Specialization" required>
					</div>

					<div class="col-md-2 mb-3">
						<input type="number" step="0.01" name="fees" class="form-control"
							placeholder="Fees" required>
					</div>

					<div class="col-md-2 mb-3">
						<input type="text" name="phone" class="form-control"
							placeholder="Mobile" required>
					</div>

					<div class="col-md-2 mb-3">
						<input type="email" name="email" class="form-control"
							placeholder="Email">
					</div>

					<div class="col-md-1 mb-3">
						<input type="file" name="image" class="form-control"
							accept="image/*" required>
					</div>

				</div>

				<button class="btn btn-primary">Add Doctor</button>
			</form>
		</div>

		<!-- Doctor List -->
		<div class="card p-4 shadow">
			<h4>Doctors List</h4>

			<table class="table table-bordered table-hover mt-3 text-center">
				<thead class="table-dark">
					<tr>
						<th>ID</th>
						<th>Photo</th>
						<th>Name</th>
						<th>Specialization</th>
						<th>Fees</th>
						<th>Mobile</th>
						<th>Email</th>
						<th>Action</th>
					</tr>
				</thead>

				<tbody>

					<%
					try {
						Connection con = DBConnection.getConnection();
						Statement st = con.createStatement();
						ResultSet rs = st.executeQuery("SELECT * FROM doctors ORDER BY doctor_id DESC");

						while (rs.next()) {
					%>

					<tr>
						<td><%=rs.getInt("doctor_id")%></td>

						<td><img src="images/<%=rs.getString("image")%>"
							class="doctor-img"></td>

						<td><%=rs.getString("name")%></td>
						<td><%=rs.getString("specialization")%></td>
						<td>₹ <%=rs.getBigDecimal("fees")%></td>
						<td><%=rs.getString("mobile")%></td>
						<td><%=rs.getString("email")%></td>

						<td><a
							href="DoctorServlet?action=delete&id=<%=rs.getInt("doctor_id")%>"
							class="btn btn-danger btn-sm"
							onclick="return confirm('Delete this doctor?');"> Delete </a></td>
					</tr>

					<%
					}
					con.close();
					} catch (Exception e) {
					%>
					<tr>
						<td colspan="8">Error loading data</td>
					</tr>
					<%
					}
					%>

				</tbody>
			</table>
		</div>

	</div>

</body>
</html>