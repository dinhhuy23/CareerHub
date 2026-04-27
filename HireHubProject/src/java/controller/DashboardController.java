package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller cho trang Dashboard.
 * Nếu người dùng là RECRUITER -> chuyển sang /employer/dashboard
 * Nếu là CANDIDATE -> hiện trang dashboard.jsp
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/user/dashboard"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra role từ session để chuyển hướng đúng trang
        HttpSession session = request.getSession(false);
        if (session != null) {
            String role = (String) session.getAttribute("userRole");
            if ("RECRUITER".equals(role)) {
                // Recruiter không dùng /user/dashboard, chuyển về employer dashboard
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                return;
            } else if ("ADMIN".equals(role)) {
                // Admin chuyển về trang quản trị
                response.sendRedirect(request.getContextPath() + "/admin/recruiters");
                return;
            }
        }

        // Candidate: hiện trang dashboard bình thường
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}
