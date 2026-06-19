package com.hospital.servlet;

import com.hospital.dao.PatientDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/PatientServlet")
public class PatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PatientDAO.delete(id);
                response.sendRedirect("patients.jsp?msg=Patient+deleted&type=success");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patients.jsp?msg=Delete+failed&type=danger");
            return;
        }
        response.sendRedirect("patients.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                String name   = request.getParameter("name");
                String ageStr = request.getParameter("age");
                String gender = request.getParameter("gender");
                String mobile = request.getParameter("mobile");

                // Validation
                if (name == null || name.isBlank() || ageStr == null || ageStr.isBlank()
                        || gender == null || gender.isBlank() || mobile == null || mobile.isBlank()) {
                    response.sendRedirect("patients.jsp?msg=All+fields+required&type=warning");
                    return;
                }
                int age = Integer.parseInt(ageStr);
                if (age < 0 || age > 150) {
                    response.sendRedirect("patients.jsp?msg=Invalid+age&type=warning");
                    return;
                }
                if (!mobile.matches("\\d{10}")) {
                    response.sendRedirect("patients.jsp?msg=Mobile+must+be+10+digits&type=warning");
                    return;
                }

                PatientDAO.insert(name, age, gender, mobile);
                response.sendRedirect("patients.jsp?msg=Patient+added+successfully&type=success");

            } else if ("update".equals(action)) {
                int id    = Integer.parseInt(request.getParameter("id"));
                String name   = request.getParameter("name");
                int age       = Integer.parseInt(request.getParameter("age"));
                String gender = request.getParameter("gender");
                String mobile = request.getParameter("mobile");
                PatientDAO.update(id, name, age, gender, mobile);
                response.sendRedirect("patients.jsp?msg=Patient+updated&type=success");

            } else {
                response.sendRedirect("patients.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patients.jsp?msg=Error:+" + e.getMessage() + "&type=danger");
        }
    }
}