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

        // Lọc ra những đơn ĐÃ CÓ KẾT QUẢ (Trúng tuyển hoặc Từ chối)
        List<Application> results = allApps.stream()
                .filter(app -> "OFFERED".equals(app.getStatus()) || "REJECTED".equals(app.getStatus()))
                .collect(Collectors.toList());

        request.setAttribute("results", results);
        request.getRequestDispatcher("/WEB-INF/views/interview_results.jsp").forward(request, response);
    }
}
