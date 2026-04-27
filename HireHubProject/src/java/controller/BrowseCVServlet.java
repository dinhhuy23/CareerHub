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
 * Servlet xu ly viec hien thi va tim kiem danh sach CV cho nha tuyen dung.
 */
@WebServlet(name = "BrowseCVServlet", urlPatterns = {"/employer/browse_cv"})
public class BrowseCVServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null || !role.equals("RECRUITER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // --- Params ---
            String keyword = request.getParameter("keyword");
            if (keyword == null) keyword = "";

            // cvType: "all" | "web" | "upload"
            String cvType = request.getParameter("cvType");
            if (cvType == null || cvType.isEmpty()) cvType = "all";

            // sort: "newest" | "az"
            String sort = request.getParameter("sort");
            if (sort == null || sort.isEmpty()) sort = "newest";

            String pageStr = request.getParameter("page");
            int pageNum = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                try { pageNum = Integer.parseInt(pageStr); } catch (Exception e) {}
            }
            int pageSize = 9; // 3x3 grid

            // Map cvType -> isUploadFilter
            Integer isUploadFilter = null;
            if ("web".equals(cvType))    isUploadFilter = 0;
            if ("upload".equals(cvType)) isUploadFilter = 1;

            UserCVDAO dao = new UserCVDAO();

            int totalCVs   = dao.countSearchableCVs(keyword, isUploadFilter);
            int totalPages = (int) Math.ceil((double) totalCVs / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (pageNum > totalPages) pageNum = totalPages;

            List<UserCV> listCV = dao.getSearchableCVsPaginated(keyword, pageNum, pageSize, isUploadFilter, sort);

            // Stats: tong toan bo (khong filter keyword/type)
            int totalAll = dao.countSearchableCVs("", null);

            request.setAttribute("listCV",      listCV);
            request.setAttribute("currentPage", pageNum);
            request.setAttribute("totalPages",  totalPages);
            request.setAttribute("totalCVs",    totalCVs);
            request.setAttribute("totalAll",    totalAll);
            request.setAttribute("keyword",     keyword);
            request.setAttribute("cvType",      cvType);
            request.setAttribute("sort",        sort);

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
