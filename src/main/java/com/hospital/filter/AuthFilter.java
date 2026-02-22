package com.hospital.filter;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

@WebFilter("/*")
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();

        // Allow public pages without login
        if (uri.endsWith("index.jsp") ||
            uri.endsWith("login.jsp") ||
            uri.endsWith("register.jsp") ||
            uri.endsWith("otp.jsp") ||
            uri.contains("LoginServlet") ||
            uri.contains("RegisterServlet") ||
            uri.contains("OTPServlet") ||
            uri.contains("css") ||
            uri.contains("js") ||
            uri.contains("images")) {

            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(req, res);
        } else {
        	response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}