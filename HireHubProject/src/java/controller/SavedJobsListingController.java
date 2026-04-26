package controller;

import dal.SavedJobDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SavedJob;
import java.io.IOException;
import java.util.List;

/**
 * Controller to list all jobs saved by the candidate.
 * GET /user/saved-jobs
 */
@WebServlet(name = "SavedJobsListingController", urlPatterns = {"/user/saved-jobs"})
public class SavedJobsListingController extends HttpServlet {

    private final SavedJobDAO savedJobDAO = new SavedJobDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // userId and userRole are set by AuthenticationFilter
        Long userId = (Long) request.getAttribute("userId");
        String userRole = (String) request.getAttribute("userRole");

        if (userId == null || !"CANDIDATE".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<SavedJob> allSavedJobs = savedJobDAO.getSavedJobsByCandidateId(userId);
        
        // --- Xử lý phân trang In-Memory ---
        int pageSize = 6;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try { currentPage = Integer.parseInt(pageParam); } catch (Exception e) {}
        }
        
        int totalItems = allSavedJobs.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);
        
        List<SavedJob> pagedSavedJobs = new java.util.ArrayList<>();
        if (start < totalItems) {
            pagedSavedJobs = allSavedJobs.subList(start, end);
        }
        
        request.setAttribute("savedJobs", pagedSavedJobs);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/WEB-INF/views/saved_jobs.jsp").forward(request, response);
    }
}
