<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.hospital.doa.DBConnection"%>
<%
String id = request.getParameter("id");
int doctorId = Integer.parseInt(id);

String name = "";
String specialization = "";
double fees = 0;
String phone = "";

try {
	Connection con = DBConnection.getConnection();
	PreparedStatement ps = con.prepareStatement("SELECT * FROM doctors WHERE doctor_id=?");
	ps.setInt(1, doctorId);
	ResultSet rs = ps.executeQuery();

	if (rs.next()) {
		name = rs.getString("name");
		specialization = rs.getString("specialization");
		fees = rs.getDouble("fees");
		phone = rs.getString("phone");
	}
	con.close();
} catch (Exception e) {
	out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Doctor</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">

<style>
body {
	background: #f4f6f9;
}

.card {
	border-radius: 15px;
}
</style>

</head>
<body>

	<div class="container mt-5 col-md-6">

		<div class="card shadow p-4">
			<h3 class="text-center mb-4">✏ Edit Doctor</h3>

			<form action="DoctorServlet" method="post">
				<input type="hidden" name="action" value="update"> <input
					type="hidden" name="doctor_id" value="<%=doctorId%>">

				<div class="mb-3">
					<label class="form-label">Doctor Name</label> <input type="text"
						name="name" value="<%=name%>" class="form-control" required>
				</div>

				<div class="mb-3">
					<label class="form-label">Specialization</label> <input type="text"
						name="specialization" value="<%=specialization%>"
						class="form-control" required>
				</div>

				<div class="mb-3">
					<label class="form-label">Consultation Fees</label> <input
						type="number" step="0.01" name="fees" value="<%=fees%>"
						class="form-control" required>
				</div>

				<div class="mb-3">
					<label class="form-label">Phone Number</label> <input type="text"
						name="phone" value="<%=phone%>" class="form-control" required>
				</div>

				<div class="d-flex justify-content-between">
					<a href="doctors.jsp" class="btn btn-secondary">⬅ Back</a>
					<button class="btn btn-success">Update Doctor</button>
				</div>

			</form>
		</div>

	</div>

</body>
</html>