package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Authorization Filter - checks user roles for access control.
 * Uses the role attribute set by AuthenticationFilter.
 */
public class AuthorizationFilter implements Filter {

    private String allowedRole;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Read the allowed role from filter config (set in web.xml)
        allowedRole = filterConfig.getInitParameter("allowedRole");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // TODO: [TEST ONLY] - Bypass authorization để test UI, bỏ comment block này khi deploy thật
        chain.doFilter(request, response);
        /*
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String userRole = (String) httpRequest.getAttribute("userRole");

        if (userRole == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // ADMIN has access to everything
        if ("ADMIN".equals(userRole)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user's role matches the allowed role
        if (allowedRole != null && !allowedRole.isEmpty() && !allowedRole.equals(userRole)) {
            // Access denied
            httpRequest.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này");
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        chain.doFilter(request, response);
        */
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
