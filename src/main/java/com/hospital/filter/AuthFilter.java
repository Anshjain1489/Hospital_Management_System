package com.hospital.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Global authentication filter — protects all routes except public pages.
 * Prevents cached page access after logout via cache-control headers.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_PAGES = new HashSet<>(Arrays.asList(
        "/index.jsp", "/login.jsp", "/register.jsp", "/otp.jsp", "/error.jsp"
    ));

    private static final Set<String> PUBLIC_SERVLETS = new HashSet<>(Arrays.asList(
        "/LoginServlet", "/RegisterServlet", "/OTPServlet"
    ));

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri  = request.getRequestURI();
        String path = uri.substring(request.getContextPath().length());

        // Always allow static resources
        if (path.startsWith("/css/") || path.startsWith("/js/")
                || path.startsWith("/images/") || path.startsWith("/WEB-INF/")) {
            chain.doFilter(req, res);
            return;
        }

        // Always allow public pages & servlets
        if (PUBLIC_PAGES.contains(path) || PUBLIC_SERVLETS.stream().anyMatch(path::startsWith)) {
            chain.doFilter(req, res);
            return;
        }

        // Check session
        HttpSession session = request.getSession(false);
        boolean loggedIn    = session != null && session.getAttribute("user") != null;

        if (loggedIn) {
            // Prevent browser cache of protected pages
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=Please+login+to+continue&type=warning");
        }
    }
}