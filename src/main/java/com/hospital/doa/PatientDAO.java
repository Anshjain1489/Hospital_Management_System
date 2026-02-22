package com.hospital.doa;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class PatientDAO {

    public static void addPatient(String name, int age, String gender,
                                  String address, String disease,
                                  String mobile, String aadhaar, int doctorId) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "INSERT INTO patients(name, age, gender, address, disease, mobile, aadhaar, doctor_id) VALUES(?,?,?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, age);
            ps.setString(3, gender);
            ps.setString(4, address);
            ps.setString(5, disease);
            ps.setString(6, mobile);
            ps.setString(7, aadhaar);
            ps.setInt(8, doctorId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}