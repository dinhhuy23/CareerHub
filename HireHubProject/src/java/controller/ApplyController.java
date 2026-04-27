package controller;

import dal.ApplicationDAO;
import dal.UserCVDAO;
import model.Application;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ApplyController", urlPatterns = {"/job/apply"})
public class ApplyController extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Long userId = null;
        if (session != null) {
            Object obj = session.getAttribute("userId");
            if (obj instanceof Long) userId = (Long) obj;
            else if (obj != null) { try { userId = Long.parseLong(obj.toString()); } catch (Exception e) {} }
        }

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"CANDIDATE".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        try {
            long jobId = Long.parseLong(request.getParameter("jobId"));
            String coverLetter = request.getParameter("coverLetter");

            // Kiem tra da nop don chua
            if (appDAO.hasAlreadyApplied(userId, jobId)) {
                response.sendRedirect(request.getContextPath() + "/job-detail?id=" + jobId + "&error=already_applied");
                return;
            }

            // Doc selectedCvId tu form (dropdown chon CV)
            String selectedCvIdStr = request.getParameter("selectedCvId");
            Long selectedCvId = null;
            if (selectedCvIdStr != null && !selectedCvIdStr.trim().isEmpty()) {
                try { selectedCvId = Long.parseLong(selectedCvIdStr); } catch (Exception e) {}
            }

            // Neu khong chon CV nao, bao loi
            if (selectedCvId == null) {
                response.sendRedirect(request.getContextPath() + "/job-detail?id=" + jobId + "&error=no_cv_selected");
                return;
            }

            // Tao don ung tuyen
            Application app = new Application();
            app.setJobId(jobId);
            app.setCandidateId(userId);
            app.setUserCVId(selectedCvId);  // Luu UserCVId chinh xac
            app.setCoverLetter(coverLetter);
            app.setStatus("PENDING");

            long appId = appDAO.insert(app);
            if (appId > 0) {
                response.sendRedirect(request.getContextPath() + "/job-detail?id=" + jobId + "&success=applied");
            } else {
                response.sendRedirect(request.getContextPath() + "/job-detail?id=" + jobId + "&error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
    }
}
