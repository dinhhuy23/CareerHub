package controller;

import dal.ApplicationDAO;
import dal.NotificationDAO;
import model.Application;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller: Trang "Hồ sơ đã ứng tuyển" dành cho Ứng viên (Candidate).
 * URL: GET  /user/my-applications      → Hiển thị danh sách đơn đã nộp
 * URL: POST /user/my-applications      → Rút đơn ứng tuyển (action=withdraw)
 */
@WebServlet(name = "CandidateApplicationController", urlPatterns = {"/user/my-applications"})
public class CandidateApplicationController extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy userId từ session (AuthenticationFilter đã xác thực)
        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Chỉ CANDIDATE được dùng trang này
        String role = (String) session.getAttribute("userRole");
        if (!"CANDIDATE".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            return;
        }

        // Lấy danh sách đơn của ứng viên này
        List<Application> applications = appDAO.findByCandidateId(userId);
        request.setAttribute("applications", applications);

        // Đánh dấu đã đọc các thông báo khi vào trang này
        notifDAO.markAllAsRead(userId);

        request.getRequestDispatcher("/WEB-INF/views/my_applications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Xử lý việc rút đơn ứng tuyển
        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("withdraw".equals(action)) {
            try {
                long appId = Long.parseLong(request.getParameter("applicationId"));
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "Không có lý do cụ thể";
                }
                
                // Hàm withdraw giờ chuyển sang trạng thái WITHDRAW_REQUESTED và lưu lý do
                boolean ok = appDAO.withdraw(appId, userId, reason);
                if (ok) {
                    response.sendRedirect(request.getContextPath() + "/user/my-applications?success=withdraw_requested");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/my-applications?error=cannot_withdraw");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/user/my-applications");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/user/my-applications");
        }
    }
}
