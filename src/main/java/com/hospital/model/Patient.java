package com.hospital.model;

public class Patient {
    private int id;
    private String name;
    private int age;
    private String gender;
    private String mobile;
    private String address;
    private String disease;
    private String aadhaar;
    private int doctorId;

    public Patient() {}

    public Patient(int id, String name, int age, String gender, String mobile,
                   String address, String disease, String aadhaar, int doctorId) {
        this.id = id; this.name = name; this.age = age; this.gender = gender;
        this.mobile = mobile; this.address = address; this.disease = disease;
        this.aadhaar = aadhaar; this.doctorId = doctorId;
    }

    public int getId()           { return id; }
    public String getName()      { return name; }
    public int getAge()          { return age; }
    public String getGender()    { return gender; }
    public String getMobile()    { return mobile; }
    public String getAddress()   { return address; }
    public String getDisease()   { return disease; }
    public String getAadhaar()   { return aadhaar; }
    public int getDoctorId()     { return doctorId; }

    public void setId(int id)              { this.id = id; }
    public void setName(String name)       { this.name = name; }
    public void setAge(int age)            { this.age = age; }
    public void setGender(String gender)   { this.gender = gender; }
    public void setMobile(String mobile)   { this.mobile = mobile; }
    public void setAddress(String address) { this.address = address; }
    public void setDisease(String disease) { this.disease = disease; }
    public void setAadhaar(String aadhaar) { this.aadhaar = aadhaar; }
    public void setDoctorId(int doctorId)  { this.doctorId = doctorId; }
}
