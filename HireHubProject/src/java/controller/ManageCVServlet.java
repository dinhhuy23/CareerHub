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

        // 1. Kiem tra dang nhap
        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            long userId = Long.parseLong(userIdObj.toString());
            UserCVDAO cvDAO = new UserCVDAO();

            // 2. Lay danh sach CV (ORDER BY UpdatedAt DESC — CV moi nhat o dau)
            List<UserCV> userCVs = cvDAO.getCVsByUserId(userId);

            // 3. Lay targetRole tu CV MOI NHAT co targetRole khong trong
            String targetRole = "";
            if (userCVs != null) {
                for (UserCV cv : userCVs) {
                    if (cv.getTargetRole() != null && !cv.getTargetRole().trim().isEmpty()) {
                        targetRole = cv.getTargetRole().trim();
                        break;
                    }
                }
            }

            // 4. Lay danh sach JobId ma user da nop don (de loai khoi goi y)
            dal.ApplicationDAO appDAO = new dal.ApplicationDAO();
            java.util.Set<Long> appliedJobIds = appDAO.getAppliedJobIds(userId);

            // 5. Lay 8 viec lam phu hop nhat theo targetRole, loai bo job da nop
            dal.JobDAO jobDAO = new dal.JobDAO();
            List<model.Job> allRecommended = jobDAO.getRecommendedJobs(targetRole, 8);
            List<model.Job> recommendedJobs = new java.util.ArrayList<>();
            for (model.Job job : allRecommended) {
                if (!appliedJobIds.contains(job.getJobId())) {
                    recommendedJobs.add(job);
                    if (recommendedJobs.size() >= 5) break; // Giu toi da 5 goi y
                }
            }

            // 6. Day du lieu sang JSP
            request.setAttribute("cvList", userCVs);
            request.setAttribute("jobList", recommendedJobs);
            request.setAttribute("targetRoleDisplay", targetRole);
            request.getRequestDispatcher("/WEB-INF/views/manage_cv.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}