package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import dal.UserCVDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.List;
import java.util.Map;
import model.Template;
import model.UserCV;

@WebServlet(urlPatterns = {"/user/cv/edit", "/user/cv/update"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class EditCVServlet extends HttpServlet {

    private UserCVDAO cvDAO = new UserCVDAO();

    // 1. Cấu hình Cloudinary (Dùng thông tin từ tài khoản doomoxozs của bạn)
    private final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", "doomoxozs",
            "api_key", "831553961773574",
            "api_secret", "Fpwm3adxcseDHjsdY7sGtq-RJP0",
            "secure", true
    ));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ... (Giữ nguyên logic doGet của bạn để lấy dữ liệu đổ vào form Edit) ...
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendRedirect(request.getContextPath() + "/user/cv/manage");
                return;
            }
            int id = Integer.parseInt(idStr);
            UserCV cv = cvDAO.getCVById(id);
            List<Template> listT = cvDAO.getAllTemplates();
            if (cv != null) {
                request.setAttribute("cv", cv);
                request.setAttribute("listT", listT);
                request.getRequestDispatcher("/WEB-INF/views/edit_cv.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/user/cv/manage?error=notfound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/cv/manage");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy dữ liệu từ form
            int userCVId = Integer.parseInt(request.getParameter("cvId"));
            String cvTitle = request.getParameter("cvTitle");
            String fullName = request.getParameter("fullName");
            String targetRole = request.getParameter("targetRole");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String birthDateRaw = request.getParameter("birthDate");
            String summary = request.getParameter("objective");
            String education = request.getParameter("educationRaw");
            String experience = request.getParameter("experienceDetail");
            String templateIdRaw = request.getParameter("templateId");
            
            int isSearchable = Integer.parseInt(request.getParameter("isSearchable"));
            int templateId = (templateIdRaw != null) ? Integer.parseInt(templateIdRaw) : 1;

            // 2. XỬ LÝ ẢNH VỚI CLOUDINARY
            // Mặc định lấy URL ảnh hiện tại (từ hidden input trong JSP)
            String avatarUrl = request.getParameter("currentAvatarUrl");
            Part filePart = request.getPart("avatarFile");

            // Kiểm tra nếu người dùng có chọn file mới
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    // Đọc file thành bytes
                    byte[] fileBytes = filePart.getInputStream().readAllBytes();

                    // Upload lên folder cv_updates trên Cloudinary
                    Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap(
                            "folder", "hirehub/cv_updates",
                            "public_id", "cv_" + userCVId + "_" + System.currentTimeMillis()
                    ));

                    // Cập nhật lại avatarUrl bằng đường dẫn mới từ Cloudinary
                    avatarUrl = (String) uploadResult.get("secure_url");
                    System.out.println("DEBUG: Đã cập nhật ảnh lên Cloudinary: " + avatarUrl);
                } catch (Exception e) {
                    System.out.println("DEBUG: Lỗi upload Cloudinary: " + e.getMessage());
                    // Nếu lỗi upload thì vẫn giữ avatarUrl cũ, không làm mất ảnh của user
                }
            }

            // 3. Đóng gói dữ liệu vào Model
            UserCV cv = new UserCV();
            cv.setUserCVId(userCVId);
            cv.setCvTitle(cvTitle);
            cv.setFullName(fullName);
            cv.setTargetRole(targetRole);
            cv.setPhone(phone);
            cv.setEmail(email);
            cv.setSummary(summary);
            cv.setEducationRaw(education);
            cv.setExperienceRaw(experience);
            cv.setAvatarUrl(avatarUrl); // Link https://res.cloudinary.com/...

            cv.setTemplateId(templateId);
            cv.setIsSearchable(isSearchable);

            if (birthDateRaw != null && !birthDateRaw.isEmpty()) {
                cv.setBirthDate(java.sql.Date.valueOf(birthDateRaw));
            }

            // 4. Cập nhật vào Database
            boolean success = cvDAO.updateCV(cv);

            if (success) {
                // Thành công: Quay về trang quản lý
                response.sendRedirect(request.getContextPath() + "/user/cv/manage_cv?status=success");
            } else {
                // Thất bại: Quay lại trang sửa với thông báo lỗi
                response.sendRedirect(request.getContextPath() + "/user/cv/edit?id=" + userCVId + "&status=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
