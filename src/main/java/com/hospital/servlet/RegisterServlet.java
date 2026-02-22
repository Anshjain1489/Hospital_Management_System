package com.hospital.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.hospital.doa.DBConnection;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RegisterServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String password = request.getParameter("password");

// Generate 6-digit OTP
		String otp = String.valueOf(new java.util.Random().nextInt(900000) + 100000);

		try (Connection con = DBConnection.getConnection()) {

			if (con == null) {
				response.sendRedirect("error.jsp?msg=Database Error");
				return;
			}

			PreparedStatement ps = con
					.prepareStatement("INSERT INTO users(name, email, password, otp, otp_status) VALUES(?,?,?,?,?)");

			ps.setString(1, name);
			ps.setString(2, email);
			ps.setString(3, password);
			ps.setString(4, otp);
			ps.setString(5, "Pending");

			ps.executeUpdate();

// Store email in session for OTP verification
			HttpSession session = request.getSession();
			session.setAttribute("email", email);

// Print OTP in console (for testing)
			System.out.println("Generated OTP: " + otp);

			response.sendRedirect("otp.jsp");

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("error.jsp?msg=Registration Failed");
		}
	}

}
