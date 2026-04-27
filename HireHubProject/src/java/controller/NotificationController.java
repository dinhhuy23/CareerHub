package controller;

import dal.NotificationDAO;
import model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller: Quản lý thông báo của người dùng.
 * URL: GET  /user/notifications  → Danh sách thông báo (đánh dấu all đã đọc)
 * URL: POST /user/notifications  → Đánh dấu một thông báo đã đọc (AJAX)
 */
@WebServlet(name = "NotificationController", urlPatterns = {"/user/notifications"})
public class NotificationController extends HttpServlet {

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

        // Lấy danh sách thông báo
        List<Notification> notifications = notifDAO.findByUserId(userId);
        request.setAttribute("notifications", notifications);

        // Đánh dấu hết là đã đọc ngay khi mở trang
        notifDAO.markAllAsRead(userId);

        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
    }
}
