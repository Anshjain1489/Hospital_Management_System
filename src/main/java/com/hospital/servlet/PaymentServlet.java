package com.hospital.servlet;

import com.hospital.dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.hospital.dao.DBConnection;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement psPayment     = null;
        PreparedStatement psAppointment = null;

        try {
            int    appointmentId      = Integer.parseInt(request.getParameter("appointment_id"));
            String razorpayPaymentId  = request.getParameter("payment_id");
            double amount             = Double.parseDouble(request.getParameter("amount"));

            if (razorpayPaymentId == null || razorpayPaymentId.isBlank()) {
                response.sendRedirect("error.jsp?msg=Invalid+payment+reference");
                return;
            }

            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Begin transaction

            // 1. Insert payment record
            psPayment = con.prepareStatement(
                "INSERT INTO payments(appointment_id, razorpay_payment_id, amount, payment_status) VALUES(?,?,?,?)");
            psPayment.setInt(1,    appointmentId);
            psPayment.setString(2, razorpayPaymentId);
            psPayment.setDouble(3, amount);
            psPayment.setString(4, "Paid");
            psPayment.executeUpdate();

            // 2. Update appointment payment status
            psAppointment = con.prepareStatement(
                "UPDATE appointments SET payment_status='Paid', payment_id=?, status='Confirmed' WHERE appointment_id=?");
            psAppointment.setString(1, razorpayPaymentId);
            psAppointment.setInt(2,    appointmentId);
            psAppointment.executeUpdate();

            con.commit(); // Commit transaction
            response.sendRedirect("paymentSuccess.jsp?id=" + appointmentId);

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=Payment+processing+failed");

        } finally {
            try { if (psPayment     != null) psPayment.close();     } catch (Exception ignored) {}
            try { if (psAppointment != null) psAppointment.close(); } catch (Exception ignored) {}
            try { if (con           != null) con.close();           } catch (Exception ignored) {}
        }
    }
}