package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.SecurityUtil;
import java.io.IOException;

/**
 * Controller for changing password.
 * GET /user/change-password  - Display change password form
 * POST /user/change-password - Process password change
 */
@WebServlet(name = "ChangePasswordController", urlPatterns = {"/user/change-password"})
public class ChangePasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        long userId = (long) request.getAttribute("userId");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (currentPassword == null || currentPassword.isEmpty()) {
            errors.append("Mật khẩu hiện tại không được để trống. ");
        }

        // Validate new password strength
        String passwordError = SecurityUtil.validatePasswordStrength(newPassword);
        if (passwordError != null) {
            errors.append(passwordError + ". ");
        }

        // Confirm new password
        if (confirmNewPassword == null || !confirmNewPassword.equals(newPassword)) {
            errors.append("Mật khẩu xác nhận không khớp. ");
        }

        // Check that new password is different from current
        if (currentPassword != null && currentPassword.equals(newPassword)) {
            errors.append("Mật khẩu mới phải khác mật khẩu hiện tại. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
            return;
        }

        // Verify current password
        User user = userDAO.findById(userId);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!SecurityUtil.checkPassword(currentPassword, user.getPasswordHash())) {
            request.setAttribute("error", "Mật khẩu hiện tại không chính xác.");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
            return;
        }

        // Hash and update new password
        String newPasswordHash = SecurityUtil.hashPassword(newPassword);
        boolean success = userDAO.updatePassword(userId, newPasswordHash);

        if (success) {
            request.setAttribute("success", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Không thể đổi mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
        }
    }
}
