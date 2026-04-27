package controller;

import dal.ApplicationDAO;
import model.Application;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "CandidateInterviewResultsController", urlPatterns = {"/user/interview-results"})
public class CandidateInterviewResultsController extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy tất cả đơn ứng tuyển của ứng viên này
        List<Application> allApps = appDAO.findByCandidateId(userId);

        // Thống kê sơ bộ
        long countPass = allApps.stream().filter(a -> "OFFERED".equals(a.getStatus())).count();
        long countFail = allApps.stream().filter(a -> "REJECTED".equals(a.getStatus())).count();
        long countInterview = allApps.stream().filter(a -> "INTERVIEW_ROUND_2".equals(a.getStatus())).count();
        
        request.setAttribute("countPass", countPass);
        request.setAttribute("countFail", countFail);
        request.setAttribute("countInterview", countInterview);
        request.setAttribute("countTotal", countPass + countFail + countInterview);

        // Lọc ra những đơn ĐÃ CÓ KẾT QUẢ hoặc ĐANG PHỎNG VẤN VÒNG 2
        List<Application> allResults = allApps.stream()
                .filter(app -> "OFFERED".equals(app.getStatus()) 
                            || "REJECTED".equals(app.getStatus())
                            || "INTERVIEW_ROUND_2".equals(app.getStatus()))
                .collect(Collectors.toList());

        // --- Xử lý Tìm kiếm và Lọc ---
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        if (search != null && !search.trim().isEmpty()) {
            String s = search.toLowerCase().trim();
            allResults = allResults.stream()
                    .filter(a -> (a.getJobTitle() != null && a.getJobTitle().toLowerCase().contains(s))
                              || (a.getCompanyName() != null && a.getCompanyName().toLowerCase().contains(s)))
                    .collect(Collectors.toList());
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equals(statusFilter)) {
            allResults = allResults.stream()
                    .filter(a -> statusFilter.equals(a.getStatus()))
                    .collect(Collectors.toList());
        }

        // --- Xử lý phân trang In-Memory ---
        int pageSize = 6;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try { currentPage = Integer.parseInt(pageParam); } catch (Exception e) {}
        }
        
        int totalItems = allResults.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);
        
        List<Application> results = new java.util.ArrayList<>();
        if (start < totalItems) {
            results = allResults.subList(start, end);
        }

        request.setAttribute("results", results);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Lấy thông tin phỏng vấn cho các đơn này (đặc biệt là Vòng 2)
        dal.InterviewDAO interviewDAO = new dal.InterviewDAO();
        java.util.Map<Long, model.Interview> interviews = new java.util.HashMap<>();
        for (Application app : results) {
            model.Interview inter = interviewDAO.findByApplicationId(app.getApplicationId());
            if (inter != null) {
                interviews.put(app.getApplicationId(), inter);
            }
        }
        request.setAttribute("interviews", interviews);

        // --- Gợi ý việc làm tương tự (Recommended Jobs) ---
        List<model.Job> recommendedJobs = new ArrayList<>();
        dal.JobDAO jobDAO = new dal.JobDAO();
        String latestJobTitle = "";
        if (!allApps.isEmpty()) {
            latestJobTitle = allApps.get(0).getJobTitle();
        }
        recommendedJobs = jobDAO.getRecommendedJobs(latestJobTitle, 4);
        request.setAttribute("recommendedJobs", recommendedJobs);

        request.getRequestDispatcher("/WEB-INF/views/interview_results.jsp").forward(request, response);
    }
}
