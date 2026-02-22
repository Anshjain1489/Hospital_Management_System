package com.hospital.doa;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DoctorDAO {

    public static void addDoctor(String name, String mobile, String address, String specialization) {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO doctors(name, mobile, address, specialization) VALUES(?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, mobile);
            ps.setString(3, address);
            ps.setString(4, specialization);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static ResultSet getAllDoctors() {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM doctors";
            PreparedStatement ps = con.prepareStatement(sql);
            return ps.executeQuery();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}