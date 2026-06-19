package com.hospital.dao;

import com.hospital.model.User;
import java.sql.*;

public class UserDAO {

    public static User findByEmail(String email) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM users WHERE email=?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    public static void insert(String name, String email, String hashedPassword, String otp) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO users(name, email, password, otp, otp_status) VALUES(?,?,?,?,?)")) {
            ps.setString(1, name); ps.setString(2, email);
            ps.setString(3, hashedPassword); ps.setString(4, otp);
            ps.setString(5, "Pending");
            ps.executeUpdate();
        }
    }

    public static void verifyOtp(String email) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE users SET otp_status='Verified' WHERE email=?")) {
            ps.setString(1, email);
            ps.executeUpdate();
        }
    }

    public static boolean emailExists(String email) throws Exception {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT 1 FROM users WHERE email=?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    private static User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("user_id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setOtp(rs.getString("otp"));
        u.setOtpStatus(rs.getString("otp_status"));
        return u;
    }
}
