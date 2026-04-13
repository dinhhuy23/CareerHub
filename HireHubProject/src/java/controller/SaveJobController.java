package controller;

import dal.SavedJobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SaveJobController", urlPatterns = {"/user/save-job"})
public class SaveJobController extends HttpServlet {

    private final SavedJobDAO savedJobDAO = new SavedJobDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Long userId = (Long) request.getAttribute("userId");
        String userRole = (String) request.getAttribute("userRole");

        if (userId == null || !"CANDIDATE".equals(userRole)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Candidate login required\"}");
            return;
        }

        try {
            long jobId = Long.parseLong(request.getParameter("jobId"));
            String action = request.getParameter("action"); // 'save' or 'unsave'

            boolean result = false;
            if ("save".equals(action)) {
                result = savedJobDAO.saveJob(userId, jobId);
            } else if ("unsave".equals(action)) {
                result = savedJobDAO.unsaveJob(userId, jobId);
            }

            if (result) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Update failed\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid job ID\"}");
        }
    }
}
