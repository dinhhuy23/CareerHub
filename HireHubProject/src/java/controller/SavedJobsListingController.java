package controller;

import dal.SavedJobDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SavedJob;
import model.User;
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

        List<SavedJob> savedJobs = savedJobDAO.getSavedJobsByCandidateId(userId);
        
        request.setAttribute("savedJobs", savedJobs);
        request.getRequestDispatcher("/WEB-INF/views/saved_jobs.jsp").forward(request, response);
    }
}
