package com.hospital.servlet;

import com.hospital.dao.UserDAO;
import com.hospital.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/OTPServlet")
public class OTPServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("pendingEmail") == null) {
            response.sendRedirect("register.jsp?msg=Session+expired.+Register+again&type=warning");
            return;
        }

        String email = (String) session.getAttribute("pendingEmail");

        if (enteredOtp == null || enteredOtp.isBlank()) {
            response.sendRedirect("otp.jsp?msg=Please+enter+the+OTP&type=warning");
            return;
        }

        try {
            User user = UserDAO.findByEmail(email);

            if (user == null) {
                response.sendRedirect("register.jsp?msg=User+not+found.+Register+again&type=danger");
                return;
            }

            if (enteredOtp.trim().equals(user.getOtp())) {
                UserDAO.verifyOtp(email);
                session.removeAttribute("pendingEmail");
                session.removeAttribute("pendingName");
                response.sendRedirect("login.jsp?msg=Account+verified+successfully!+Please+login&type=success");
            } else {
                response.sendRedirect("otp.jsp?msg=Invalid+OTP.+Please+try+again&type=danger");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("otp.jsp?msg=Server+error&type=danger");
        }
    }
}
