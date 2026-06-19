package com.hospital.dao;

import com.hospital.model.Doctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {

    public static List<Doctor> getAll() throws Exception {
        List<Doctor> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM doctors ORDER BY doctor_id DESC")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public static List<Doctor> getFirst3() throws Exception {
        List<Doctor> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM doctors LIMIT 3")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public static Doctor getById(int id) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM doctors WHERE doctor_id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    public static List<Doctor> search(String keyword) throws Exception {
        List<Doctor> list = new ArrayList<>();
        String q = "%" + keyword + "%";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM doctors WHERE name LIKE ? OR specialization LIKE ? ORDER BY doctor_id DESC")) {
            ps.setString(1, q); ps.setString(2, q);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public static void insert(String name, String specialization, String mobile,
                              String email, double fees, String imageName) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO doctors(name, specialization, mobile, email, fees, image) VALUES(?,?,?,?,?,?)")) {
            ps.setString(1, name); ps.setString(2, specialization);
            ps.setString(3, mobile); ps.setString(4, email);
            ps.setDouble(5, fees); ps.setString(6, imageName);
            ps.executeUpdate();
        }
    }

    public static void delete(int id) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "DELETE FROM doctors WHERE doctor_id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public static int count() throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM doctors")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    private static Doctor map(ResultSet rs) throws SQLException {
        Doctor d = new Doctor();
        d.setId(rs.getInt("doctor_id"));
        d.setName(rs.getString("name"));
        d.setSpecialization(rs.getString("specialization"));
        d.setMobile(rs.getString("mobile"));
        d.setEmail(rs.getString("email"));
        d.setFees(rs.getDouble("fees"));
        d.setImage(rs.getString("image"));
        return d;
    }
}
