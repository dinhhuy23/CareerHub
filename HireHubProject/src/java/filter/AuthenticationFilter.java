package filter;

import dal.RefreshTokenDAO;
import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import model.RefreshToken;
import model.User;
import org.json.JSONObject;
import utils.JWTUtil;
import java.io.IOException;

/**
 * Authentication Filter - validates JWT token for protected resources.
 * Applied to /user/* URL pattern.
 */
public class AuthenticationFilter implements Filter {

    private final RefreshTokenDAO refreshTokenDAO = new RefreshTokenDAO();
    private final UserDAO userDAO = new UserDAO();

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
            claims = tryRefreshSessionToken(session, httpRequest);

            if (claims == null) {
                // Invalid or expired token and cannot refresh - clear session and redirect
                if (session != null) {
                    session.invalidate();
                }
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=session_expired");
                return;
            }
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

    private JSONObject tryRefreshSessionToken(HttpSession session, HttpServletRequest request) {
        if (session == null) {
            return null;
        }

        String refreshToken = (String) session.getAttribute("refreshToken");
        if (refreshToken == null || refreshToken.trim().isEmpty()) {
            return null;
        }

        RefreshToken storedToken = refreshTokenDAO.findActiveToken(refreshToken);
        if (storedToken == null) {
            return null;
        }

        User user = userDAO.findById(storedToken.getUserId());
        if (user == null || !"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            refreshTokenDAO.revokeToken(storedToken.getRefreshTokenId());
            return null;
        }

        String roleCode = user.getRoleCode() != null ? user.getRoleCode() : "CANDIDATE";
        String newAccessToken = JWTUtil.generateToken(
                user.getUserId(),
                user.getEmail(),
                user.getFullName(),
                roleCode
        );
        String newRefreshToken = JWTUtil.generateRefreshToken();

        boolean rotated = refreshTokenDAO.rotateToken(
                storedToken.getRefreshTokenId(),
                user.getUserId(),
                newRefreshToken,
                new Timestamp(JWTUtil.getRefreshTokenExpirationTime()),
                request.getHeader("User-Agent"),
                getClientIp(request)
        );

        if (!rotated) {
            return null;
        }

        session.setAttribute("jwtToken", newAccessToken);
        session.setAttribute("refreshToken", newRefreshToken);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("userFullName", user.getFullName());
        session.setAttribute("userRole", roleCode);
        session.setAttribute("userRoleName", user.getRoleName());
        session.setMaxInactiveInterval(JWTUtil.getRefreshTokenExpirationSeconds());

        return JWTUtil.validateToken(newAccessToken);
    }

    private String getClientIp(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.trim().isEmpty()) {
            return forwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
