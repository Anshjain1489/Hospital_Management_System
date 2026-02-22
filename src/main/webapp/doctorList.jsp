<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.hospital.doa.DBConnection"%>
<!DOCTYPE html>
<html>
<head>
<title>Doctor List</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>

	<h2>Doctor List</h2>

	<table>
		<tr>
			<th>ID</th>
			<th>Name</th>
			<th>Mobile</th>
			<th>Specialization</th>
		</tr>

		<%
		Connection con = DBConnection.getConnection();
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery("SELECT * FROM doctors");

		while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getInt("doctor_id")%></td>
			<td><%=rs.getString("name")%></td>
			<td><%=rs.getString("mobile")%></td>
			<td><%=rs.getString("specialization")%></td>
		</tr>
		<%
		}
		%>

	</table>

	<br>
	<a href="dashboard.jsp" class="btn">Back</a>

</body>
</html>