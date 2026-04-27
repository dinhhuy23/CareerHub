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

@WebServlet(name = "ManageCVServlet", urlPatterns = {"/user/cv/manage_cv"})
public class ManageCVServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");

        // 1. Kiem tra dang nhap
        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdObj.toString());
            UserCVDAO cvDAO = new UserCVDAO();

            // 2. Lay danh sach CV (ORDER BY UpdatedAt DESC — CV moi nhat o dau)
            List<UserCV> userCVs = cvDAO.getCVsByUserId(userId);

            // 3. Lay targetRole tu CV MOI NHAT co targetRole khong trong
            //    (getCVsByUserId da ORDER BY UpdatedAt DESC nen phan tu dau = moi nhat)
            String targetRole = "";
            if (userCVs != null) {
                for (UserCV cv : userCVs) {
                    if (cv.getTargetRole() != null && !cv.getTargetRole().trim().isEmpty()) {
                        targetRole = cv.getTargetRole().trim();
                        break;
                    }
                }
            }

            // 4. Lay 5 viec lam phu hop nhat theo targetRole cua CV moi nhat
            dal.JobDAO jobDAO = new dal.JobDAO();
            List<model.Job> recommendedJobs = jobDAO.getRecommendedJobs(targetRole, 5);

            // 5. Day du lieu sang JSP
            request.setAttribute("cvList", userCVs);
            request.setAttribute("jobList", recommendedJobs);
            // targetRoleDisplay de JSP hien thi: Viec lam "Nhan vien kinh doanh" phu hop voi CV cua ban
            request.setAttribute("targetRoleDisplay", targetRole);
            request.getRequestDispatcher("/WEB-INF/views/manage_cv.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}