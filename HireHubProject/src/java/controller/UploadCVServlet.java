package controller;

import dal.DBContext;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/user/cv/upload")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UploadCVServlet extends HttpServlet {

    // 1. Đường dẫn vật lý tuyệt đối để Java ghi file vào ổ đĩa
    private static final String PHYSICAL_PATH = "D:/HireHub_Uploads/cv_files";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");
        Integer userId = (userIdObj instanceof Number) ? ((Number) userIdObj).intValue() : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String cvTitle = request.getParameter("cvTitle");
            String targetRole = request.getParameter("targetRole");
            String isSearchableStr = request.getParameter("isSearchable");
            int isSearchable = (isSearchableStr != null && isSearchableStr.equals("1")) ? 1 : 0;
            Part filePart = request.getPart("cvFile");

            if (filePart != null && filePart.getSize() > 0) {
                // 2. Kiểm tra và tạo thư mục ổ D nếu chưa có
                File uploadDir = new File(PHYSICAL_PATH);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // 3. Đặt tên file duy nhất
                String fileName = "cv_" + userId + "_" + System.currentTimeMillis() + ".pdf";

                // 4. Ghi file vật lý vào ổ D (D:/HireHub_Uploads/cv_files/cv_1_...pdf)
                String fullPath = PHYSICAL_PATH + File.separator + fileName;
                filePart.write(fullPath);

                // 5. QUAN TRỌNG: Lưu đường dẫn ẢO vào Database để Web hiển thị
                // Khớp với cấu hình webAppMount="/user/cv/uploads/cv_files" trong context.xml của bạn
                String fileUrlForDB = "user/cv/uploads/cv_files/" + fileName;

                saveCVToDatabase(userId, cvTitle, targetRole, fileUrlForDB, isSearchable);
                session.setAttribute("msg", "Tải CV lên thành công!");

            } else {
                session.setAttribute("error", "Vui lòng chọn một file PDF hợp lệ!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/user/cv/manage_cv");
    }

    private void saveCVToDatabase(int userId, String title, String targetRole, String fileUrl, int isSearchable) {
        String sql = "INSERT INTO [UserCVs] (UserId, CVTitle, TargetRole, AvatarUrl, CreatedAt, IsUpload, IsAccepted, TemplateId, IsSearchable) "
                + "VALUES (?, ?, ?, ?, GETDATE(), 1, 0, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, targetRole);
            ps.setString(4, fileUrl); // Lưu: user/cv/uploads/cv_files/cv_123.pdf
            ps.setNull(5, java.sql.Types.INTEGER);
            ps.setInt(6, isSearchable);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi DB: " + e.getMessage());
        }
    }
}
