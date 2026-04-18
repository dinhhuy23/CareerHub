package controller;

import dal.ApplicationDAO;
import model.Application;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import jakarta.servlet.annotation.MultipartConfig;

@WebServlet(name = "ApplyController", urlPatterns = {"/job/apply"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ApplyController extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy userId từ sessionScope (được lưu khi đăng nhập)
        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            // Chưa đăng nhập, chuyển về trang login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Chỉ CANDIDATE mới được nộp đơn
        String userRole = (String) session.getAttribute("userRole");
        if (!"CANDIDATE".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        try {
            // Lấy Job ID
            long jobId = Long.parseLong(request.getParameter("jobId"));
            String coverLetter = request.getParameter("coverLetter");

            // Kiểm tra xem đã nộp đơn công việc này chưa
            if (appDAO.hasAlreadyApplied(userId, jobId)) {
                response.sendRedirect(request.getContextPath() + "/job-detail?id=" + jobId + "&error=already_applied");
                return;
            }

            jakarta.servlet.http.Part filePart = request.getPart("cvFile");
            Long resumeId = null;

            if (filePart != null && filePart.getSize() > 0) {
                // Thư mục lưu file
                String uploadPath = request.getServletContext().getRealPath("") + java.io.File.separator + "uploads" + java.io.File.separator + "cv";
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                // Sinh tên file duy nhất tránh trùng lặp ghim đuôi pdf
                String fileName = java.util.UUID.randomUUID().toString() + ".pdf";
                String filePath = uploadPath + java.io.File.separator + fileName;
                filePart.write(filePath);

                // Đường dẫn URL tương đối dể trả về Web
                String fileUrl = request.getContextPath() + "/uploads/cv/" + fileName;

                // Lưu vào Resume Database
                dal.ResumeDAO resumeDAO = new dal.ResumeDAO();
                model.CandidateResume resume = new model.CandidateResume();
                resume.setCandidateId(userId);
                resume.setResumeTitle("CV_"+fileName.substring(0, 8));
                resume.setFileUrl(fileUrl);
                resume.setFileType("application/pdf");
                resume.setFileSizeKB((int) (filePart.getSize() / 1024));
                
                resumeId = resumeDAO.insert(resume);
            }

            // Tạo đối tượng Application và gán dữ liệu
            Application app = new Application();
            app.setJobId(jobId);
            app.setCandidateId(userId);
            app.setResumeId(resumeId);
            app.setCoverLetter(coverLetter);
            app.setStatus("PENDING"); 

            // Lưu vào Database Applications
            long appId = appDAO.insert(app);
            if (appId > 0) {
                response.sendRedirect(request.getContextPath() + "/job-detail?id=" + jobId + "&success=applied");
            } else {
                response.sendRedirect(request.getContextPath() + "/job-detail?id=" + jobId + "&error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
    }
}
