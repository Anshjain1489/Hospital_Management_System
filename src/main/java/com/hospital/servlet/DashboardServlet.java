package com.hospital.servlet;

import com.hospital.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Fetches dashboard stats and forwards to dashboard.jsp — proper MVC controller.
 */
@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session guard
        if (request.getSession(false) == null || request.getSession(false).getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int totalPatients     = PatientDAO.count();
            int totalDoctors      = DoctorDAO.count();
            int totalAppointments = AppointmentDAO.count();
            double totalRevenue   = AppointmentDAO.totalRevenue();
            int[] monthly         = AppointmentDAO.monthlyCount();
            double[] revenue      = AppointmentDAO.monthlyRevenue();

            request.setAttribute("totalPatients",     totalPatients);
            request.setAttribute("totalDoctors",      totalDoctors);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("totalRevenue",      totalRevenue);
            request.setAttribute("monthlyData",       monthly);
            request.setAttribute("revenueData",       revenue);

            // Recent 5 appointments
            request.setAttribute("recentAppointments", AppointmentDAO.getAll());

            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=Dashboard+failed+to+load");
        }
    }
}
