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
import java.sql.ResultSet;


import com.hospital.doa.DBConnection;

/**
 * Servlet implementation class OtpServlet
 */
@WebServlet("/OTPServlet")
public class OTPServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public OTPServlet() {
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

		String action = request.getParameter("action");

		if ("verify".equals(action)) {

			String enteredOtp = request.getParameter("otp");
			HttpSession session = request.getSession(false);

			if (session == null || session.getAttribute("email") == null) {
				response.sendRedirect("register.jsp");
				return;
			}

			String email = (String) session.getAttribute("email");

			try (Connection con = DBConnection.getConnection()) {

				PreparedStatement ps = con.prepareStatement("SELECT otp FROM users WHERE email=?");

				ps.setString(1, email);
				ResultSet rs = ps.executeQuery();

				if (rs.next()) {

					String dbOtp = rs.getString("otp");

					if (enteredOtp.equals(dbOtp)) {

						// Update OTP status
						PreparedStatement updatePs = con
								.prepareStatement("UPDATE users SET otp_status='Verified' WHERE email=?");

						updatePs.setString(1, email);
						updatePs.executeUpdate();

						// Remove email from session
						session.removeAttribute("email");

						response.sendRedirect("login.jsp?msg=OTP Verified Successfully");

					} else {
						response.sendRedirect("otp.jsp?msg=Invalid OTP");
					}

				} else {
					response.sendRedirect("register.jsp");
				}

			} catch (Exception e) {
				e.printStackTrace();
				response.sendRedirect("error.jsp?msg=Server Error");
			}
		}
	}

}
