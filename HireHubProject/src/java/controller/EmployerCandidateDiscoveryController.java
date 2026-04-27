package controller;

import dal.UserDAO;
import dal.JobDAO;
import dal.NotificationDAO;
import model.User;
import model.Job;
import model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "EmployerCandidateDiscoveryController", urlPatterns = {"/employer/candidates"})
public class EmployerCandidateDiscoveryController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final JobDAO jobDAO = new JobDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách toàn bộ ứng viên
        List<User> allCandidates = userDAO.findAllCandidates();
        
        // --- Xử lý phân trang In-Memory ---
        int pageSize = 6;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try { currentPage = Integer.parseInt(pageParam); } catch (Exception e) {}
        }
        
        int totalItems = allCandidates.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);
        
        List<User> pagedCandidates = new java.util.ArrayList<>();
        if (start < totalItems) {
            pagedCandidates = allCandidates.subList(start, end);
        }
        
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        
        // Lấy danh sách công việc đang đăng của nhà tuyển dụng này (để chọn khi mời)
        List<Job> myJobs = jobDAO.findByEmployerId(userId);

        request.setAttribute("candidates", pagedCandidates);
        request.setAttribute("myJobs", myJobs);
        request.getRequestDispatcher("/WEB-INF/views/employer_candidate_discovery.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        Long recruiterUserId = (session != null) ? (Long) session.getAttribute("userId") : null;
        String recruiterName = (session != null) ? (String) session.getAttribute("userFullName") : "Nhà tuyển dụng";

        String action = request.getParameter("action");
        
        if ("invite".equals(action)) {
            try {
                long candidateUserId = Long.parseLong(request.getParameter("candidateUserId"));
                long jobId = Long.parseLong(request.getParameter("jobId"));
                
                Job job = jobDAO.findById(jobId);
                
                if (job != null) {
                    String title = "📩 Lời mời ứng tuyển từ " + recruiterName;
                    String body = recruiterName + " đã xem hồ sơ của bạn và cảm thấy bạn rất phù hợp với vị trí \"" + job.getTitle() + "\". Hãy xem chi tiết và ứng tuyển ngay nhé!";
                    
                    Notification notif = new Notification(candidateUserId, title, body, "INVITATION", jobId);
                    notifDAO.sendToUser(candidateUserId, title, body);
                    
                    response.sendRedirect(request.getContextPath() + "/employer/candidates?success=invited");
                } else {
                    response.sendRedirect(request.getContextPath() + "/employer/candidates?error=failed");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/employer/candidates?error=failed");
            }
        }
    }
}
