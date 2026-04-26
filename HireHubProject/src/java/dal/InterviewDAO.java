package dal;

import model.Interview;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InterviewDAO {
    private final DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(InterviewDAO.class.getName());

    public InterviewDAO() {
        this.dbContext = new DBContext();
    }

    public boolean insert(Interview interview) {
        String sql = "INSERT INTO Interviews (ApplicationId, InterviewTypeId, ScheduledByUserId, StartAt, EndAt, MeetingLink, LocationText, Status, Note, CreatedAt, UpdatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME(), SYSUTCDATETIME())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, interview.getApplicationId());
            ps.setLong(2, interview.getInterviewTypeId() > 0 ? interview.getInterviewTypeId() : 1); // Mặc định 1 (VD: Online)
            
            if (interview.getScheduledByUserId() != null) ps.setLong(3, interview.getScheduledByUserId());
            else ps.setNull(3, Types.BIGINT);
            
            ps.setTimestamp(4, interview.getStartAt());
            ps.setTimestamp(5, interview.getEndAt());
            ps.setString(6, interview.getMeetingLink());
            ps.setString(7, interview.getLocationText());
            ps.setString(8, interview.getStatus() != null ? interview.getStatus() : "SCHEDULED");
            ps.setString(9, interview.getNote());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting interview for application id=" + interview.getApplicationId(), e);
        }
        return false;
    }

    public Interview findByApplicationId(long appId) {
        String sql = "SELECT TOP 1 * FROM Interviews WHERE ApplicationId = ? ORDER BY CreatedAt DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, appId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Interview interview = new Interview();
                    interview.setInterviewId(rs.getLong("InterviewId"));
                    interview.setApplicationId(rs.getLong("ApplicationId"));
                    interview.setInterviewTypeId(rs.getLong("InterviewTypeId"));
                    interview.setStartAt(rs.getTimestamp("StartAt"));
                    interview.setEndAt(rs.getTimestamp("EndAt"));
                    interview.setMeetingLink(rs.getString("MeetingLink"));
                    interview.setLocationText(rs.getString("LocationText"));
                    interview.setStatus(rs.getString("Status"));
                    interview.setNote(rs.getString("Note"));
                    return interview;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding interview by appId=" + appId, e);
        }
        return null;
    }
}
