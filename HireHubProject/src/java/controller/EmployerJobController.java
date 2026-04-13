package controller;

import dal.JobDAO;
import dal.JobCategoryDAO;
import dal.LocationDAO;
import dal.EmploymentTypeDAO;
import dal.ExperienceLevelDAO;
import model.Job;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;

@WebServlet(name = "EmployerJobController", urlPatterns = {"/employer/jobs"})
public class EmployerJobController extends HttpServlet {

    private final JobDAO jobDAO = new JobDAO();
    private final JobCategoryDAO categoryDAO = new JobCategoryDAO();
    private final LocationDAO locationDAO = new LocationDAO();
    private final EmploymentTypeDAO typeDAO = new EmploymentTypeDAO();
    private final ExperienceLevelDAO levelDAO = new ExperienceLevelDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = (Long) request.getAttribute("userId");
        // Load lookups for Modal
        request.setAttribute("categories", categoryDAO.getAllActive());
        request.setAttribute("locations", locationDAO.getAllActive());
        request.setAttribute("employmentTypes", typeDAO.getAllActive());
        request.setAttribute("experienceLevels", levelDAO.getAllActive());

        // Default action: List jobs
        request.setAttribute("jobs", jobDAO.findByEmployerId(userId));
        request.getRequestDispatcher("/WEB-INF/views/employer_jobs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = (Long) request.getAttribute("userId");
        String action = request.getParameter("action");

        if ("status".equals(action)) {
            try {
                long jobId = Long.parseLong(request.getParameter("id"));
                String status = request.getParameter("status"); // CLOSED, PUBLISHED, DELETED
                jobDAO.updateStatus(jobId, userId, status);
                response.sendRedirect(request.getContextPath() + "/employer/jobs");
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
            return;
        }

        // Form submission (create/edit)
        try {
            Job job = new Job();
            String idStr = request.getParameter("jobId");
            if (idStr != null && !idStr.isEmpty()) {
                job.setJobId(Long.parseLong(idStr));
            }
            
            job.setPostedByRecruiterId(userId);
            job.setTitle(request.getParameter("title"));
            job.setDescription(request.getParameter("description"));
            job.setRequirements(request.getParameter("requirements"));
            job.setResponsibilities(request.getParameter("responsibilities"));
            
            String sMin = request.getParameter("salaryMin");
            if (sMin != null && !sMin.isEmpty()) job.setSalaryMin(new BigDecimal(sMin));
            
            String sMax = request.getParameter("salaryMax");
            if (sMax != null && !sMax.isEmpty()) job.setSalaryMax(new BigDecimal(sMax));
            
            job.setCategoryId(parseLongOrNull(request.getParameter("categoryId")));
            job.setLocationId(parseLongOrNull(request.getParameter("locationId")));
            job.setEmploymentTypeId(parseLongOrNull(request.getParameter("employmentTypeId")));
            job.setExperienceLevelId(parseLongOrNull(request.getParameter("experienceLevelId")));
            
            String deadline = request.getParameter("deadlineAt");
            if (deadline != null && !deadline.isEmpty()) {
                job.setDeadlineAt(Timestamp.valueOf(deadline + " 23:59:59"));
            }
            
            job.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "PUBLISHED");

            if (job.getJobId() > 0) {
                jobDAO.update(job);
            } else {
                jobDAO.insert(job);
            }
            
            response.sendRedirect(request.getContextPath() + "/employer/jobs");

        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg == null) msg = e.toString();
            request.setAttribute("errorMessage", "Lỗi lưu tin tuyển dụng: " + msg);
            if (request.getParameter("action") == null) {
                request.setAttribute("action", "create");
            }
            doGet(request, response);
        }
    }

    private Long parseLongOrNull(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try { return Long.parseLong(val); } catch (NumberFormatException e) { return null; }
    }
}
