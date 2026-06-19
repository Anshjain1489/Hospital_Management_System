package com.hospital.dao;

import com.hospital.model.Patient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    public static List<Patient> getAll() throws Exception {
        List<Patient> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM patients ORDER BY patient_id DESC")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public static Patient getById(int id) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM patients WHERE patient_id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    public static List<Patient> search(String keyword) throws Exception {
        List<Patient> list = new ArrayList<>();
        String q = "%" + keyword + "%";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM patients WHERE name LIKE ? OR mobile LIKE ? OR gender LIKE ? ORDER BY patient_id DESC")) {
            ps.setString(1, q); ps.setString(2, q); ps.setString(3, q);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public static void insert(String name, int age, String gender, String mobile) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO patients(name, age, gender, mobile) VALUES(?,?,?,?)")) {
            ps.setString(1, name.trim());
            ps.setInt(2, age);
            ps.setString(3, gender.trim());
            ps.setString(4, mobile.trim());
            ps.executeUpdate();
        }
    }

    public static void update(int id, String name, int age, String gender, String mobile) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE patients SET name=?, age=?, gender=?, mobile=? WHERE patient_id=?")) {
            ps.setString(1, name.trim()); ps.setInt(2, age);
            ps.setString(3, gender.trim()); ps.setString(4, mobile.trim());
            ps.setInt(5, id);
            ps.executeUpdate();
        }
    }

    public static void delete(int id) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "DELETE FROM patients WHERE patient_id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public static int count() throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM patients")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    private static Patient map(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setId(rs.getInt("patient_id"));
        p.setName(rs.getString("name"));
        p.setAge(rs.getInt("age"));
        p.setGender(rs.getString("gender"));
        p.setMobile(rs.getString("mobile"));
        // optional columns — safe fallback
        try { p.setAddress(rs.getString("address")); } catch (Exception ignored) {}
        try { p.setDisease(rs.getString("disease")); } catch (Exception ignored) {}
        return p;
    }
}
