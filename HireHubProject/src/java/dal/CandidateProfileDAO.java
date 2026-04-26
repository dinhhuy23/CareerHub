package dal;

import model.CandidateProfile;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CandidateProfileDAO extends DBContext {

    public CandidateProfile getByUserId(long userId) {
        // Câu lệnh SQL JOIN với bảng Locations để lấy tên địa điểm
        String sql = "SELECT cp.*, l.LocationName " +
                     "FROM CandidateProfiles cp " +
                     "LEFT JOIN Locations l ON cp.CurrentLocationId = l.LocationId " +
                     "WHERE cp.UserId = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            
            st.setLong(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    CandidateProfile cp = new CandidateProfile();
                    cp.setCandidateId(rs.getLong("CandidateId"));
                    cp.setSummary(rs.getString("Summary"));
                    cp.setHeadline(rs.getString("Headline"));
                    cp.setCurrentLocationName(rs.getString("LocationName"));
                    cp.setLinkedinUrl(rs.getString("LinkedinUrl"));
                    cp.setGithubUrl(rs.getString("GithubUrl"));
                    cp.setPortfolioUrl(rs.getString("PortfolioUrl"));
                    cp.setYearsOfExperience(rs.getInt("YearsOfExperience"));
                    cp.setEmploymentStatus(rs.getString("EmploymentStatus"));
                    cp.setHighestDegree(rs.getString("HighestDegree"));
                    return cp;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}