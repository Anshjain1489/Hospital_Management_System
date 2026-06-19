package com.hospital.servlet;

import com.hospital.dao.UserDAO;
import com.hospital.model.User;
import com.hospital.util.BCryptUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            response.sendRedirect("login.jsp?msg=Please+fill+all+fields&type=warning");
            return;
        }

        email    = email.trim();
        password = password.trim();

        try {
            User user = UserDAO.findByEmail(email);

            if (user == null) {
                response.sendRedirect("login.jsp?msg=No+account+found+with+this+email&type=danger");
                return;
            }

            if (!"Verified".equalsIgnoreCase(user.getOtpStatus())) {
                response.sendRedirect("login.jsp?msg=Please+verify+your+OTP+first&type=warning");
                return;
            }

            // Support both BCrypt hashes AND legacy plain-text passwords for migration
            boolean passwordOk;
            if (user.getPassword() != null && user.getPassword().startsWith("$2a$")) {
                passwordOk = BCryptUtil.checkPassword(password, user.getPassword());
            } else {
                passwordOk = password.equals(user.getPassword()); // legacy fallback
            }

            if (passwordOk) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user",    user.getName());
                session.setAttribute("user_id", user.getId());
                session.setAttribute("email",   user.getEmail());
                response.sendRedirect("DashboardServlet");
            } else {
                response.sendRedirect("login.jsp?msg=Invalid+email+or+password&type=danger");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?msg=Server+error.+Please+try+again&type=danger");
        }
    }
}