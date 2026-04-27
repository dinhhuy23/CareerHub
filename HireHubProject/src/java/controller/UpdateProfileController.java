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
 * GET  /user/edit-profile  — Hiển thị form chỉnh sửa
 * POST /user/edit-profile  — Xử lý cập nhật thông tin cá nhân (FullName, Phone, Gender, DOB)
 *
 * LƯU Ý THIẾT KẾ:
 *  - `email` (cột Users.Email) là TÀI KHOẢN ĐĂNG NHẬP — không bao giờ được đổi ở đây.
 *  - `contactEmail` (cột Users.ContactEmail) là GMAIL LIÊN HỆ — người dùng có thể tự cập nhật.
 *    Mỗi người chỉ được liên kết 1 ContactEmail duy nhất trong toàn hệ thống.
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

        // --- Lấy dữ liệu từ form ---
        String fullName      = request.getParameter("fullName");
        String phoneNumber   = request.getParameter("phoneNumber");
        String gender        = request.getParameter("gender");
        String dateOfBirthStr= request.getParameter("dateOfBirth");
        // Gmail liên hệ (ContactEmail) — tách biệt với email đăng nhập
        String contactEmail  = request.getParameter("contactEmail");

        // ===================================================================
        // VALIDATION
        // ===================================================================
        StringBuilder errors = new StringBuilder();

        // [1] Họ tên: bắt buộc, 2-150 ký tự, chỉ chứa chữ cái
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Họ và tên không được để trống. ");
        } else {
            String fn = fullName.trim();
            if (fn.length() < 2 || fn.length() > 150) {
                errors.append("Họ và tên phải từ 2 đến 150 ký tự. ");
            } else if (!fn.matches("^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỊỈỊịỉịỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰỵỷỹý\\s]+$")) {
                errors.append("Họ và tên chỉ được chứa chữ cái. ");
            }
        }

        // [2] Gmail liên hệ (ContactEmail): không bắt buộc, nhưng nếu nhập phải đúng format
        //     và phải là địa chỉ Gmail (đuôi @gmail.com)
        if (contactEmail != null && !contactEmail.trim().isEmpty()) {
            String ce = contactEmail.trim().toLowerCase();
            if (!ce.matches("^[a-zA-Z0-9._%+-]+@gmail\\.com$")) {
                errors.append("Gmail liên hệ không hợp lệ (phải là @gmail.com). ");
            } else if (userDAO.contactEmailExistsForOtherUser(ce, userId)) {
                errors.append("Gmail liên hệ này đã được liên kết với tài khoản khác. ");
            }
        }

        // [3] Số điện thoại: 10 chữ số, bắt đầu bằng 0 hoặc +84
        if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
            String pn = phoneNumber.trim();
            if (!pn.matches("^(\\+84|0)[35789][0-9]{8}$")) {
                errors.append("Số điện thoại không hợp lệ (phải là 10 chữ số VN). ");
            }
        }

        // [4] Giới tính: Nam, Nu, Khac
        if (gender != null && !gender.trim().isEmpty()) {
            if (!gender.equals("Nam") && !gender.equals("Nu") && !gender.equals("Khac")) {
                errors.append("Giới tính không hợp lệ. ");
            }
        }

        // [5] Ngày sinh: nếu có thì không được là ngày trong tương lai và phải >= 15 tuổi
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                Date dob = Date.valueOf(dateOfBirthStr.trim());
                java.time.LocalDate dobLocal = dob.toLocalDate();
                java.time.LocalDate today = java.time.LocalDate.now();
                if (dobLocal.isAfter(today)) {
                    errors.append("Ngày sinh không thể là ngày trong tương lai. ");
                } else if (dobLocal.isAfter(today.minusYears(15))) {
                    errors.append("Bạn phải ít nhất 15 tuổi. ");
                } else if (dobLocal.isBefore(today.minusYears(120))) {
                    errors.append("Ngày sinh không hợp lệ. ");
                }
            } catch (IllegalArgumentException e) {
                errors.append("Ngày sinh không đúng định dạng (yyyy-MM-dd). ");
            }
        }

        // Nếu có lỗi → quay lại form
        if (errors.length() > 0) {
            User user = userDAO.findById(userId);
            user.setPasswordHash(null);
            // Giữ lại giá trị người dùng đã nhập để không bị mất khi reload
            if (contactEmail != null) user.setContactEmail(contactEmail.trim());
            request.setAttribute("user", user);
            request.setAttribute("error", errors.toString().trim());
            request.getRequestDispatcher("/WEB-INF/views/edit-profile.jsp").forward(request, response);
            return;
        }

        // ===================================================================
        // CẬP NHẬT THÔNG TIN CƠ BẢN (không bao gồm email đăng nhập)
        // ===================================================================
        User user = new User();
        user.setUserId(userId);
        user.setFullName(fullName.trim());
        user.setPhoneNumber((phoneNumber != null && !phoneNumber.trim().isEmpty()) ? phoneNumber.trim() : null);
        user.setGender(gender);

        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            try {
                user.setDateOfBirth(Date.valueOf(dateOfBirthStr));
            } catch (IllegalArgumentException e) {
                // bỏ qua nếu không parse được (đã validate ở trên)
            }
        }

        // Đọc email đăng nhập hiện tại từ DB để giữ nguyên cho update()
        User existingUser = userDAO.findById(userId);
        user.setEmail(existingUser.getEmail());

        boolean success = userDAO.update(user);

        // ===================================================================
        // CẬP NHẬT GMAIL LIÊN HỆ (ContactEmail) — riêng biệt
        // ===================================================================
        if (success) {
            String ceToSave = (contactEmail != null && !contactEmail.trim().isEmpty())
                    ? contactEmail.trim().toLowerCase()
                    : null;
            userDAO.updateContactEmail(userId, ceToSave);

            // Refresh JWT & Session (chỉ cần fullName thay đổi)
            String roleCode = (String) request.getAttribute("userRole");
            String newToken = JWTUtil.generateToken(userId, existingUser.getEmail(), fullName.trim(), roleCode);

            HttpSession session = request.getSession();
            session.setAttribute("jwtToken", newToken);
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
