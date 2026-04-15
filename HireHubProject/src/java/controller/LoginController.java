package controller;

import dal.RefreshTokenDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import model.User;
import utils.JWTUtil;
import utils.SecurityUtil;
import java.io.IOException;

/**
 * Controller for user login.
 * GET /login  - Display login form
 * POST /login - Process login with JWT generation
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final RefreshTokenDAO refreshTokenDAO = new RefreshTokenDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("jwtToken") != null) {
            String role = (String) session.getAttribute("userRole");
            if ("RECRUITER".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/jobs");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/dashboard");
            }
            return;
        }

        // Check for success/error messages from query params
        String success = request.getParameter("success");
        if ("registered".equals(success)) {
            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
        }

        String error = request.getParameter("error");
        if ("session_expired".equals(error)) {
            request.setAttribute("error", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic validation
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Find user by email
        User user = userDAO.findByEmail(email.trim());

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không chính xác.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check account status
        if (!"ACTIVE".equals(user.getStatus())) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa hoặc chưa kích hoạt.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Verify password
        if (!SecurityUtil.checkPassword(password, user.getPasswordHash())) {
            request.setAttribute("error", "Email hoặc mật khẩu không chính xác.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Generate JWT token
        String roleCode = user.getRoleCode() != null ? user.getRoleCode() : "CANDIDATE";
        String token = JWTUtil.generateToken(
                user.getUserId(),
                user.getEmail(),
                user.getFullName(),
                roleCode
        );

        String refreshToken = JWTUtil.generateRefreshToken();
        Timestamp refreshTokenExpiredAt = new Timestamp(JWTUtil.getRefreshTokenExpirationTime());

        String userAgent = request.getHeader("User-Agent");
        String ipAddress = getClientIp(request);

        refreshTokenDAO.revokeAllActiveTokensByUser(user.getUserId());
        long refreshTokenId = refreshTokenDAO.insertToken(
            user.getUserId(),
            refreshToken,
            refreshTokenExpiredAt,
            userAgent,
            ipAddress
        );

        if (refreshTokenId <= 0) {
            request.setAttribute("error", "Không thể tạo phiên đăng nhập an toàn. Vui lòng thử lại.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Create session and store token
        HttpSession session = request.getSession(true);
        session.setAttribute("jwtToken", token);
        session.setAttribute("refreshToken", refreshToken);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("userFullName", user.getFullName());
        session.setAttribute("userRole", roleCode);
        session.setAttribute("userRoleName", user.getRoleName());
        session.setMaxInactiveInterval(JWTUtil.getRefreshTokenExpirationSeconds());

        // Update last login
        userDAO.updateLastLogin(user.getUserId());

        // Redirect based on role
        if ("RECRUITER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/jobs");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/dashboard");
        }
    }

    private String getClientIp(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.trim().isEmpty()) {
            return forwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
