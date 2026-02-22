<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>OTP Verification</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">

            <div class="card shadow p-4">

                <h4 class="text-center mb-4">OTP Verification</h4>

                <!-- Show Error Message -->
                <%
                    String msg = request.getParameter("msg");
                    if (msg != null) {
                %>
                    <div class="alert alert-danger">
                        <%= msg %>
                    </div>
                <%
                    }
                %>

                <form action="OTPServlet" method="post">

                    <input type="hidden" name="action" value="verify">

                    <div class="mb-3">
                        <label>Enter OTP</label>
                        <input type="text" name="otp"
                               class="form-control"
                               placeholder="6-digit OTP"
                               required>
                    </div>

                    <button type="submit"
                            class="btn btn-success w-100">
                        Verify OTP
                    </button>

                </form>

            </div>

        </div>
    </div>
</div>

</body>
</html>