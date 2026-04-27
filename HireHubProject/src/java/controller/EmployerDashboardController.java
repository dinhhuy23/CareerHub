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
import java.util.List;

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
        
        // --- Bổ sung dữ liệu mới ---
        // Ứng viên mới nhất
        List<model.Application> recentApplications = appDAO.findByEmployerId(userId);
        if (recentApplications.size() > 5) recentApplications = recentApplications.subList(0, 5);
        
        // Thống kê tin tuyển dụng theo trạng thái
        int activeJobs = 0;
        int closedJobs = 0;
        List<model.Job> allEmployerJobs = jobDAO.findByEmployerId(userId);
        for(model.Job j : allEmployerJobs) {
            if("PUBLISHED".equals(j.getStatus())) activeJobs++;
            else if("CLOSED".equals(j.getStatus())) closedJobs++;
        }

        // 3. Đưa dữ liệu vào request attribute để JSP hiển thị
        request.setAttribute("totalJobs", totalJobs);
        request.setAttribute("totalViews", totalViews);
        request.setAttribute("totalApplicants", totalApplicants);
        request.setAttribute("recentApplications", recentApplications);
        request.setAttribute("activeJobs", activeJobs);
        request.setAttribute("closedJobs", closedJobs);

        // 4. Chuyển hướng tới trang Dashboard
        request.getRequestDispatcher("/WEB-INF/views/employer_dashboard.jsp").forward(request, response);
    }
}
