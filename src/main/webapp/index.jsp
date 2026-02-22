<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ansh Hospital</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	scroll-behavior: smooth;
}

.hero {
	background: linear-gradient(to right, #0d6efd, #0dcaf0);
	color: white;
	padding: 100px 0;
	text-align: center;
}

.section {
	padding: 70px 0;
}

.navbar {
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.dark-mode {
	background: #121212 !important;
	color: white !important;
}

.dark-mode .card {
	background: #1e1e1e;
	color: white;
}

.footer {
	background: #0d6efd;
	color: white;
	padding: 20px;
}
</style>

</head>
<body>

	<!-- ================= NAVBAR ================= -->
	<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top">
		<div class="container">
			<a class="navbar-brand fw-bold" href="#">🏥 Ansh Hospital</a>

			<div>
				<a href="#about" class="nav-link d-inline">About</a> <a
					href="#doctors" class="nav-link d-inline">Doctors</a> <a
					href="#services" class="nav-link d-inline">Services</a> <a
					href="#contact" class="nav-link d-inline">Contact</a> <a
					href="login.jsp" class="btn btn-primary btn-sm ms-3">Login</a>
				<button onclick="toggleDark()" class="btn btn-dark btn-sm ms-2">🌙</button>
			</div>
		</div>
	</nav>

	<!-- ================= HERO ================= -->
	<div class="hero">
		<div class="container">
			<h1>Welcome to Ansh Hospital</h1>
			<p>Advanced Healthcare | Trusted Doctors | Modern Technology</p>
			<a href="login.jsp" class="btn btn-light btn-lg mt-3">Get Started</a>
		</div>
	</div>

	<!-- ================= ABOUT ================= -->
	<div id="about" class="section container">
		<h2 class="text-center mb-4">About Our Hospital</h2>
		<p class="text-center">Ansh Hospital provides world-class
			healthcare services with experienced doctors, advanced equipment and
			24/7 emergency support.</p>
	</div>

	<!-- ================= DOCTORS PREVIEW ================= -->
	<div id="doctors" class="section bg-light">
		<div class="container">
			<h2 class="text-center mb-5">Our Specialist Doctors</h2>

			<div class="row">

				<%
				try {
					java.sql.Connection con = com.hospital.doa.DBConnection.getConnection();
					java.sql.Statement st = con.createStatement();
					java.sql.ResultSet rs = st.executeQuery("SELECT * FROM doctors LIMIT 3");

					while (rs.next()) {
				%>

				<div class="col-md-4 mb-4">
					<div class="card shadow text-center p-3">
						<img src="images/<%=rs.getString("image")%>"
							class="img-fluid rounded mb-3"
							style="height: 200px; object-fit: cover;">
						<h5><%=rs.getString("name")%></h5>
						<p><%=rs.getString("specialization")%></p>
					</div>
				</div>

				<%
				}
				con.close();
				} catch (Exception e) {
				out.println("Doctors not available");
				}
				%>

			</div>
		</div>
	</div>

	<!-- ================= SERVICES ================= -->
	<div id="services" class="section container">
		<h2 class="text-center mb-4">Our Services</h2>
		<div class="row text-center">
			<div class="col-md-3">❤️ Cardiology</div>
			<div class="col-md-3">🦴 Orthopedics</div>
			<div class="col-md-3">🧠 Neurology</div>
			<div class="col-md-3">🧪 Pathology</div>
		</div>
	</div>

	<!-- ================= CONTACT ================= -->
	<div id="contact" class="section bg-light">
		<div class="container text-center">
			<h2>Contact Us</h2>
			<p>Email: anshjain1440@gmail.com</p>
			<p>Phone: +91 9264974887</p>
			<p>Gursarai, India</p>
		</div>
	</div>

	<div class="footer text-center">© 2026 Ansh Hospital | Developed
		by Ansh Jain</div>

	<script>
		function toggleDark() {
			document.body.classList.toggle("dark-mode");
		}
	</script>

</body>
</html>