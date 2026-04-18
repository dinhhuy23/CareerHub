package controller;

import dal.JobDAO;
import dal.SavedJobDAO;
import model.Job;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "JobDetailController", urlPatterns = {"/job-detail"})
public class JobDetailController extends HttpServlet {

    private final JobDAO jobDAO = new JobDAO();
    private final SavedJobDAO savedJobDAO = new SavedJobDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        try {
            long jobId = Long.parseLong(idStr);

            // Lấy job trước để kiểm tra tồn tại
            Job job = jobDAO.findById(jobId);
            if (job == null) {
                response.sendRedirect(request.getContextPath() + "/jobs");
                return;
            }

            // Chỉ cho xem job công khai hoặc đã đóng
            if (!"PUBLISHED".equalsIgnoreCase(job.getStatus())
                    && !"CLOSED".equalsIgnoreCase(job.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/jobs");
                return;
            }

            // Tăng lượt xem
            jobDAO.incrementViewCount(jobId);

            // Lấy lại job sau khi tăng view để hiển thị đúng số mới nhất
            job = jobDAO.findById(jobId);
            if (job == null) {
                response.sendRedirect(request.getContextPath() + "/jobs");
                return;
            }

            boolean isSaved = false;

            // Vì /job-detail là public nên phải đọc từ session, không dùng request attribute
            HttpSession session = request.getSession(false);
            if (session != null) {
                Object userIdObj = session.getAttribute("userId");
                Object userRoleObj = session.getAttribute("userRole");

                if (userIdObj != null && userRoleObj != null
                        && "CANDIDATE".equals(String.valueOf(userRoleObj))) {

                    Long userId = null;

                    if (userIdObj instanceof Long) {
                        userId = (Long) userIdObj;
                    } else if (userIdObj instanceof Integer) {
                        userId = ((Integer) userIdObj).longValue();
                    } else {
                        try {
                            userId = Long.parseLong(String.valueOf(userIdObj));
                        } catch (Exception e) {
                            userId = null;
                        }
                    }

                    if (userId != null) {
                        isSaved = savedJobDAO.isJobSaved(userId, jobId);
                    }
                }
            }

            request.setAttribute("job", job);
            request.setAttribute("isSaved", isSaved);
            request.getRequestDispatcher("/WEB-INF/views/job_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/jobs");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
    }
}

