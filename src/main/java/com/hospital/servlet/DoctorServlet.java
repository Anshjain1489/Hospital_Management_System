package com.hospital.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.hospital.doa.DBConnection;

@WebServlet("/DoctorServlet")
@MultipartConfig
public class DoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {

            if ("insert".equals(action)) {

                String name = request.getParameter("name");
                String specialization = request.getParameter("specialization");
                String mobile = request.getParameter("phone");   // from form
                String email = request.getParameter("email");
                double fees = Double.parseDouble(request.getParameter("fees"));

                // ---------- Image Upload ----------
                Part filePart = request.getPart("image");
                String fileName = filePart.getSubmittedFileName();

                String uploadPath = getServletContext()
                        .getRealPath("") + File.separator + "images";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                filePart.write(uploadPath + File.separator + fileName);

                // ---------- Insert Into DB ----------
                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO doctors(name, specialization, mobile, email, fees, image) VALUES(?,?,?,?,?,?)"
                );

                ps.setString(1, name);
                ps.setString(2, specialization);
                ps.setString(3, mobile);
                ps.setString(4, email);
                ps.setDouble(5, fees);
                ps.setString(6, fileName);

                ps.executeUpdate();
            }

            response.sendRedirect("doctors.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {

            if ("delete".equals(action)) {

                int id = Integer.parseInt(request.getParameter("id"));

                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM doctors WHERE doctor_id=?"
                );

                ps.setInt(1, id);
                ps.executeUpdate();
            }

            response.sendRedirect("doctors.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}