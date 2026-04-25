package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import dal.DBContext;
import dal.UserCVDAO;
import dal.CVTemplateDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.Map;
import model.UserCV;
import model.CVTemplate;

@WebServlet(name = "ReviewCVServlet", urlPatterns = {"/user/cv/preview"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class ReviewCVServlet extends HttpServlet {

    // Khởi tạo Cloudinary (Thay bằng thông tin của bạn)
    private final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", "doomoxozs",
            "api_key", "831553961773574",
            "api_secret", "Fpwm3adxcseDHjsdY7sGtq-RJP0",
            "secure", true
    ));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cvIdStr = request.getParameter("id");
        if (cvIdStr != null && !cvIdStr.isEmpty()) {
            try {
                int cvId = Integer.parseInt(cvIdStr);
                UserCVDAO cvDAO = new UserCVDAO();
                UserCV cv = cvDAO.getCVById(cvId);

                if (cv != null) {
                    // KIỂM TRA: Nếu là file PDF upload (isUpload == 1)
                    if (cv.getIsUpload() == 1) {
                        // Chuyển hướng thẳng đến đường dẫn file PDF
                        response.sendRedirect(request.getContextPath() + "/" + cv.getAvatarUrl());
                        return;
                    }

                    // Nếu là CV tự tạo từ Web (isUpload == 0) -> Tiếp tục logic cũ
                    CVTemplateDAO templateDAO = new CVTemplateDAO(new DBContext().getConnection());
                    CVTemplate selectedTemplate = templateDAO.getTemplateById(cv.getTemplateId());
                    String targetJsp = (selectedTemplate != null) ? selectedTemplate.getBaseFileJsp() : "template_1.jsp";

                    request.setAttribute("cvData", cv);
                    request.getRequestDispatcher("/WEB-INF/views/" + targetJsp).forward(request, response);
                    return;
                }
            } catch (Exception e) {
                System.out.println("DEBUG: Lỗi doGet: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/user/cv/manage?msg=error");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("formAction");
        UserCV cv = new UserCV();

        // 1. Mapping dữ liệu cơ bản
        cv.setFullName(request.getParameter("fullName"));
        cv.setTargetRole(request.getParameter("targetRole"));
        cv.setAddress(request.getParameter("address"));
        cv.setPhone(request.getParameter("phone"));
        cv.setEmail(request.getParameter("email"));
        cv.setGender(request.getParameter("gender"));
        cv.setSummary(request.getParameter("objective"));
        cv.setEducationRaw(request.getParameter("educationRaw"));
        cv.setExperienceRaw(request.getParameter("experienceDetail"));

        String bDateStr = request.getParameter("birthDate");
        if (bDateStr != null && !bDateStr.isEmpty()) {
            try {
                cv.setBirthDate(Date.valueOf(bDateStr));
            } catch (Exception e) {
            }
        }

        // 2. XỬ LÝ CLOUDINARY THAY CHO BASE64
        Part filePart = request.getPart("avatarFile");
        String avatarUrl = "";

        if (filePart != null && filePart.getSize() > 0) {
            try {
                // Đọc dữ liệu ảnh từ input stream
                byte[] imageBytes = filePart.getInputStream().readAllBytes();

                // Upload lên Cloudinary
                Map uploadResult = cloudinary.uploader().upload(imageBytes, ObjectUtils.asMap(
                        "folder", "cv_avatars",
                        "public_id", "user_" + System.currentTimeMillis()
                ));

                // Lấy URL từ Cloudinary trả về
                avatarUrl = (String) uploadResult.get("secure_url");
                System.out.println("DEBUG: Upload Cloudinary thành công: " + avatarUrl);

            } catch (Exception e) {
                System.out.println("DEBUG: Lỗi Cloudinary: " + e.getMessage());
                avatarUrl = "images/default-avatar.png";
            }
        } else {
            String currentAvatar = request.getParameter("currentAvatarUrl");
            avatarUrl = (currentAvatar != null && !currentAvatar.isEmpty()) ? currentAvatar : "images/default-avatar.png";
        }

        cv.setAvatarUrl(avatarUrl);

        // 3. XỬ LÝ SAVE HOẶC PREVIEW
        if ("save".equals(action)) {
            HttpSession session = request.getSession();
            Object userIdObj = session.getAttribute("userId");

            if (userIdObj == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            try {
                int userId = Integer.parseInt(userIdObj.toString());
                cv.setUserId(userId);
                cv.setCvTitle(request.getParameter("cvTitle"));
                String templateIdStr = request.getParameter("templateId");
                cv.setTemplateId(templateIdStr != null ? Integer.parseInt(templateIdStr) : 1);

                UserCVDAO cvDAO = new UserCVDAO();
                if (cvDAO.insertCV(cv)) {
                    response.sendRedirect(request.getContextPath() + "/user/cv/manage_cv?msg=success");
                } else {
                    throw new Exception("SQL Insert Failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi: " + e.getMessage());
                request.getRequestDispatcher("/cv_form.jsp").forward(request, response);
            }
        } else {
            // Nhánh Preview: Lấy dữ liệu động từ database
            String templateIdStr = request.getParameter("templateId");
            String targetJsp = "template_1.jsp"; // Giá trị mặc định phòng hờ

            try {
                int tId = (templateIdStr != null) ? Integer.parseInt(templateIdStr) : 1;

                // Gọi DAO để lấy thông tin Template từ Database (giống logic trong doGet)
                CVTemplateDAO templateDAO = new CVTemplateDAO(new DBContext().getConnection());
                CVTemplate selectedTemplate = templateDAO.getTemplateById(tId);

                if (selectedTemplate != null && selectedTemplate.getBaseFileJsp() != null) {
                    targetJsp = selectedTemplate.getBaseFileJsp();
                }
            } catch (Exception e) {
                System.out.println("DEBUG Preview: " + e.getMessage());
            }

            request.setAttribute("cvData", cv);
            // Forward tới file JSP thực tế của Template (Vd: chuyen_nghiep.jsp cho Template 4)
            request.getRequestDispatcher("/WEB-INF/views/" + targetJsp).forward(request, response);
        }
    }
}
