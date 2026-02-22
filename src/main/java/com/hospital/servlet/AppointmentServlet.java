package com.hospital.servlet;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;

import com.hospital.doa.DBConnection;

/**
 * Servlet implementation class AppointmentServlet
 */
@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AppointmentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {

            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM appointments WHERE appointment_id=?");
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            response.sendRedirect("appointment.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {

            if ("insert".equals(action)) {

                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO appointments(patient_id, doctor_id, appointment_date) VALUES(?,?,?)");

                ps.setInt(1, Integer.parseInt(request.getParameter("patient_id")));
                ps.setInt(2, Integer.parseInt(request.getParameter("doctor_id")));
                ps.setDate(3, Date.valueOf(request.getParameter("appointment_date")));

                ps.executeUpdate();
            }

            if ("update".equals(action)) {

                PreparedStatement ps = con.prepareStatement(
                        "UPDATE appointments SET patient_id=?, doctor_id=?, appointment_date=? WHERE appointment_id=?");

                ps.setInt(1, Integer.parseInt(request.getParameter("patient_id")));
                ps.setInt(2, Integer.parseInt(request.getParameter("doctor_id")));
                ps.setDate(3, Date.valueOf(request.getParameter("appointment_date")));
                ps.setInt(4, Integer.parseInt(request.getParameter("appointment_id")));

                ps.executeUpdate();
            }

            response.sendRedirect("appointment.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
