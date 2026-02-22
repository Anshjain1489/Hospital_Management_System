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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");
		String password = request.getParameter("password");

		if (email != null)
			email = email.trim();
		if (password != null)
			password = password.trim();

		try (Connection con = DBConnection.getConnection()) {

			if (con == null) {
				response.sendRedirect("login.jsp?msg=Database Error");
				return;
			}

			PreparedStatement ps = con
					.prepareStatement("SELECT user_id, name, otp_status FROM users WHERE email=? AND password=?");

			ps.setString(1, email);
			ps.setString(2, password);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				String otpStatus = rs.getString("otp_status");

				if ("Verified".equalsIgnoreCase(otpStatus)) {

					HttpSession session = request.getSession();
					session.setAttribute("user", rs.getString("name"));
					session.setAttribute("user_id", rs.getInt("user_id"));

					response.sendRedirect("dashboard.jsp");

				} else {
					response.sendRedirect("login.jsp?msg=Please verify OTP first");
				}

			} else {
				response.sendRedirect("login.jsp?msg=Invalid Email or Password");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("login.jsp?msg=Server Error");
		}
	}
}