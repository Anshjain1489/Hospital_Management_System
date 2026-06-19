/**
 * Razorpay Payment Handler
 * Reads key from a data attribute to avoid hardcoding in JS
 */
function payNow(amount, appointmentId) {

    // Key is set via a meta tag in header.jsp to avoid hardcoding in JS
    const keyMeta = document.querySelector('meta[name="rzp-key"]');
    const key = keyMeta ? keyMeta.getAttribute('content') : 'rzp_test_SISFnrxfnddVs2';

    const options = {
        key:         key,
        amount:      Math.round(amount * 100), // Convert to paise (integer)
        currency:    'INR',
        name:        'Ansh Hospital',
        description: 'Appointment Payment #' + appointmentId,
        image:       'images/logo.png',

        handler: function (response) {
            // Send payment details to backend via POST
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'PaymentServlet';

            const fields = {
                appointment_id: appointmentId,
                payment_id:     response.razorpay_payment_id,
                amount:         amount
            };

            Object.entries(fields).forEach(([name, value]) => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            });

            document.body.appendChild(form);
            form.submit();
        },

        prefill: {
            name:  'Patient',
            email: 'patient@hospital.com'
        },

        modal: {
            ondismiss: function () {
                if (typeof showToast === 'function') {
                    showToast('Payment was cancelled.', 'warning');
                } else {
                    alert('Payment cancelled.');
                }
            }
        },

        theme: { color: '#4f46e5' }
    };

    try {
        const rzp = new Razorpay(options);
        rzp.on('payment.failed', function(response) {
            if (typeof showToast === 'function') {
                showToast('Payment failed: ' + response.error.description, 'danger');
            }
        });
        rzp.open();
    } catch (e) {
        alert('Payment gateway error. Please try again.');
        console.error(e);
    }
}