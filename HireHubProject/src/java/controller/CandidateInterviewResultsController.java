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

        // Lọc ra những đơn ĐÃ CÓ KẾT QUẢ hoặc ĐANG PHỎNG VẤN VÒNG 2
        List<Application> results = allApps.stream()
                .filter(app -> "OFFERED".equals(app.getStatus()) 
                            || "REJECTED".equals(app.getStatus())
                            || "INTERVIEW_ROUND_2".equals(app.getStatus()))
                .collect(Collectors.toList());

        request.setAttribute("results", results);

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
