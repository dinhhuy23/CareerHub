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

    private String[] allowedRolesArray;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Read the allowed roles from filter config (set in web.xml)
        String rolesParam = filterConfig.getInitParameter("allowedRoles");
        if (rolesParam != null && !rolesParam.trim().isEmpty()) {
            // Split by comma and remove spaces
            allowedRolesArray = rolesParam.split("\\s*,\\s*");
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

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

        // Check if user's role matches any of the allowed roles
        if (allowedRolesArray != null && allowedRolesArray.length > 0) {
            boolean hasAccess = false;
            for (String r : allowedRolesArray) {
                if (r.equals(userRole)) {
                    hasAccess = true;
                    break;
                }
            }
            if (!hasAccess) {
                // Access denied
                httpRequest.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này. Yêu cầu quyền: " + String.join(", ", allowedRolesArray));
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
