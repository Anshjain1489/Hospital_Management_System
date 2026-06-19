package com.hospital.model;

public class Doctor {
    private int id;
    private String name;
    private String specialization;
    private String mobile;
    private String email;
    private double fees;
    private String image;

    public Doctor() {}

    public Doctor(int id, String name, String specialization, String mobile,
                  String email, double fees, String image) {
        this.id = id; this.name = name; this.specialization = specialization;
        this.mobile = mobile; this.email = email; this.fees = fees; this.image = image;
    }

    public int getId()                 { return id; }
    public String getName()            { return name; }
    public String getSpecialization()  { return specialization; }
    public String getMobile()          { return mobile; }
    public String getEmail()           { return email; }
    public double getFees()            { return fees; }
    public String getImage()           { return image; }

    public void setId(int id)                        { this.id = id; }
    public void setName(String name)                 { this.name = name; }
    public void setSpecialization(String s)          { this.specialization = s; }
    public void setMobile(String mobile)             { this.mobile = mobile; }
    public void setEmail(String email)               { this.email = email; }
    public void setFees(double fees)                 { this.fees = fees; }
    public void setImage(String image)               { this.image = image; }
}
