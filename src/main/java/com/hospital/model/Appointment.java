package com.hospital.model;

import java.sql.Date;

public class Appointment {
    private int id;
    private int patientId;
    private int doctorId;
    private Date appointmentDate;
    private String status;        // Pending / Confirmed / Cancelled
    private String paymentStatus; // Unpaid / Paid
    private String paymentId;
    // Joined fields (from query)
    private String patientName;
    private String doctorName;

    public Appointment() {}

    public int getId()              { return id; }
    public int getPatientId()       { return patientId; }
    public int getDoctorId()        { return doctorId; }
    public Date getAppointmentDate(){ return appointmentDate; }
    public String getStatus()       { return status; }
    public String getPaymentStatus(){ return paymentStatus; }
    public String getPaymentId()    { return paymentId; }
    public String getPatientName()  { return patientName; }
    public String getDoctorName()   { return doctorName; }

    public void setId(int id)                      { this.id = id; }
    public void setPatientId(int patientId)        { this.patientId = patientId; }
    public void setDoctorId(int doctorId)          { this.doctorId = doctorId; }
    public void setAppointmentDate(Date d)         { this.appointmentDate = d; }
    public void setStatus(String status)           { this.status = status; }
    public void setPaymentStatus(String ps)        { this.paymentStatus = ps; }
    public void setPaymentId(String paymentId)     { this.paymentId = paymentId; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public void setDoctorName(String doctorName)   { this.doctorName = doctorName; }
}
