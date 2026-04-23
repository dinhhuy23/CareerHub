package controller;

import dal.SavedJobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SaveJobController", urlPatterns = { "/user/save-job" })
public class SaveJobController extends HttpServlet {

    private final SavedJobDAO savedJobDAO = new SavedJobDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        jakarta.servlet.http.HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;

        if (userId == null || !"CANDIDATE".equals(userRole)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập tài khoản ứng viên\"}");
            return;
        }

        try {
            long jobId = Long.parseLong(request.getParameter("jobId"));
            String action = request.getParameter("action");

            boolean result = false;

            if ("save".equals(action)) {
                result = savedJobDAO.saveJob(userId, jobId);
            } else if ("unsave".equals(action)) {
                result = savedJobDAO.unsaveJob(userId, jobId);
            } else if ("toggle-favorite".equals(action)) {
                result = savedJobDAO.toggleFavorite(userId, jobId);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Action không hợp lệ\"}");
                return;
            }

            if (result) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Cập nhật thất bại\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Job ID không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi hệ thống\"}");
        }
    }
}