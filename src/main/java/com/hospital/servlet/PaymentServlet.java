package com.hospital.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.hospital.doa.DBConnection;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement psPayment = null;
        PreparedStatement psAppointment = null;

        try {

            int appointmentId = Integer.parseInt(
                    request.getParameter("appointment_id"));

            String razorpayPaymentId =
                    request.getParameter("payment_id");

            double amount = Double.parseDouble(
                    request.getParameter("amount"));

            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Transaction Start

            // 1️⃣ Insert into payments table
            psPayment = con.prepareStatement(
                    "INSERT INTO payments (appointment_id, razorpay_payment_id, amount, payment_status) VALUES (?, ?, ?, ?)"
            );

            psPayment.setInt(1, appointmentId);
            psPayment.setString(2, razorpayPaymentId);
            psPayment.setDouble(3, amount);
            psPayment.setString(4, "Paid");

            psPayment.executeUpdate();

            // 2️⃣ Update appointments table
            psAppointment = con.prepareStatement(
                    "UPDATE appointments SET payment_status='Paid', payment_id=? WHERE appointment_id=?"
            );

            psAppointment.setString(1, razorpayPaymentId);
            psAppointment.setInt(2, appointmentId);

            psAppointment.executeUpdate();

            con.commit(); // Transaction Commit

            response.sendRedirect("paymentSuccess.jsp");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            response.sendRedirect("error.jsp");

        } finally {
            try {
                if (psPayment != null) psPayment.close();
                if (psAppointment != null) psAppointment.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}