function payNow(amount, appointmentId) {

    var options = {
        key: "rzp_test_SISFnrxfnddVs2",   // 🔁 Replace with your Razorpay Test Key
        amount: Math.round(amount * 100),  // Convert to paise (must be integer)
        currency: "INR",
        name: "Ansh Hospital",
        description: "Appointment Payment",
        image: "images/logo.png",

        handler: function (response) {

            // Send payment details to backend
            fetch("PaymentServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body:
                    "appointment_id=" + encodeURIComponent(appointmentId) +
                    "&payment_id=" + encodeURIComponent(response.razorpay_payment_id) +
                    "&amount=" + encodeURIComponent(amount)
            })
            .then(res => {
                if (res.ok) {
                    window.location.href = "paymentSuccess.jsp";
                } else {
                    window.location.href = "error.jsp";
                }
            })
            .catch(() => {
                window.location.href = "error.jsp";
            });
        },

        modal: {
            ondismiss: function () {
                alert("Payment cancelled.");
            }
        },

        theme: {
            color: "#0d6efd"
        }
    };

    var rzp = new Razorpay(options);
    rzp.open();
}