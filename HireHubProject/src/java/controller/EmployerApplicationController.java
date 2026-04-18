package controller;

import dal.ApplicationDAO;
import dal.NotificationDAO;
import model.Application;
import model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "EmployerApplicationController", urlPatterns = {"/employer/applications", "/employer/application/status"})
public class EmployerApplicationController extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy userId từ sessionScope (AuthorizationFilter đã kiểm tra quyền RECRUITER)
        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách hồ sơ ứng tuyển của tất cả các job do người này đăng
        List<Application> applications = appDAO.findByEmployerId(userId);
        request.setAttribute("applications", applications);
        request.getRequestDispatcher("/WEB-INF/views/employer_applications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        // Xử lý cập nhật trạng thái ứng cử viên (Duyệt hồ sơ, Phỏng vấn,...)
        try {
            long appId = Long.parseLong(request.getParameter("applicationId"));
            String status = request.getParameter("status"); // Lấy giá trị từ thẻ <select>
            String hrNote = request.getParameter("hrNote"); // Ghi chú nội bộ của HR

            // Lấy thông tin đơn để biết CandidateId nhằm gửi thông báo
            Application app = appDAO.findById(appId);

            boolean success = appDAO.updateStatus(appId, status);

            // Cập nhật ghi chú nội bộ nếu có nhập
            if (hrNote != null && !hrNote.trim().isEmpty()) {
                appDAO.updateHRNote(appId, hrNote.trim());
            }

            // Nếu trạng thái là phỏng vấn, tạo record phỏng vấn luôn
            if (success && "INTERVIEWING".equals(status)) {
                String startAtStr = request.getParameter("startAt");
                String meetingLink = request.getParameter("meetingLink");
                String interviewNote = request.getParameter("interviewNote");
                
                if (startAtStr != null && !startAtStr.trim().isEmpty()) {
                    try {
                        model.Interview interview = new model.Interview();
                        interview.setApplicationId(appId);
                        
                        // Parse datetime-local. Format is yyyy-MM-dd'T'HH:mm
                        startAtStr = startAtStr.replace("T", " ") + ":00";
                        interview.setStartAt(java.sql.Timestamp.valueOf(startAtStr));
                        
                        // Tạm cho endAt = startAt + 1 hour
                        long oneHourAndHalf = 1 * 60 * 60 * 1000;
                        interview.setEndAt(new java.sql.Timestamp(interview.getStartAt().getTime() + oneHourAndHalf));
                        
                        interview.setScheduledByUserId(userId);
                        interview.setMeetingLink(meetingLink);
                        interview.setNote(interviewNote);
                        interview.setStatus("SCHEDULED");
                        
                        dal.InterviewDAO interviewDAO = new dal.InterviewDAO();
                        interviewDAO.insert(interview);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }

            // Tự động gửi thông báo cho Ứng viên khi HR thay đổi trạng thái
            if (success && app != null) {
                String msgTitle = getNotificationTitle(status);
                String msgBody  = "Đơn ứng tuyển \"" + (app.getJobTitle() != null ? app.getJobTitle() : "của bạn") + "\" đã được cập nhật trạng thái: " + status;
                Notification notif = new Notification(app.getCandidateId(), msgTitle, msgBody, "APPLICATION_UPDATE", appId);
                notifDAO.insert(notif);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/employer/applications?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/employer/applications?error=failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/employer/applications");
        }
    }

    // Helper: Tạo tiêu đề thông báo theo trạng thái
    private String getNotificationTitle(String status) {
        switch (status) {
            case "REVIEWING":    return "📋 Hồ sơ đang được xem xét";
            case "INTERVIEWING": return "📅 Bạn được mời phỏng vấn!";
            case "OFFERED":      return "🎉 Chúc mừng! Bạn đã trúng tuyển!";
            case "REJECTED":     return "📩 Thông báo kết quả ứng tuyển";
            default:             return "🔔 Cập nhật trạng thái ứng tuyển";
        }
    }
}
