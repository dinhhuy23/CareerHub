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

        // --- Tính toán thống kê ---
        long totalResults = allApps.stream()
                .filter(app -> "OFFERED".equals(app.getStatus()) || "REJECTED".equals(app.getStatus()) || "INTERVIEW_ROUND_2".equals(app.getStatus()))
                .count();
        long totalOffered = allApps.stream().filter(app -> "OFFERED".equals(app.getStatus())).count();
        long totalUpcoming = allApps.stream().filter(app -> "INTERVIEW_ROUND_2".equals(app.getStatus())).count();
        
        request.setAttribute("totalResults", totalResults);
        request.setAttribute("totalOffered", totalOffered);
        request.setAttribute("totalUpcoming", totalUpcoming);

        // Lọc ra những đơn ĐÃ CÓ KẾT QUẢ hoặc ĐANG PHỎNG VẤN VÒNG 2
        List<Application> allFilteredResults = allApps.stream()
                .filter(app -> "OFFERED".equals(app.getStatus()) 
                            || "REJECTED".equals(app.getStatus())
                            || "INTERVIEW_ROUND_2".equals(app.getStatus()))
                .collect(Collectors.toList());

        // Xử lý Filter Search (nếu có)
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("statusFilter");

        if (search != null && !search.trim().isEmpty()) {
            String s = search.trim().toLowerCase();
            allFilteredResults = allFilteredResults.stream()
                    .filter(app -> (app.getJobTitle() != null && app.getJobTitle().toLowerCase().contains(s))
                                || (app.getCompanyName() != null && app.getCompanyName().toLowerCase().contains(s)))
                    .collect(Collectors.toList());
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equals(statusFilter)) {
            allFilteredResults = allFilteredResults.stream()
                    .filter(app -> statusFilter.equals(app.getStatus()))
                    .collect(Collectors.toList());
        }

        // --- Xử lý phân trang In-Memory ---
        int pageSize = 6;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try { currentPage = Integer.parseInt(pageParam); } catch (Exception e) {}
        }
        
        int totalItems = allFilteredResults.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);
        
        List<Application> results = new java.util.ArrayList<>();
        if (start < totalItems) {
            results = allFilteredResults.subList(start, end);
        }

        request.setAttribute("results", results);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("statusFilter", statusFilter);

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

        request.getRequestDispatcher("/WEB-INF/views/interview_results.jsp").forward(request, response);
    }
}
