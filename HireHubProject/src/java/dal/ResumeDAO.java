package dal;

import model.CandidateResume;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ResumeDAO {
    private final DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(ResumeDAO.class.getName());

    public ResumeDAO() {
        this.dbContext = new DBContext();
    }

    public long insert(CandidateResume resume) {
        // Tham số resume.getCandidateId() hiện tại vẫn đang chứa UserId từ session truyền vào.
        // Cần thực hiện query để tìm CandidateId thật trong CandidateProfiles tương tự như Applications.
        String sql = "INSERT INTO CandidateResumes (CandidateId, ResumeTitle, FileUrl, FileType, FileSizeKB, VersionNo, IsDefault, UploadedAt) "
                   + "VALUES ((SELECT TOP 1 CandidateId FROM CandidateProfiles WHERE UserId = ?), ?, ?, ?, ?, 1, 1, SYSUTCDATETIME())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, resume.getCandidateId()); 
            ps.setString(2, resume.getResumeTitle());
            ps.setString(3, resume.getFileUrl());
            ps.setString(4, resume.getFileType());
            
            if (resume.getFileSizeKB() != null) {
                ps.setInt(5, resume.getFileSizeKB());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }

            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting candidate resume", e);
        }
        return -1;
    }

    /**
     * Lấy danh sách CV của một ứng viên
     */
    public java.util.List<model.CandidateResume> findByCandidateId(long userId) {
        java.util.List<model.CandidateResume> list = new java.util.ArrayList<>();
        String sql = "SELECT cr.* FROM CandidateResumes cr "
                   + "JOIN CandidateProfiles cp ON cr.CandidateId = cp.CandidateId "
                   + "WHERE cp.UserId = ? ORDER BY cr.UploadedAt DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.CandidateResume r = new model.CandidateResume();
                    r.setResumeId(rs.getLong("ResumeId"));
                    r.setCandidateId(rs.getLong("CandidateId"));
                    r.setResumeTitle(rs.getString("ResumeTitle"));
                    r.setFileUrl(rs.getString("FileUrl"));
                    r.setFileType(rs.getString("FileType"));
                    r.setFileSizeKB(rs.getInt("FileSizeKB"));
                    r.setDefault(rs.getBoolean("IsDefault"));
                    r.setUploadedAt(rs.getTimestamp("UploadedAt"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding resumes for userId=" + userId, e);
        }
        return list;
    }

    /**
     * Đặt một CV làm mặc định (và bỏ mặc định các bản khác)
     */
    public boolean setDefaultResume(long resumeId, long userId) {
        String resetSql = "UPDATE CandidateResumes SET IsDefault = 0 "
                        + "WHERE CandidateId = (SELECT CandidateId FROM CandidateProfiles WHERE UserId = ?)";
        String setSql = "UPDATE CandidateResumes SET IsDefault = 1 WHERE ResumeId = ?";
        
        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(resetSql);
                 PreparedStatement ps2 = conn.prepareStatement(setSql)) {
                
                ps1.setLong(1, userId);
                ps1.executeUpdate();
                
                ps2.setLong(1, resumeId);
                if (ps2.executeUpdate() > 0) {
                    conn.commit();
                    return true;
                }
                conn.rollback();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error setting default resume", e);
        }
        return false;
    }
}
