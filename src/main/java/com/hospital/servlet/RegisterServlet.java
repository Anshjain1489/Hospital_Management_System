package com.hospital.servlet;

import com.hospital.dao.UserDAO;
import com.hospital.util.BCryptUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // --- Server-side validation ---
        if (name == null || name.isBlank() || email == null || email.isBlank()
                || password == null || password.isBlank()) {
            response.sendRedirect("register.jsp?msg=All+fields+are+required&type=warning");
            return;
        }
        if (password.length() < 6) {
            response.sendRedirect("register.jsp?msg=Password+must+be+at+least+6+characters&type=warning");
            return;
        }
        if (!email.matches("^[\\w.%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$")) {
            response.sendRedirect("register.jsp?msg=Invalid+email+format&type=warning");
            return;
        }

        name = name.trim(); email = email.trim();

        try {
            if (UserDAO.emailExists(email)) {
                response.sendRedirect("register.jsp?msg=Email+already+registered&type=danger");
                return;
            }

            // Hash password with BCrypt
            String hashedPassword = BCryptUtil.hashPassword(password);

            // Generate 6-digit OTP
            String otp = String.valueOf(100000 + new java.security.SecureRandom().nextInt(900000));

            UserDAO.insert(name, email, hashedPassword, otp);

            // Store email in session for OTP verification
            HttpSession session = request.getSession(true);
            session.setAttribute("pendingEmail", email);
            session.setAttribute("pendingName", name);

            // In production: email the OTP. For now, log to console for testing.
            System.out.println("=== OTP for " + email + ": " + otp + " ===");

            response.sendRedirect("otp.jsp?msg=OTP+sent+to+console+(check+Tomcat+logs)&type=info");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?msg=Registration+failed.+Try+again&type=danger");
        }
    }
}
