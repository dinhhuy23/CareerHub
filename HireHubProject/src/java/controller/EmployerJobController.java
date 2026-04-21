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
    private final dal.RecruiterDAO recruiterDAO = new dal.RecruiterDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long userId = (Long) request.getAttribute("userId");
        


        loadFormLookups(request);

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

        try {
            Job job = new Job();

            String idStr = request.getParameter("jobId");
            if (idStr != null && !idStr.trim().isEmpty()) {
                job.setJobId(Long.parseLong(idStr));
            }

            job.setPostedByRecruiterId(userId);
            job.setTitle(trimToNull(request.getParameter("title")));
            job.setDescription(trimToNull(request.getParameter("description")));
            job.setRequirements(trimToNull(request.getParameter("requirements")));
            job.setResponsibilities(trimToNull(request.getParameter("responsibilities")));

            String salaryMinRaw = request.getParameter("salaryMin");
            String salaryMaxRaw = request.getParameter("salaryMax");

            BigDecimal salaryMin = null;
            BigDecimal salaryMax = null;

            if (salaryMinRaw != null && !salaryMinRaw.trim().isEmpty()) {
                salaryMin = new BigDecimal(salaryMinRaw.trim());
                if (salaryMin.compareTo(BigDecimal.ZERO) < 0) {
                    forwardFormWithError(request, response, job, "Mức lương tối thiểu không được là số âm.");
                    return;
                }
                job.setSalaryMin(salaryMin);
            }

            if (salaryMaxRaw != null && !salaryMaxRaw.trim().isEmpty()) {
                salaryMax = new BigDecimal(salaryMaxRaw.trim());
                if (salaryMax.compareTo(BigDecimal.ZERO) < 0) {
                    forwardFormWithError(request, response, job, "tiền lương không được âm ");
                    return;
                }
                job.setSalaryMax(salaryMax);
            }

            if (salaryMin != null && salaryMax != null && salaryMin.compareTo(salaryMax) > 0) {
                forwardFormWithError(request, response, job, "Mức lương tối thiểu không được lớn hơn mức lương tối đa.");
                return;
            }

            job.setCategoryId(parseLongOrNull(request.getParameter("categoryId")));
            job.setLocationId(parseLongOrNull(request.getParameter("locationId")));
            job.setEmploymentTypeId(parseLongOrNull(request.getParameter("employmentTypeId")));
            job.setExperienceLevelId(parseLongOrNull(request.getParameter("experienceLevelId")));

            String deadline = request.getParameter("deadlineAt");
            if (deadline != null && !deadline.trim().isEmpty()) {
                job.setDeadlineAt(Timestamp.valueOf(deadline.trim() + " 23:59:59"));
            }

            String status = request.getParameter("status");
            job.setStatus((status != null && !status.trim().isEmpty()) ? status.trim() : "PUBLISHED");

            if (job.getJobId() < 0) {
                jobDAO.update(job);
            } else {
                jobDAO.insert(job);
            }

            response.sendRedirect(request.getContextPath() + "/employer/jobs");

        } catch (NumberFormatException e) {
            Job job = buildJobFromRequest(request, userId);
            forwardFormWithError(request, response, job, "Giá trị lương không hợp lệ.");
        } catch (Exception e) {
            Job job = buildJobFromRequest(request, userId);
            String msg = e.getMessage();
            if (msg == null || msg.trim().isEmpty()) {
                msg = e.toString();
            }
            forwardFormWithError(request, response, job, "Lỗi lưu tin tuyển dụng: " + msg);
        }
    }

    private void loadFormLookups(HttpServletRequest request) {
        request.setAttribute("categories", categoryDAO.getAllActive());
        request.setAttribute("locations", locationDAO.getAllActive());
        request.setAttribute("employmentTypes", typeDAO.getAllActive());
        request.setAttribute("experienceLevels", levelDAO.getAllActive());
    }

    private void forwardFormWithError(HttpServletRequest request, HttpServletResponse response, Job job, String errorMessage)
            throws ServletException, IOException {
        loadFormLookups(request);
        request.setAttribute("job", job);
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/views/employer_job_form.jsp").forward(request, response);
    }

    private Job buildJobFromRequest(HttpServletRequest request, Long userId) {
        Job job = new Job();

        try {
            String idStr = request.getParameter("jobId");
            if (idStr != null && !idStr.trim().isEmpty()) {
                job.setJobId(Long.parseLong(idStr));
            }
        } catch (Exception e) {
            // ignore
        }

        job.setPostedByRecruiterId(userId);
        job.setTitle(trimToNull(request.getParameter("title")));
        job.setDescription(trimToNull(request.getParameter("description")));
        job.setRequirements(trimToNull(request.getParameter("requirements")));
        job.setResponsibilities(trimToNull(request.getParameter("responsibilities")));
        job.setCategoryId(parseLongOrNull(request.getParameter("categoryId")));
        job.setLocationId(parseLongOrNull(request.getParameter("locationId")));
        job.setEmploymentTypeId(parseLongOrNull(request.getParameter("employmentTypeId")));
        job.setExperienceLevelId(parseLongOrNull(request.getParameter("experienceLevelId")));

        try {
            String salaryMinRaw = request.getParameter("salaryMin");
            if (salaryMinRaw != null && !salaryMinRaw.trim().isEmpty()) {
                job.setSalaryMin(new BigDecimal(salaryMinRaw.trim()));
            }
        } catch (Exception e) {
            // ignore
        }

        try {
            String salaryMaxRaw = request.getParameter("salaryMax");
            if (salaryMaxRaw != null && !salaryMaxRaw.trim().isEmpty()) {
                job.setSalaryMax(new BigDecimal(salaryMaxRaw.trim()));
            }
        } catch (Exception e) {
            // ignore
        }

        try {
            String deadline = request.getParameter("deadlineAt");
            if (deadline != null && !deadline.trim().isEmpty()) {
                job.setDeadlineAt(Timestamp.valueOf(deadline.trim() + " 23:59:59"));
            }
        } catch (Exception e) {
            // ignore
        }

        String status = request.getParameter("status");
        job.setStatus((status != null && !status.trim().isEmpty()) ? status.trim() : "PUBLISHED");

        return job;
    }

    private Long parseLongOrNull(String val) {
        if (val == null || val.trim().isEmpty()) {
            return null;
        }
        try {
            return Long.parseLong(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trimToNull(String val) {
        if (val == null) {
            return null;
        }
        String trimmed = val.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }


}