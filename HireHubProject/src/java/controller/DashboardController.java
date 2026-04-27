package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

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
            Long userId = (Long) session.getAttribute("userId");
            
            if ("RECRUITER".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                return;
            } else if ("ADMIN".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/recruiters");
                return;
            } else if ("CANDIDATE".equals(role) && userId != null) {
                // Fetch stats for Candidate
                dal.ApplicationDAO appDAO = new dal.ApplicationDAO();
                dal.SavedJobDAO savedJobDAO = new dal.SavedJobDAO();
                dal.InterviewDAO interviewDAO = new dal.InterviewDAO();
                dal.JobDAO jobDAO = new dal.JobDAO();
                
                List<model.Application> applications = appDAO.findByCandidateId(userId);
                List<model.SavedJob> savedJobs = savedJobDAO.getSavedJobsByCandidateId(userId);
                
                // Fetch interviews (upcoming)
                java.util.Map<Long, model.Interview> interviews = new java.util.HashMap<>();
                for (model.Application app : applications) {
                    model.Interview inter = interviewDAO.findByApplicationId(app.getApplicationId());
                    if (inter != null) interviews.put(app.getApplicationId(), inter);
                }
                
                // Recommendations
                String latestInterest = applications.isEmpty() ? "" : applications.get(0).getJobTitle();
                List<model.Job> recommendations = jobDAO.getRecommendedJobs(latestInterest, 3);
                
                request.setAttribute("countApplied", applications.size());
                request.setAttribute("countSaved", savedJobs.size());
                request.setAttribute("countInterviews", interviews.size());
                request.setAttribute("recentApplications", applications.size() > 3 ? applications.subList(0, 3) : applications);
                request.setAttribute("recommendations", recommendations);
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}
