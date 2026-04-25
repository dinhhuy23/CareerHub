package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import utils.JWTUtil;
import java.io.IOException;

/**
 * Authentication Filter - validates JWT token for protected resources.
 * Applied to /user/* URL pattern.
 */
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if JWT token exists in session
        String token = null;
        if (session != null) {
            token = (String) session.getAttribute("jwtToken");
        }

        if (token == null || token.isEmpty()) {
            // No token - redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Validate token
        JSONObject claims = JWTUtil.validateToken(token);
        if (claims == null) {
            // Invalid or expired token - clear session and redirect
            if (session != null) {
                session.invalidate();
            }
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=session_expired");
            return;
        }

        // Token is valid - set user attributes in request for controllers to use
        httpRequest.setAttribute("userId", claims.getLong("userId"));
        httpRequest.setAttribute("userEmail", claims.getString("email"));
        httpRequest.setAttribute("userFullName", claims.getString("fullName"));
        httpRequest.setAttribute("userRole", claims.getString("role"));

        // Continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}