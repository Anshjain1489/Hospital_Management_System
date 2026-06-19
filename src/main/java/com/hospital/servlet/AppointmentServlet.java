package com.hospital.servlet;

import com.hospital.dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                AppointmentDAO.delete(id);
                response.sendRedirect("appointment.jsp?msg=Appointment+deleted&type=success");
                return;
            }
            if ("status".equals(action)) {
                int id     = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("val");
                if (status != null && (status.equals("Confirmed") || status.equals("Cancelled") || status.equals("Pending"))) {
                    AppointmentDAO.updateStatus(id, status);
                }
                response.sendRedirect("appointment.jsp?msg=Status+updated&type=success");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("appointment.jsp?msg=Operation+failed&type=danger");
            return;
        }
        response.sendRedirect("appointment.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("insert".equals(action)) {
                int patientId = Integer.parseInt(request.getParameter("patient_id"));
                int doctorId  = Integer.parseInt(request.getParameter("doctor_id"));
                Date date     = Date.valueOf(request.getParameter("appointment_date"));
                AppointmentDAO.insert(patientId, doctorId, date);
                response.sendRedirect("appointment.jsp?msg=Appointment+booked&type=success");

            } else if ("update".equals(action)) {
                int id        = Integer.parseInt(request.getParameter("appointment_id"));
                int patientId = Integer.parseInt(request.getParameter("patient_id"));
                int doctorId  = Integer.parseInt(request.getParameter("doctor_id"));
                Date date     = Date.valueOf(request.getParameter("appointment_date"));
                AppointmentDAO.update(id, patientId, doctorId, date);
                response.sendRedirect("appointment.jsp?msg=Appointment+updated&type=success");

            } else {
                response.sendRedirect("appointment.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("appointment.jsp?msg=Error:+" + e.getMessage() + "&type=danger");
        }
    }
}
