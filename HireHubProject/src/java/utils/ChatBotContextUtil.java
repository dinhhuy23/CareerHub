package utils;

import dal.ApplicationDAO;
import dal.CompanyDAO;
import dal.JobDAO;
import jakarta.servlet.http.HttpServletRequest;
import model.Application;
import model.Company;
import model.Job;
import model.User;
import java.util.List;

public class ChatBotContextUtil {

    public static String buildDatabaseContext(HttpServletRequest request) {
        StringBuilder context = new StringBuilder("\n--- DỮ LIỆU THỰC TẾ TỪ HỆ THỐNG ---\n");
        
        // 1. Thông tin người dùng hiện tại
        User user = (User) request.getSession().getAttribute("user");
        if (user != null) {
            context.append("Người dùng hiện tại: ").append(user.getFullName())
                   .append(" (ID: ").append(user.getUserId()).append(")\n");
            
            // Lấy danh sách đơn ứng tuyển của người dùng
            ApplicationDAO appDAO = new ApplicationDAO();
            List<Application> myApps = appDAO.findByCandidateId(user.getUserId());
            if (!myApps.isEmpty()) {
                context.append("Trạng thái ứng tuyển của bạn:\n");
                for (Application app : myApps) {
                    context.append("- Công việc: ").append(app.getJobTitle())
                           .append(", Trạng thái: ").append(app.getStatus()).append("\n");
                }
            }
        } else {
            context.append("Người dùng chưa đăng nhập.\n");
        }

        // 2. Danh sách việc làm mới nhất
        JobDAO jobDAO = new JobDAO();
        // searchAndFilter(keyword, categoryId, locationId, typeId, levelId, offset, fetchSize)
        List<Job> latestJobs = jobDAO.searchAndFilter(null, null, null, null, null, 0, 10);
        if (!latestJobs.isEmpty()) {
            context.append("\nViệc làm mới nhất:\n");
            for (Job j : latestJobs) {
                context.append("- [ID: ").append(j.getJobId()).append("] ")
                       .append(j.getTitle()).append(" tại ").append(j.getCompanyName())
                       .append(" (Lương: ").append(j.getSalaryMin()).append(" - ").append(j.getSalaryMax()).append(")\n");
            }
        }

        // 3. Thông tin công ty tiêu biểu
        CompanyDAO companyDAO = new CompanyDAO();
        List<Company> companies = companyDAO.getAll();
        if (companies != null && !companies.isEmpty()) {
            context.append("\nCông ty tiêu biểu:\n");
            int limit = 5;
            for (int i = 0; i < Math.min(companies.size(), limit); i++) {
                Company c = companies.get(i);
                context.append("- ").append(c.getCompanyName()).append(": ").append(c.getIndustry()).append("\n");
            }
        }

        context.append("-----------------------------------\n");
        context.append("Hãy sử dụng dữ liệu trên để trả lời người dùng. Nếu người dùng hỏi về việc làm hoặc công ty không có trong danh sách, hãy khuyên họ sử dụng thanh tìm kiếm trên web. Luôn trả lời thân thiện bằng tiếng Việt.");
        
        return context.toString();
    }
}
