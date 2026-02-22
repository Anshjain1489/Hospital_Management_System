<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.hospital.doa.DBConnection"%>

<%
if (session.getAttribute("user") == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Patients</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
</head>

<body class="bg-light">

	<div class="container mt-5">

		<h3>Patient Management</h3>

		<!-- ADD PATIENT FORM -->
		<form action="PatientServlet" method="post" class="row g-2 mb-4">

			<input type="hidden" name="action" value="insert">

			<div class="col">
				<input type="text" name="name" class="form-control"
					placeholder="Name" required>
			</div>

			<div class="col">
				<input type="number" name="age" class="form-control"
					placeholder="Age" required>
			</div>

			<div class="col">
				<input type="text" name="gender" class="form-control"
					placeholder="Gender" required>
			</div>

			<div class="col">
				<input type="text" name="mobile" class="form-control"
					placeholder="Mobile" required>
			</div>

			<div class="col">
				<button class="btn btn-primary">Add</button>
			</div>

		</form>

		<!-- PATIENT TABLE -->
		<table class="table table-bordered bg-white">
			<tr>
				<th>ID</th>
				<th>Name</th>
				<th>Age</th>
				<th>Gender</th>
				<th>Mobile</th>
				<th>Action</th>
			</tr>

			<%
			Connection con = DBConnection.getConnection();
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM patients");

			while (rs.next()) {
			%>

			<tr>
				<td><%=rs.getInt("patient_id")%></td>
				<td><%=rs.getString("name")%></td>
				<td><%=rs.getInt("age")%></td>
				<td><%=rs.getString("gender")%></td>
				<td><%=rs.getString("mobile")%></td>
				<td><a
					href="PatientServlet?action=delete&id=<%=rs.getInt("patient_id")%>"
					class="btn btn-danger btn-sm">Delete</a></td>
			</tr>

			<%
			}
			con.close();
			%>

		</table>

		<a href="dashboard.jsp" class="btn btn-secondary">Back</a>

	</div>

</body>
</html>