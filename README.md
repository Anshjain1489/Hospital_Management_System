# 🏥 Ansh Hospital Management System

<div align="center">

![Java](https://img.shields.io/badge/Java-21-orange?style=flat-square&logo=java)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-6.0-blue?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=flat-square&logo=mysql)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple?style=flat-square&logo=bootstrap)
![Tomcat](https://img.shields.io/badge/Tomcat-11.0-yellow?style=flat-square)
![Razorpay](https://img.shields.io/badge/Razorpay-Integrated-02042B?style=flat-square)

**A full-stack Hospital Management System built with Java Servlets, JSP, and MySQL.**

</div>

---

## 🌟 Features

| Feature | Description |
|---|---|
| 🔐 **Secure Authentication** | OTP email verification + BCrypt password hashing |
| 👨‍⚕️ **Patient Management** | Add, view, search, and delete patient records |
| 🩺 **Doctor Management** | Add doctors with photo upload, specialization, fees |
| 📅 **Appointment Booking** | Schedule appointments with status tracking (Pending/Confirmed/Cancelled) |
| 💰 **Razorpay Payments** | Online payment gateway with transactional safety |
| 📄 **PDF Invoice** | Professional iTextPDF invoice generation with GST |
| 📝 **Prescription Generator** | Dynamic prescription with print/PDF export |
| 📊 **Analytics Dashboard** | Chart.js monthly appointment & revenue charts |
| 🌙 **Dark Mode** | Persistent across all pages via localStorage |
| 📱 **Responsive Design** | Mobile-friendly with hamburger sidebar |
| 🔍 **Live Search** | Real-time table filtering on all pages |

---

## 🛠️ Tech Stack

- **Backend:** Java 21, Jakarta Servlet 6.0, JSP
- **Database:** MySQL 8.0 (JDBC — no ORM)
- **Frontend:** Bootstrap 5.3, Chart.js, Vanilla CSS, Vanilla JS
- **Payment:** Razorpay Payment Gateway
- **PDF:** iTextPDF 5.5.13
- **Security:** BCrypt password hashing, AuthFilter, session management
- **Server:** Apache Tomcat 11.0

---

## 🚀 Getting Started

### Prerequisites
- Java JDK 21
- Apache Tomcat 11
- MySQL 8.0
- Eclipse IDE (Dynamic Web Project)

### 1. Clone the Repository
```bash
git clone https://github.com/Anshjain1489/Hospital_Management_System.git
```

### 2. Database Setup
```bash
mysql -u root -p < database.sql
```

### 3. Configure Credentials
Create `src/main/resources/db.properties` (excluded from Git):
```properties
db.url=jdbc:mysql://localhost:3306/hospital_db
db.user=root
db.password=YOUR_PASSWORD
razorpay.key_id=YOUR_RAZORPAY_KEY_ID
razorpay.key_secret=YOUR_RAZORPAY_SECRET
```

### 4. Run in Eclipse
1. Right-click project → **Run As → Run on Server** → Tomcat 11
2. Navigate to `http://localhost:8080/HospitalManagement/`

---

## 📸 Screenshots

| Page | Description |
|---|---|
| Landing Page | Premium hero with animated gradient, doctor cards |
| Login | Split-screen with hero panel |
| Dashboard | Stat cards + Chart.js analytics |
| Patients | Card table with search & avatar |
| Doctors | Grid card view with photo |
| Appointments | Status filter + inline status update |
| Invoice | Professional bill with QR code |
| Prescription | Dynamic generator with print support |

---

## 🏗️ Project Architecture (MVC)

```
com.hospital/
├── dao/          ← Data Access Objects (PatientDAO, DoctorDAO, AppointmentDAO, UserDAO)
├── model/        ← POJO Classes (Patient, Doctor, Appointment, User)
├── servlet/      ← Controller Layer (LoginServlet, PatientServlet, BillServlet...)
├── filter/       ← AuthFilter (protects all routes)
├── payment/      ← RazorpayUtil
└── util/         ← BCryptUtil (pure Java BCrypt)

webapp/
├── css/style.css       ← Premium design system (CSS variables, dark mode, animations)
├── js/payment.js       ← Razorpay handler
├── WEB-INF/
│   ├── header.jsp      ← Shared sidebar (included on all admin pages)
│   └── footer.jsp      ← Shared scripts (dark mode, toasts, live search)
├── dashboard.jsp       ← Analytics dashboard (data from DashboardServlet)
├── patients.jsp        ← Patient management
├── doctors.jsp         ← Doctor card grid
├── appointment.jsp     ← Appointments with status
├── bill.jsp            ← Invoice page
└── prescription.jsp    ← Prescription generator (NEW)
```

---

## 🔐 Security Features

- ✅ **BCrypt** password hashing (no plain-text passwords)
- ✅ **PreparedStatements** throughout (SQL injection prevention)
- ✅ **AuthFilter** protecting all admin routes
- ✅ **Session invalidation** on logout with cache-control headers
- ✅ **Server-side validation** on all form inputs
- ✅ **Credentials externalized** to `db.properties` (not in source code)
- ✅ **File upload sanitization** (timestamp-based filenames, size limits)

---

## 👨‍💻 Developer

**Ansh Jain** — BCA Student  
📧 anshjain1440@gmail.com  
📍 Gursarai, Jhansi, India  

---

## 📄 License

This project is open-source for educational purposes.
