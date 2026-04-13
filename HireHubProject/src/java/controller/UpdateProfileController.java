package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.JWTUtil;
import utils.SecurityUtil;
import java.io.IOException;
import java.sql.Date;

/**
 * Controller for updating user profile.
 * GET /user/edit-profile  - Display edit form
 * POST /user/edit-profile - Process update
 */
@WebServlet(name = "UpdateProfileController", urlPatterns = {"/user/edit-profile"})
public class UpdateProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long userId = (long) request.getAttribute("userId");
        User user = userDAO.findById(userId);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        user.setPasswordHash(null);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/edit-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        long userId = (long) request.getAttribute("userId");

        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String dateOfBirthStr = request.getParameter("dateOfBirth");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (email == null || email.trim().isEmpty()) {
            errors.append("Email không được để trống. ");
        } else if (!SecurityUtil.isValidEmail(email.trim())) {
            errors.append("Email không hợp lệ. ");
        } else if (userDAO.emailExistsForOtherUser(email.trim(), userId)) {
            errors.append("Email đã được sử dụng bởi tài khoản khác. ");
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Họ và tên không được để trống. ");
        }

        if (errors.length() > 0) {
            User user = userDAO.findById(userId);
            user.setPasswordHash(null);
            request.setAttribute("user", user);
            request.setAttribute("error", errors.toString().trim());
            request.getRequestDispatcher("/WEB-INF/views/edit-profile.jsp").forward(request, response);
            return;
        }

        // Update user
        User user = new User();
        user.setUserId(userId);
        user.setEmail(email.trim());
        user.setFullName(fullName.trim());
        user.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
        user.setGender(gender);

        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            try {
                user.setDateOfBirth(Date.valueOf(dateOfBirthStr));
            } catch (IllegalArgumentException e) {
                // Invalid date format, skip
            }
        }

        boolean success = userDAO.update(user);

        if (success) {
            // Refresh JWT token with new info
            String roleCode = (String) request.getAttribute("userRole");
            String newToken = JWTUtil.generateToken(userId, email.trim(), fullName.trim(), roleCode);

            HttpSession session = request.getSession();
            session.setAttribute("jwtToken", newToken);
            session.setAttribute("userEmail", email.trim());
            session.setAttribute("userFullName", fullName.trim());

            response.sendRedirect(request.getContextPath() + "/user/profile?success=updated");
        } else {
            User currentUser = userDAO.findById(userId);
            currentUser.setPasswordHash(null);
            request.setAttribute("user", currentUser);
            request.setAttribute("error", "Không thể cập nhật thông tin. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/edit-profile.jsp").forward(request, response);
        }
    }
}
