package controller;

import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import model.Role;
import model.User;
import utils.SecurityUtil;

/**
 * Unified admin controller for user management.
 */
@WebServlet(name = "AdminController", urlPatterns = {
    "/admin/users",
    "/admin/users/create",
    "/admin/users/edit",
    "/admin/users/delete"
})
public class AdminController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/users/create".equals(path)) {
            handleCreateGet(request, response);
            return;
        }

        if ("/admin/users/edit".equals(path)) {
            handleEditGet(request, response);
            return;
        }

        handleListGet(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/users/create".equals(path)) {
            handleCreatePost(request, response);
            return;
        }

        if ("/admin/users/edit".equals(path)) {
            handleEditPost(request, response);
            return;
        }

        if ("/admin/users/delete".equals(path)) {
            handleDeletePost(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleListGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = trimToNull(request.getParameter("q"));
        String roleCode = trimToNull(request.getParameter("role"));
        String status = trimToNull(request.getParameter("status"));

        int page = parsePositiveInt(request.getParameter("page"), 1);
        int pageSize = 10;

        List<User> users = userDAO.findUsersForAdmin(keyword, roleCode, status, page, pageSize);
        int totalUsers = userDAO.countUsersForAdmin(keyword, roleCode, status);
        int totalPages = (int) Math.ceil(totalUsers / (double) pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        List<Role> roles = roleDAO.findAllActiveRoles();

        request.setAttribute("users", users);
        request.setAttribute("roles", roles);
        request.setAttribute("q", keyword);
        request.setAttribute("selectedRole", roleCode);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);

        request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
    }

    private void handleCreateGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Modal is embedded in user-list.jsp, redirect there
        request.setAttribute("formMode", "create");
        request.setAttribute("roles", roleDAO.findAllActiveRoles());
        List<User> users = userDAO.findUsersForAdmin(null, null, null, 1, 10);
        int totalUsers = userDAO.countUsersForAdmin(null, null, null);
        int totalPages = Math.max(1, (int) Math.ceil(totalUsers / 10.0));
        request.setAttribute("users", users);
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
    }

    private void handleCreatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String email = trimToEmpty(request.getParameter("email"));
        String fullName = trimToEmpty(request.getParameter("fullName"));
        String phoneNumber = trimToEmpty(request.getParameter("phoneNumber"));
        String gender = trimToEmpty(request.getParameter("gender"));
        String dateOfBirth = trimToEmpty(request.getParameter("dateOfBirth"));
        String password = request.getParameter("password");
        String status = normalizeStatus(request.getParameter("status"));

        long roleId = parseLong(request.getParameter("roleId"));
        Role role = roleDAO.findByRoleId(roleId);

        StringBuilder errors = new StringBuilder();

        if (fullName.isEmpty()) {
            errors.append("Họ và tên không được để trống. ");
        }

        if (email.isEmpty()) {
            errors.append("Email không được để trống. ");
        } else if (!SecurityUtil.isValidEmail(email)) {
            errors.append("Email không hợp lệ. ");
        } else if (userDAO.existsByEmail(email)) {
            errors.append("Email đã được sử dụng. ");
        }

        String passwordError = SecurityUtil.validatePasswordStrength(password);
        if (passwordError != null) {
            errors.append(passwordError).append(". ");
        }

        if (role == null) {
            errors.append("Vai trò không hợp lệ. ");
        }

        User formUser = new User();
        formUser.setEmail(email);
        formUser.setFullName(fullName);
        formUser.setPhoneNumber(phoneNumber.isEmpty() ? null : phoneNumber);
        formUser.setGender(gender.isEmpty() ? null : gender);

        if (!dateOfBirth.isEmpty()) {
            try {
                formUser.setDateOfBirth(Date.valueOf(dateOfBirth));
            } catch (IllegalArgumentException e) {
                errors.append("Ngày sinh không hợp lệ. ");
            }
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("user", formUser);
            request.setAttribute("roles", roleDAO.findAllActiveRoles());
            request.setAttribute("selectedRoleId", roleId);
            request.setAttribute("selectedStatus", status);
            request.setAttribute("formMode", "create");
            List<User> users = userDAO.findUsersForAdmin(null, null, null, 1, 10);
            int totalUsers = userDAO.countUsersForAdmin(null, null, null);
            request.setAttribute("users", users);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", Math.max(1, (int) Math.ceil(totalUsers / 10.0)));
            request.setAttribute("totalUsers", totalUsers);
            request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
            return;
        }

        formUser.setPasswordHash(SecurityUtil.hashPassword(password));

        long userId = userDAO.insertByAdmin(formUser, status);
        if (userId > 0 && roleDAO.setUserSingleRole(userId, roleId)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=created");
            return;
        }

        request.setAttribute("error", "Không thể tạo tài khoản. Vui lòng thử lại.");
        request.setAttribute("user", formUser);
        request.setAttribute("roles", roleDAO.findAllActiveRoles());
        request.setAttribute("selectedRoleId", roleId);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("formMode", "create");
        List<User> usersOnErr = userDAO.findUsersForAdmin(null, null, null, 1, 10);
        int totalOnErr = userDAO.countUsersForAdmin(null, null, null);
        request.setAttribute("users", usersOnErr);
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", Math.max(1, (int) Math.ceil(totalOnErr / 10.0)));
        request.setAttribute("totalUsers", totalOnErr);
        request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
    }

    private void handleEditGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Edit is modal-based, redirect to list
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleEditPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        long userId = parseLong(request.getParameter("id"));
        if (userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
            return;
        }

        String email = trimToEmpty(request.getParameter("email"));
        String fullName = trimToEmpty(request.getParameter("fullName"));
        String phoneNumber = trimToEmpty(request.getParameter("phoneNumber"));
        String gender = trimToEmpty(request.getParameter("gender"));
        String dateOfBirth = trimToEmpty(request.getParameter("dateOfBirth"));
        String status = normalizeStatus(request.getParameter("status"));

        long roleId = parseLong(request.getParameter("roleId"));
        Role role = roleDAO.findByRoleId(roleId);

        StringBuilder errors = new StringBuilder();

        if (fullName.isEmpty()) {
            errors.append("Họ và tên không được để trống. ");
        }

        if (email.isEmpty()) {
            errors.append("Email không được để trống. ");
        } else if (!SecurityUtil.isValidEmail(email)) {
            errors.append("Email không hợp lệ. ");
        } else if (userDAO.emailExistsForOtherUser(email, userId)) {
            errors.append("Email đã được sử dụng bởi tài khoản khác. ");
        }

        if (role == null) {
            errors.append("Vai trò không hợp lệ. ");
        }

        User formUser = new User();
        formUser.setUserId(userId);
        formUser.setEmail(email);
        formUser.setFullName(fullName);
        formUser.setPhoneNumber(phoneNumber.isEmpty() ? null : phoneNumber);
        formUser.setGender(gender.isEmpty() ? null : gender);
        formUser.setStatus(status);
        if (role != null) {
            formUser.setRoleCode(role.getRoleCode());
        }

        if (!dateOfBirth.isEmpty()) {
            try {
                formUser.setDateOfBirth(Date.valueOf(dateOfBirth));
            } catch (IllegalArgumentException e) {
                errors.append("Ngày sinh không hợp lệ. ");
            }
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("formMode", "edit");
            request.setAttribute("user", formUser);
            request.setAttribute("roles", roleDAO.findAllActiveRoles());
            request.setAttribute("selectedRoleId", roleId);
            List<User> users = userDAO.findUsersForAdmin(null, null, null, 1, 10);
            int totalUsers = userDAO.countUsersForAdmin(null, null, null);
            request.setAttribute("users", users);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", Math.max(1, (int) Math.ceil(totalUsers / 10.0)));
            request.setAttribute("totalUsers", totalUsers);
            request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
            return;
        }

        boolean updated = userDAO.updateByAdmin(formUser, status);
        if (updated && roleDAO.setUserSingleRole(userId, roleId)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
            return;
        }

        request.setAttribute("error", "Không thể cập nhật tài khoản. Vui lòng thử lại.");
        request.setAttribute("formMode", "edit");
        request.setAttribute("user", formUser);
        request.setAttribute("roles", roleDAO.findAllActiveRoles());
        request.setAttribute("selectedRoleId", roleId);
        List<User> usersOnErr = userDAO.findUsersForAdmin(null, null, null, 1, 10);
        int totalOnErr = userDAO.countUsersForAdmin(null, null, null);
        request.setAttribute("users", usersOnErr);
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", Math.max(1, (int) Math.ceil(totalOnErr / 10.0)));
        request.setAttribute("totalUsers", totalOnErr);
        request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
    }

    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long targetUserId = parseLong(request.getParameter("id"));
        String action = request.getParameter("action");

        if (targetUserId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
            return;
        }

        Object userIdAttr = request.getAttribute("userId");
        if (!(userIdAttr instanceof Number)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=unauthorized");
            return;
        }

        long currentUserId = ((Number) userIdAttr).longValue();
        if (currentUserId == targetUserId && !"restore".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=self_action_not_allowed");
            return;
        }

        String nextStatus = "restore".equalsIgnoreCase(action) ? "ACTIVE" : "INACTIVE";
        boolean success = userDAO.updateUserStatus(targetUserId, nextStatus);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=status_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=update_failed");
        }
    }

    private long parseLong(String value) {
        if (value == null || value.trim().isEmpty()) {
            return -1;
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private int parsePositiveInt(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeStatus(String status) {
        if (status == null) {
            return "ACTIVE";
        }
        String normalized = status.trim().toUpperCase();
        switch (normalized) {
            case "ACTIVE":
            case "INACTIVE":
            case "LOCKED":
            case "PENDING":
                return normalized;
            default:
                return "ACTIVE";
        }
    }
}