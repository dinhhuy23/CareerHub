package dal;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CandidateDAO {
    private static final Logger LOGGER = Logger.getLogger(CandidateDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    public boolean createProfile(long userId) {
        // Thêm EmploymentStatus và IsPublicProfile để tránh lỗi constraint NOT NULL
        String sql = "INSERT INTO CandidateProfiles (UserId, EmploymentStatus, IsPublicProfile, CreatedAt, UpdatedAt) "
                   + "VALUES (?, 'OPEN_TO_WORK', 1, SYSUTCDATETIME(), SYSUTCDATETIME())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            boolean result = ps.executeUpdate() > 0;
            if (!result) {
                LOGGER.log(Level.WARNING, "createProfile: INSERT returned 0 rows for userId=" + userId);
            }
            return result;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating candidate profile for userId: " + userId, e);
        }
        return false;
    }
    
    public Long getCandidateIdByUserId(long userId) {
        String sql = "SELECT CandidateId FROM CandidateProfiles WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("CandidateId");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting candidateId for userId: " + userId, e);
        }
        return null;
    }
}
