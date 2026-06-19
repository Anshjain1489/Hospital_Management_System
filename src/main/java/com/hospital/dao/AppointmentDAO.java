package com.hospital.dao;

import com.hospital.model.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    private static final String JOIN_SQL =
        "SELECT a.*, p.name AS patient_name, d.name AS doctor_name " +
        "FROM appointments a " +
        "JOIN patients p ON a.patient_id = p.patient_id " +
        "JOIN doctors  d ON a.doctor_id  = d.doctor_id ";

    public static List<Appointment> getAll() throws Exception {
        List<Appointment> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 JOIN_SQL + "ORDER BY a.appointment_id DESC")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public static List<Appointment> getByStatus(String status) throws Exception {
        List<Appointment> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 JOIN_SQL + "WHERE a.status=? ORDER BY a.appointment_id DESC")) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public static Appointment getById(int id) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 JOIN_SQL + "WHERE a.appointment_id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    public static void insert(int patientId, int doctorId, Date date) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO appointments(patient_id, doctor_id, appointment_date, status, payment_status) VALUES(?,?,?,?,?)")) {
            ps.setInt(1, patientId); ps.setInt(2, doctorId);
            ps.setDate(3, date);
            ps.setString(4, "Pending");
            ps.setString(5, "Unpaid");
            ps.executeUpdate();
        }
    }

    public static void update(int id, int patientId, int doctorId, Date date) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE appointments SET patient_id=?, doctor_id=?, appointment_date=? WHERE appointment_id=?")) {
            ps.setInt(1, patientId); ps.setInt(2, doctorId);
            ps.setDate(3, date); ps.setInt(4, id);
            ps.executeUpdate();
        }
    }

    public static void updateStatus(int id, String status) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE appointments SET status=? WHERE appointment_id=?")) {
            ps.setString(1, status); ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public static void delete(int id) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "DELETE FROM appointments WHERE appointment_id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public static int count() throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM appointments")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public static double totalRevenue() throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT IFNULL(SUM(amount),0) FROM payments WHERE payment_status='Paid'")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }

    /** Monthly appointment counts for the current year (for Chart.js) */
    public static int[] monthlyCount() throws Exception {
        int[] counts = new int[12];
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT MONTH(appointment_date) AS m, COUNT(*) AS c " +
                 "FROM appointments WHERE YEAR(appointment_date)=YEAR(CURDATE()) GROUP BY m")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) counts[rs.getInt("m") - 1] = rs.getInt("c");
        }
        return counts;
    }

    /** Monthly revenue for the current year (for Chart.js) */
    public static double[] monthlyRevenue() throws Exception {
        double[] revenue = new double[12];
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT MONTH(payment_date) AS m, SUM(amount) AS r " +
                 "FROM payments WHERE payment_status='Paid' AND YEAR(payment_date)=YEAR(CURDATE()) GROUP BY m")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) revenue[rs.getInt("m") - 1] = rs.getDouble("r");
        }
        return revenue;
    }

    private static Appointment map(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setId(rs.getInt("appointment_id"));
        a.setPatientId(rs.getInt("patient_id"));
        a.setDoctorId(rs.getInt("doctor_id"));
        a.setAppointmentDate(rs.getDate("appointment_date"));
        a.setPatientName(rs.getString("patient_name"));
        a.setDoctorName(rs.getString("doctor_name"));
        try { a.setStatus(rs.getString("status")); } catch (Exception e) { a.setStatus("Pending"); }
        try { a.setPaymentStatus(rs.getString("payment_status")); } catch (Exception e) { a.setPaymentStatus("Unpaid"); }
        try { a.setPaymentId(rs.getString("payment_id")); } catch (Exception ignored) {}
        return a;
    }
}
