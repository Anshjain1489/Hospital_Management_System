package com.hospital.model;

public class User {
    private int id;
    private String name;
    private String email;
    private String password; // BCrypt hash
    private String otp;
    private String otpStatus; // Pending / Verified

    public User() {}

    public int getId()            { return id; }
    public String getName()       { return name; }
    public String getEmail()      { return email; }
    public String getPassword()   { return password; }
    public String getOtp()        { return otp; }
    public String getOtpStatus()  { return otpStatus; }

    public void setId(int id)              { this.id = id; }
    public void setName(String name)       { this.name = name; }
    public void setEmail(String email)     { this.email = email; }
    public void setPassword(String pw)     { this.password = pw; }
    public void setOtp(String otp)         { this.otp = otp; }
    public void setOtpStatus(String s)     { this.otpStatus = s; }
}
