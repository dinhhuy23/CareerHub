package controller;

import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Role;
import model.User;
import utils.SecurityUtil;
import java.io.IOException;

/**
 * Controller for user registration.
 * GET /register  - Display registration form
 * POST /register - Process registration
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleCode = request.getParameter("role");
        String phoneNumber = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        Role selectedRole = null;

        // Validation
        StringBuilder errors = new StringBuilder();

        // Email validation
        if (email == null || email.trim().isEmpty()) {
            errors.append("Email không được để trống. ");
        } else if (!SecurityUtil.isValidEmail(email.trim())) {
            errors.append("Email không hợp lệ. ");
        } else if (userDAO.existsByEmail(email.trim())) {
            errors.append("Email đã được sử dụng. ");
        }

        // Full name validation
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Họ và tên không được để trống. ");
        } else if (fullName.trim().length() < 2 || fullName.trim().length() > 150) {
            errors.append("Họ và tên phải từ 2 đến 150 ký tự. ");
        }

        // Password validation
        String passwordError = SecurityUtil.validatePasswordStrength(password);
        if (passwordError != null) {
            errors.append(passwordError + ". ");
        }

        // Confirm password
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            errors.append("Mật khẩu xác nhận không khớp. ");
        }

        // Role validation
        if (roleCode == null || roleCode.trim().isEmpty()) {
            errors.append("Vui lòng chọn vai trò. ");
        } else if (!roleCode.equals("CANDIDATE") && !roleCode.equals("RECRUITER")) {
            errors.append("Vai trò không hợp lệ. ");
        } else {
            if (!roleDAO.ensureDefaultRoles()) {
                errors.append("Hệ thống chưa sẵn sàng cho đăng ký. Vui lòng thử lại sau. ");
            } else {
                selectedRole = roleDAO.findByRoleCode(roleCode);
                if (selectedRole == null) {
                    errors.append("Vai trò đăng ký chưa được cấu hình. Vui lòng liên hệ quản trị viên. ");
                }
            }
        }

        // If there are errors, return to form
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("gender", gender);
            request.setAttribute("selectedRole", roleCode);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create user
        User newUser = new User();
        newUser.setEmail(email.trim());
        newUser.setPasswordHash(SecurityUtil.hashPassword(password));
        newUser.setFullName(fullName.trim());
        newUser.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
        newUser.setGender(gender);

        long userId = userDAO.insert(newUser);

        if (userId > 0) {
            if (selectedRole != null && roleDAO.assignRole(userId, selectedRole.getRoleId())) {
                // Redirect to login with success message
                response.sendRedirect(request.getContextPath() + "/login?success=registered");
                return;
            }

            // Roll back user creation when role assignment fails.
            userDAO.deleteById(userId);
            request.setAttribute("error", "Đăng ký thất bại do lỗi phân quyền tài khoản. Vui lòng thử lại.");
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("gender", gender);
            request.setAttribute("selectedRole", roleCode);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi khi đăng ký. Vui lòng thử lại.");
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
