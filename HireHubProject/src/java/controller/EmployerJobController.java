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

        // Lấy thông tin filter từ URL
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        // Lấy danh sách toàn bộ tin tuyển dụng (có lọc)
        java.util.List<Job> allJobs = jobDAO.findByEmployerId(userId, keyword, status);
        
        // --- Xử lý phân trang In-Memory ---
        int pageSize = 6;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try { currentPage = Integer.parseInt(pageParam); } catch (Exception e) {}
        }
        
        int totalItems = allJobs.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);
        
        java.util.List<Job> pagedJobs = new java.util.ArrayList<>();
        if (start < totalItems) {
            pagedJobs = allJobs.subList(start, end);
        }

        // Default action: List jobs (với filter)
        request.setAttribute("jobs", pagedJobs);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("searchStatus", status);
        
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

            // ==========================================================
            // SERVER-SIDE VALIDATION
            // ==========================================================

            // [1] Tiêu đề công việc: Bắt buộc, tối thiểu 5 ký tự, tối đa 200 ký tự
            String title = trimToNull(request.getParameter("title"));
            if (title == null) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Tiêu đề công việc không được để trống.");
                return;
            }
            if (title.length() < 5) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Tiêu đề công việc phải có ít nhất 5 ký tự.");
                return;
            }
            if (title.length() > 200) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Tiêu đề công việc không được vượt quá 200 ký tự.");
                return;
            }
            job.setTitle(title);

            // [2] Danh mục: Bắt buộc phải chọn
            Long categoryId = parseLongOrNull(request.getParameter("categoryId"));
            if (categoryId == null) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Vui lòng chọn Danh mục công việc.");
                return;
            }
            job.setCategoryId(categoryId);

            // [3] Địa điểm: Bắt buộc phải chọn
            Long locationId = parseLongOrNull(request.getParameter("locationId"));
            if (locationId == null) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Vui lòng chọn Địa điểm làm việc.");
                return;
            }
            job.setLocationId(locationId);

            // [4] Hình thức làm việc: Bắt buộc phải chọn
            Long typeId = parseLongOrNull(request.getParameter("employmentTypeId"));
            if (typeId == null) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Vui lòng chọn Hình thức làm việc.");
                return;
            }
            job.setEmploymentTypeId(typeId);

            // [5] Yêu cầu kinh nghiệm: Bắt buộc phải chọn
            Long levelId = parseLongOrNull(request.getParameter("experienceLevelId"));
            if (levelId == null) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Vui lòng chọn mức Kinh nghiệm yêu cầu.");
                return;
            }
            job.setExperienceLevelId(levelId);

            // [6] Mức lương: Không âm, tối thiểu < tối đa, nếu nhập 1 thì phải nhập cả 2
            String salaryMinRaw = request.getParameter("salaryMin");
            String salaryMaxRaw = request.getParameter("salaryMax");
            BigDecimal salaryMin = null;
            BigDecimal salaryMax = null;

            boolean hasMin = salaryMinRaw != null && !salaryMinRaw.trim().isEmpty();
            boolean hasMax = salaryMaxRaw != null && !salaryMaxRaw.trim().isEmpty();

            if (hasMin) {
                salaryMin = new BigDecimal(salaryMinRaw.trim());
                if (salaryMin.compareTo(BigDecimal.ZERO) < 0) {
                    forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Mức lương tối thiểu không được là số âm.");
                    return;
                }
                if (salaryMin.compareTo(new BigDecimal("100000")) < 0) {
                    forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Mức lương tối thiểu phải từ 100,000 VND trở lên.");
                    return;
                }
                job.setSalaryMin(salaryMin);
            }
            if (hasMax) {
                salaryMax = new BigDecimal(salaryMaxRaw.trim());
                if (salaryMax.compareTo(BigDecimal.ZERO) < 0) {
                    forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Mức lương tối đa không được là số âm.");
                    return;
                }
                job.setSalaryMax(salaryMax);
            }
            if (hasMin != hasMax) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Vui lòng nhập cả mức lương tối thiểu và tối đa, hoặc để trống cả hai (Thỏa thuận).");
                return;
            }
            if (salaryMin != null && salaryMax != null && salaryMin.compareTo(salaryMax) >= 0) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Mức lương tối thiểu phải nhỏ hơn mức lương tối đa.");
                return;
            }

            // [7] Hạn nộp hồ sơ: Bắt buộc, phải từ ngày hôm nay trở đi
            String deadlineRaw = request.getParameter("deadlineAt");
            if (deadlineRaw == null || deadlineRaw.trim().isEmpty()) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Vui lòng chọn Hạn nộp hồ sơ.");
                return;
            }
            Timestamp deadlineTs = Timestamp.valueOf(deadlineRaw.trim() + " 23:59:59");
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate deadlineDate = deadlineTs.toLocalDateTime().toLocalDate();
            if (deadlineDate.isBefore(today)) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Hạn nộp hồ sơ phải là ngày hôm nay hoặc trong tương lai.");
                return;
            }
            if (deadlineDate.isAfter(today.plusYears(1))) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Hạn nộp hồ sơ không được quá 1 năm kể từ hôm nay.");
                return;
            }
            job.setDeadlineAt(deadlineTs);

            // [8] Mô tả công việc: Bắt buộc, tối thiểu 30 ký tự
            String description = trimToNull(request.getParameter("description"));
            if (description == null) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Mô tả công việc không được để trống.");
                return;
            }
            if (description.length() < 30) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Mô tả công việc phải có ít nhất 30 ký tự.");
                return;
            }
            job.setDescription(description);

            // [9] Yêu cầu ứng viên: Bắt buộc, tối thiểu 20 ký tự
            String requirements = trimToNull(request.getParameter("requirements"));
            if (requirements == null) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Yêu cầu ứng viên không được để trống.");
                return;
            }
            if (requirements.length() < 20) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Yêu cầu ứng viên phải có ít nhất 20 ký tự.");
                return;
            }
            job.setRequirements(requirements);

            // [10] Quyền lợi: Không bắt buộc, nhưng nếu có thì tối thiểu 10 ký tự
            String responsibilities = trimToNull(request.getParameter("responsibilities"));
            if (responsibilities != null && responsibilities.length() < 10) {
                forwardFormWithError(request, response, buildJobFromRequest(request, userId), "Quyền lợi nếu nhập phải có ít nhất 10 ký tự.");
                return;
            }
            job.setResponsibilities(responsibilities);

            // [11] Trạng thái: Chỉ cho phép các giá trị hợp lệ
            String status = request.getParameter("status");
            if (status == null || (!status.equals("PUBLISHED") && !status.equals("DRAFT"))) {
                status = "PUBLISHED";
            }
            job.setStatus(status);

            // ==========================================================
            // LƯU VÀO DATABASE
            // ==========================================================
            if (job.getJobId() > 0) {
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