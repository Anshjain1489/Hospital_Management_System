package com.hospital.payment;

import com.razorpay.RazorpayClient;

public class RazorpayUtil {

	public static final String KEY_ID = "rzp_test_SISFnrxfnddVs2";
    public static final String KEY_SECRET = "Mij2LLlDM3vW6XDsmsKNOyWw";


    public static RazorpayClient getClient() throws Exception {
        return new RazorpayClient(KEY_ID, KEY_SECRET);
    }
}