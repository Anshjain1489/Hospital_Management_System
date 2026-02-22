<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.hospital.doa.DBConnection"%>
<%
int id = Integer.parseInt(request.getParameter("id"));
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM patients WHERE patient_id=?");
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();
rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Patient</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
	<link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

	<div class="container mt-5">
		<form action="PatientServlet" method="post">
			<input type="hidden" name="action" value="update"> <input
				type="hidden" name="id" value="<%=id%>"> <input type="text"
				name="name" value="<%=rs.getString("name")%>"
				class="form-control mb-3"> <input type="number" name="age"
				value="<%=rs.getInt("age")%>" class="form-control mb-3"> <input
				type="text" name="gender" value="<%=rs.getString("gender")%>"
				class="form-control mb-3"> <input type="text" name="phone"
				value="<%=rs.getString("phone")%>" class="form-control mb-3">
			<input type="text" name="disease"
				value="<%=rs.getString("disease")%>" class="form-control mb-3">

			<button class="btn btn-success">Update</button>
		</form>
	</div>
</body>
</html>