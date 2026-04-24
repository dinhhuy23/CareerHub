package controller;

import dal.UserCVDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.UserCV;

@WebServlet(name = "ManageCVServlet", urlPatterns = {"/user/cv/manage_cv"})
public class ManageCVServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");

        // 1. Kiểm tra đăng nhập
        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdObj.toString());
            UserCVDAO cvDAO = new UserCVDAO();

            // 2. Chỉ tập trung lấy danh sách CV
            List<UserCV> userCVs = cvDAO.getCVsByUserId(userId);

            // Tìm TargetRole từ CV mới nhất (nếu có) để gợi ý việc làm
            String targetRole = "";
            if (userCVs != null && !userCVs.isEmpty()) {
                for (UserCV cv : userCVs) {
                    if (cv.getTargetRole() != null && !cv.getTargetRole().trim().isEmpty()) {
                        targetRole = cv.getTargetRole();
                        break;
                    }
                }
            }

            // Lấy việc làm gợi ý
            dal.JobDAO jobDAO = new dal.JobDAO();
            List<model.Job> recommendedJobs = jobDAO.getRecommendedJobs(targetRole, 5);
            // Nếu tìm theo targetRole không có kết quả, lấy 5 job mới nhất
            if (recommendedJobs.isEmpty() && !targetRole.isEmpty()) {
                recommendedJobs = jobDAO.getRecommendedJobs("", 5);
            }

            // 3. Đẩy dữ liệu sang JSP
            request.setAttribute("cvList", userCVs);
            request.setAttribute("jobList", recommendedJobs);
            request.getRequestDispatcher("/WEB-INF/views/manage_cv.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}