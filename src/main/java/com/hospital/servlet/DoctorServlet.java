package com.hospital.servlet;

import com.hospital.dao.DoctorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/DoctorServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB max
public class DoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                String name           = request.getParameter("name");
                String specialization = request.getParameter("specialization");
                String mobile         = request.getParameter("phone");
                String email          = request.getParameter("email");
                String feesStr        = request.getParameter("fees");

                // Validation
                if (name == null || name.isBlank() || specialization == null || specialization.isBlank()
                        || mobile == null || mobile.isBlank() || feesStr == null || feesStr.isBlank()) {
                    response.sendRedirect("doctors.jsp?msg=All+fields+required&type=warning");
                    return;
                }
                double fees = Double.parseDouble(feesStr);

                // Image upload
                Part filePart  = request.getPart("image");
                String fileName = "default.png";
                if (filePart != null && filePart.getSize() > 0) {
                    String original = filePart.getSubmittedFileName();
                    String ext = original.substring(original.lastIndexOf('.'));
                    // Sanitize filename
                    fileName = System.currentTimeMillis() + ext;
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                    new File(uploadPath).mkdirs();
                    filePart.write(uploadPath + File.separator + fileName);
                }

                DoctorDAO.insert(name.trim(), specialization.trim(), mobile.trim(),
                                 email == null ? "" : email.trim(), fees, fileName);
                response.sendRedirect("doctors.jsp?msg=Doctor+added+successfully&type=success");

            } else {
                response.sendRedirect("doctors.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctors.jsp?msg=Error:+" + e.getMessage() + "&type=danger");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                DoctorDAO.delete(id);
                response.sendRedirect("doctors.jsp?msg=Doctor+deleted&type=success");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("doctors.jsp");
    }
}