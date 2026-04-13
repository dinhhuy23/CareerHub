package controller;

import dal.JobDAO;
import dal.SavedJobDAO;
import model.Job;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "JobDetailController", urlPatterns = {"/job-detail"})
public class JobDetailController extends HttpServlet {

    private final JobDAO jobDAO = new JobDAO();
    private final SavedJobDAO savedJobDAO = new SavedJobDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        try {
            long jobId = Long.parseLong(idStr);
            Job job = jobDAO.findById(jobId);
            
            if (job == null || (!job.getStatus().equals("PUBLISHED") && !job.getStatus().equals("CLOSED"))) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Job not found");
                return;
            }

            jobDAO.incrementViewCount(jobId);
            job.setViewCount(job.getViewCount() + 1);

            boolean isSaved = false;
            Long userId = (Long) request.getAttribute("userId");
            if (userId != null) {
                isSaved = savedJobDAO.isJobSaved(userId, jobId);
            }

            request.setAttribute("job", job);
            request.setAttribute("isSaved", isSaved);
            request.getRequestDispatcher("/WEB-INF/views/job_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
    }
}
