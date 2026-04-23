package controller;

import dal.UserCVDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.UserCV;

/**
 * Servlet xử lý việc hiển thị và tìm kiếm danh sách CV cho nhà tuyển dụng.
 * Author: ADMIN
 */
@WebServlet(name = "BrowseCVServlet", urlPatterns = {"/employer/browse_cv"})
public class BrowseCVServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        // Lấy roleCode từ session (được lưu từ LoginController)
        String role = (String) session.getAttribute("userRole");

        // Kiểm tra quyền truy cập dựa trên class User (String roleCode)
        if (role == null || !role.equals("RECRUITER")) {
            // Nếu không phải RECRUITER, chuyển hướng về trang login hoặc jobs
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            UserCVDAO dao = new UserCVDAO();
            // Lấy toàn bộ danh sách ứng viên công khai
            List<UserCV> listCV = dao.getAllPublicCVs();

            request.setAttribute("listCV", listCV);
            request.getRequestDispatcher("/WEB-INF/views/browse_cv.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
