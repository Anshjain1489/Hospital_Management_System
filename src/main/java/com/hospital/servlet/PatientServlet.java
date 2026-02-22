package com.hospital.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.hospital.doa.DBConnection;

@WebServlet("/PatientServlet")
public class PatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {

            if ("delete".equals(action)) {

                int id = Integer.parseInt(request.getParameter("id"));

                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM patients WHERE patient_id=?");

                ps.setInt(1, id);
                ps.executeUpdate();
            }

            response.sendRedirect("patients.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {

            if ("insert".equals(action)) {

                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO patients(name, age, gender, mobile) VALUES(?,?,?,?)");

                ps.setString(1, request.getParameter("name"));
                ps.setInt(2, Integer.parseInt(request.getParameter("age")));
                ps.setString(3, request.getParameter("gender"));
                ps.setString(4, request.getParameter("mobile"));

                ps.executeUpdate();
            }

            response.sendRedirect("patients.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}