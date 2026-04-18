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
}
