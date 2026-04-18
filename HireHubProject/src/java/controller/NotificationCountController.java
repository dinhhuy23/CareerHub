package controller;

import dal.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Controller AJAX: Trả về số thông báo chưa đọc dưới dạng JSON.
 * URL: GET /user/notifications/count → { "count": 3 }
 * Được gọi bởi header.jsp để cập nhật badge chuông.
 */
@WebServlet(name = "NotificationCountController", urlPatterns = {"/user/notifications/count"})
public class NotificationCountController extends HttpServlet {

    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        PrintWriter out = response.getWriter();
        if (userId == null) {
            out.write("{\"count\":0}");
        } else {
            int count = notifDAO.countUnread(userId);
            out.write("{\"count\":" + count + "}");
        }
    }
}
