package dal;

import model.Application;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ApplicationDAO {
    private final DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(ApplicationDAO.class.getName());

    public ApplicationDAO() {
        this.dbContext = new DBContext();
    }
    
    // Helper lấy RecruiterId thực tế nếu tham số truyền vào là UserId
    private long getActualRecruiterId(long userId) {
        String sql = "SELECT RecruiterId FROM RecruiterProfiles WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error converting userId to recruiterId", e);
        }
        return userId;
    }

    // Chuyển đổi từ ResultSet sang đối tượng Application (bao gồm cả các trường join)
    // KHỚP VỚI SCHEMA THỰC: CurrentStatus (lấy từ ApplicationStatuses)
    private Application mapResultSetToApplication(ResultSet rs) throws SQLException {
        Application app = new Application();
        app.setApplicationId(rs.getLong("ApplicationId"));
        app.setJobId(rs.getLong("JobId"));
        
        // Cực kì quan trọng: Chúng ta dùng CandidateUserId (lấy từ bảng Users thông qua JOIN) 
        // gán vào CandidateId của Model để Controller có thể gửi Notification được cho đúng tài khoản User
        try { app.setCandidateId(rs.getLong("CandidateUserId")); } catch (Exception e) {}
        
        app.setStatus(rs.getString("CurrentStatus"));           // Tên cột thực đã JOIN
        app.setCoverLetter(rs.getString("CoverLetter"));
        try { app.setCvUrl(rs.getString("CvUrl")); } catch (Exception e) {}
        app.setAppliedAt(rs.getTimestamp("AppliedAt"));
        try { app.setUpdatedAt(rs.getTimestamp("LastStatusChangedAt")); } catch (Exception e) {}
        try { app.setHrNote(rs.getString("RecruiterNote")); } catch (Exception e) {}

        // Các trường join từ bảng Jobs và Users
        try { app.setJobTitle(rs.getString("Title")); } catch (Exception e) {}
        try { app.setCandidateName(rs.getString("FullName")); } catch (Exception e) {}
        try { app.setCandidateEmail(rs.getString("Email")); } catch (Exception e) {}
        try { app.setCandidateAvatar(rs.getString("AvatarUrl")); } catch (Exception e) {}
        try { app.setCompanyName(rs.getString("CompanyName")); } catch (Exception e) {}
        return app;
    }

    // Hàm thêm mới đơn ứng tuyển vào Database
    // KHỚP SCHEMA: Tìm đúng ApplicationStatusId của statusCode và Convert UserId thành CandidateProfileId
    public long insert(Application app) {
         String sql = "INSERT INTO Applications (JobId, CandidateId, ResumeId, CoverLetter, CurrentStatusId, UserCVId, AppliedAt, LastStatusChangedAt) "
                   + "VALUES (?, (SELECT CandidateId FROM CandidateProfiles WHERE UserId = ?), ?, ?, "
                   + "(SELECT TOP 1 ApplicationStatusId FROM ApplicationStatuses WHERE StatusCode = ?), "
                   + "?, SYSUTCDATETIME(), SYSUTCDATETIME())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, app.getJobId());
            ps.setLong(2, app.getCandidateId()); // Ở đây app.getCandidateId() đang là UserId từ Controller truyền vào
            if (app.getResumeId() != null) { ps.setLong(3, app.getResumeId()); } else { ps.setNull(3, java.sql.Types.BIGINT); }
            ps.setString(4, app.getCoverLetter());
            ps.setString(5, app.getStatus() != null ? app.getStatus() : "PENDING");
            if (app.getUserCVId() != null) { ps.setLong(6, app.getUserCVId()); } else { ps.setNull(6, java.sql.Types.BIGINT); }

            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting application", e);
        }
        return -1;
    }

    // Hàm lấy danh sách hồ sơ ứng tuyển của một Nhà tuyển dụng, có hỗ trợ lọc theo JobId và từ khóa
    public List<Application> findByEmployerId(long userId, Long jobId, String keyword) {
        long trueRecruiterId = getActualRecruiterId(userId);
        List<Application> list = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
                     "SELECT a.*, ast.StatusCode AS CurrentStatus, u.UserId AS CandidateUserId, "
                   + "j.Title, u.FullName, u.Email, u.AvatarUrl, cr.FileUrl AS CvUrl "
                   + "FROM Applications a "
                   + "JOIN ApplicationStatuses ast ON a.CurrentStatusId = ast.ApplicationStatusId "
                   + "JOIN Jobs j ON a.JobId = j.JobId "
                   + "JOIN CandidateProfiles cp ON a.CandidateId = cp.CandidateId "
                   + "JOIN Users u ON cp.UserId = u.UserId "
                   + "LEFT JOIN CandidateResumes cr ON a.ResumeId = cr.ResumeId "
                   + "WHERE j.PostedByRecruiterId = ? ");
        
        List<Object> params = new ArrayList<>();
        params.add(trueRecruiterId);

        if (jobId != null && jobId > 0) {
            sql.append("AND j.JobId = ? ");
            params.add(jobId);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (u.FullName LIKE ? OR u.Email LIKE ? OR j.Title LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        sql.append("ORDER BY a.AppliedAt DESC");
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToApplication(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding applications by employer", e);
        }
        return list;
    }

    // Hàm lấy danh sách tất cả ứng viên nộp vào các job của một Nhà tuyển dụng
    public List<Application> findByEmployerId(long userId) {
        return findByEmployerId(userId, null, null);
    }

    // ==========================================
    // MỚI: Lấy TẤT CẢ hồ sơ của tất cả user nộp cho ADMIN quản lý
    // ==========================================
    public List<Application> findAll() {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, ast.StatusCode AS CurrentStatus, u.UserId AS CandidateUserId, "
                   + "j.Title, u.FullName, u.Email, u.AvatarUrl, cr.FileUrl AS CvUrl, c.CompanyName "
                   + "FROM Applications a "
                   + "JOIN ApplicationStatuses ast ON a.CurrentStatusId = ast.ApplicationStatusId "
                   + "JOIN Jobs j ON a.JobId = j.JobId "
                   + "JOIN CandidateProfiles cp ON a.CandidateId = cp.CandidateId "
                   + "JOIN Users u ON cp.UserId = u.UserId "
                   + "LEFT JOIN CandidateResumes cr ON a.ResumeId = cr.ResumeId "
                   + "LEFT JOIN RecruiterProfiles rp ON j.PostedByRecruiterId = rp.RecruiterId "
                   + "LEFT JOIN Companies c ON rp.CompanyId = c.CompanyId "
                   + "ORDER BY a.AppliedAt DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToApplication(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all applications for Admin", e);
        }
        return list;
    }

    // Cập nhật trạng thái ứng tuyển (VD: Từ Chờ duyệt sang Phỏng vấn)
    // KHỚP SCHEMA: CurrentStatusId
    public boolean updateStatus(long applicationId, String status) {
        String sql = "UPDATE Applications "
                   + "SET CurrentStatusId = (SELECT TOP 1 ApplicationStatusId FROM ApplicationStatuses WHERE StatusCode = ?), "
                   + "LastStatusChangedAt = SYSUTCDATETIME() "
                   + "WHERE ApplicationId = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, applicationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating application status", e);
        }
        return false;
    }

    // Đếm tổng số đơn ứng tuyển nộp vào của một Nhà tuyển dụng (phục vụ thống kê Dashboard)
    public int countByEmployerId(long userId) {
        long trueRecruiterId = getActualRecruiterId(userId);
        String sql = "SELECT COUNT(*) FROM Applications a "
                   + "JOIN Jobs j ON a.JobId = j.JobId "
                   + "WHERE j.PostedByRecruiterId = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, trueRecruiterId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting applications", e);
        }
        return 0;
    }

    // Kiểm tra xem ứng viên này đã nộp đơn cho công việc này chưa (tránh nộp trùng)
    public boolean hasAlreadyApplied(long candidateUserId, long jobId) {
        String sql = "SELECT COUNT(*) FROM Applications WHERE CandidateId = (SELECT CandidateId FROM CandidateProfiles WHERE UserId = ?) AND JobId = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, candidateUserId);
            ps.setLong(2, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if candidate applied", e);
        }
        return false;
    }

    // ==========================================
    // Lấy danh sách đơn ứng tuyển của một Ứng viên (dùng cho trang My Applications)
    public List<Application> findByCandidateId(long candidateUserId) {
        return findByCandidateId(candidateUserId, null, null);
    }

    public List<Application> findByCandidateId(long candidateUserId, String status, String keyword) {
        List<Application> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                     "SELECT a.*, ast.StatusCode AS CurrentStatus, cp.UserId AS CandidateUserId, j.Title, j.JobId as JoinJobId, "
                   + "c.CompanyName "
                   + "FROM Applications a "
                   + "JOIN ApplicationStatuses ast ON a.CurrentStatusId = ast.ApplicationStatusId "
                   + "JOIN CandidateProfiles cp ON a.CandidateId = cp.CandidateId "
                   + "JOIN Jobs j ON a.JobId = j.JobId "
                   + "JOIN RecruiterProfiles rp ON j.PostedByRecruiterId = rp.RecruiterId "
                   + "LEFT JOIN Companies c ON rp.CompanyId = c.CompanyId "
                   + "WHERE cp.UserId = ? ");

        List<Object> params = new ArrayList<>();
        params.add(candidateUserId);

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND ast.StatusCode = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (j.Title LIKE ? OR c.CompanyName LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        sql.append("ORDER BY a.AppliedAt DESC");

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToApplication(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding applications by candidateId=" + candidateUserId, e);
        }
        return list;
    }

    // ==========================================
    // Lấy một đơn ứng tuyển theo ID (kiểm tra quyền trước khi rút đơn)
    // ==========================================
    public Application findById(long applicationId) {
        String sql = "SELECT a.*, ast.StatusCode AS CurrentStatus, cp.UserId AS CandidateUserId, j.Title "
                   + "FROM Applications a "
                   + "JOIN ApplicationStatuses ast ON a.CurrentStatusId = ast.ApplicationStatusId "
                   + "JOIN CandidateProfiles cp ON a.CandidateId = cp.CandidateId "
                   + "JOIN Jobs j ON a.JobId = j.JobId "
                   + "WHERE a.ApplicationId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToApplication(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding application by id=" + applicationId, e);
        }
        return null;
    }

    // ==========================================
    // Yêu cầu rút đơn ứng tuyển (Chuyển sang trạng thái chờ duyệt rút đơn)
    // Lưu lý do rút đơn vào cột RecruiterNote để nhà tuyển dụng xem
    // ==========================================
    public boolean withdraw(long applicationId, long candidateUserId, String reason) {
        // Thực hiện xóa hoàn toàn đơn ứng tuyển khỏi DB để ứng viên có thể apply lại ngay
        // Điều kiện: Chỉ xóa khi trạng thái vẫn đang là PENDING (Chưa được duyệt)
        String sql = "DELETE FROM Applications "
                   + "WHERE ApplicationId = ? AND CandidateId = (SELECT CandidateId FROM CandidateProfiles WHERE UserId = ?) "
                   + "AND CurrentStatusId = (SELECT TOP 1 ApplicationStatusId FROM ApplicationStatuses WHERE StatusCode = 'PENDING')";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, applicationId);
            ps.setLong(2, candidateUserId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error completely deleting application id=" + applicationId + " for withdrawal", e);
        }
        return false;
    }

    // ==========================================
    // HR ghi chú nội bộ cho một hồ sơ (không hiện cho ứng viên)
    // KHỚP SCHEMA: Dùng RecruiterNote
    // ==========================================
    public boolean updateHRNote(long applicationId, String hrNote) {
        String sql = "UPDATE Applications SET RecruiterNote = ?, LastStatusChangedAt = SYSUTCDATETIME() WHERE ApplicationId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hrNote);
            ps.setLong(2, applicationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating HR note for application id=" + applicationId, e);
        }
        return false;
    }
}
