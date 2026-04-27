package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller cho trang Dashboard.
 * Nếu người dùng là RECRUITER -> chuyển sang /employer/dashboard
 * Nếu là CANDIDATE -> hiện trang dashboard.jsp
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/user/dashboard"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra role từ session để chuyển hướng đúng trang
        HttpSession session = request.getSession(false);
        if (session != null) {
            String role = (String) session.getAttribute("userRole");
            if ("RECRUITER".equals(role)) {
                // Recruiter không dùng /user/dashboard, chuyển về employer dashboard
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                return;
            } else if ("ADMIN".equals(role)) {
                // Admin chuyển về trang quản trị
                response.sendRedirect(request.getContextPath() + "/admin/recruiters");
                return;
            }
        }

        // Candidate: hiện trang dashboard bình thường
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            dal.ApplicationDAO appDAO = new dal.ApplicationDAO();
            dal.SavedJobDAO savedJobDAO = new dal.SavedJobDAO();
            dal.JobDAO jobDAO = new dal.JobDAO();
            dal.NotificationDAO notiDAO = new dal.NotificationDAO();

            // Lấy thống kê
            int totalApplied = appDAO.findByCandidateId(userId).size();
            int totalSaved = savedJobDAO.countSavedJobs(userId);
            int totalNotifications = notiDAO.countUnread(userId);

            request.setAttribute("totalApplied", totalApplied);
            request.setAttribute("totalSaved", totalSaved);
            request.setAttribute("totalNotifications", totalNotifications);

            // Lấy danh sách ứng tuyển gần đây (3 cái mới nhất)
            java.util.List<model.Application> recentApps = appDAO.findByCandidateId(userId);
            if (recentApps.size() > 3) recentApps = recentApps.subList(0, 3);
            request.setAttribute("recentApps", recentApps);

            // Gợi ý việc làm (Lấy 4 cái mới nhất)
            java.util.List<model.Job> recommendedJobs = jobDAO.getLatestJobs(4);
            request.setAttribute("recommendedJobs", recommendedJobs);
        }

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}
