package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.CandidateExperience;

public class CandidateExperienceDAO extends DBContext {

    public List<CandidateExperience> getByCandidateId(long candidateId) {
        List<CandidateExperience> list = new ArrayList<>();
        String sql = "SELECT * FROM CandidateExperiences WHERE CandidateId = ? ORDER BY StartDate DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            
            st.setLong(1, candidateId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    CandidateExperience exp = new CandidateExperience();
                    exp.setExperienceId(rs.getInt("ExperienceId"));
                    exp.setCompanyName(rs.getString("CompanyName"));
                    exp.setPositionTitle(rs.getString("PositionTitle"));
                    exp.setStartDate(rs.getDate("StartDate"));
                    exp.setEndDate(rs.getDate("EndDate"));
                    exp.setIsCurrentJob(rs.getBoolean("IsCurrentJob"));
                    exp.setDescription(rs.getString("Description"));
                    list.add(exp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}