package controller;

import dal.ApplicationDAO;
import dal.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "EmployerDashboardController", urlPatterns = {"/employer/dashboard"})
public class EmployerDashboardController extends HttpServlet {

    private final JobDAO jobDAO = new JobDAO();
    private final ApplicationDAO appDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy userId từ sessionScope - do AuthorizationFilter đã kiểm tra quyền RECRUITER rồi
        //    nên ở đây chỉ cần lấy userId ra là đủ
        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Gọi DAO để lấy dữ liệu thống kê từ database
        int totalJobs = jobDAO.countJobsByEmployer(userId);      // Tổng tin đăng
        long totalViews = jobDAO.getTotalViewsByEmployer(userId); // Tổng lượt xem
        int totalApplicants = appDAO.countByEmployerId(userId);  // Tổng ứng viên
        
        // MỚI: Thống kê chi tiết
        java.util.List<model.Application> allApps = appDAO.findByEmployerId(userId);
        long pendingApps = allApps.stream().filter(a -> "PENDING".equals(a.getStatus())).count();
        long interviewApps = allApps.stream().filter(a -> "INTERVIEWING".equals(a.getStatus()) || "INTERVIEW_ROUND_2".equals(a.getStatus())).count();

        // 3. Đưa dữ liệu vào request attribute để JSP hiển thị
        request.setAttribute("totalJobs", totalJobs);
        request.setAttribute("totalViews", totalViews);
        request.setAttribute("totalApplicants", totalApplicants);
        request.setAttribute("pendingApps", pendingApps);
        request.setAttribute("interviewApps", interviewApps);

        // Lấy 5 ứng viên mới nhất
        if (allApps.size() > 5) allApps = allApps.subList(0, 5);
        request.setAttribute("recentApplicants", allApps);

        // Lấy 3 tin tuyển dụng mới nhất
        java.util.List<model.Job> recentJobs = jobDAO.findByEmployerId(userId);
        if (recentJobs.size() > 3) recentJobs = recentJobs.subList(0, 3);
        request.setAttribute("recentJobs", recentJobs);

        // 4. Chuyển hướng tới trang Dashboard
        request.getRequestDispatcher("/WEB-INF/views/employer_dashboard.jsp").forward(request, response);
    }
}
