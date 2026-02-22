<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.hospital.doa.DBConnection"%>
<!DOCTYPE html>
<html>
<head>
<title>Patient List</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<h2>Patient List</h2>

<table>
<tr>
<th>ID</th>
<th>Name</th>
<th>Age</th>
<th>Disease</th>
<th>Doctor Name</th>
</tr>

<%
Connection con = DBConnection.getConnection();
Statement st = con.createStatement();

ResultSet rs = st.executeQuery(
"SELECT p.*, d.name as doctorName FROM patients p JOIN doctors d ON p.doctor_id = d.doctor_id"
);

while(rs.next()){
%>
<tr>
<td><%= rs.getInt("patient_id") %></td>
<td><%= rs.getString("name") %></td>
<td><%= rs.getInt("age") %></td>
<td><%= rs.getString("disease") %></td>
<td>Dr. <%= rs.getString("doctorName") %></td>
</tr>
<% } %>

</table>

<br>
<a href="dashboard.jsp" class="btn">Back</a>

</body>
</html>