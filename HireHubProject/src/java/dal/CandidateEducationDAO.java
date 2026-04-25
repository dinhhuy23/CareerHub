package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.CandidateEducation;

public class CandidateEducationDAO extends DBContext {

    public List<CandidateEducation> getByCandidateId(long candidateId) {
        List<CandidateEducation> list = new ArrayList<>();
        String sql = "SELECT * FROM CandidateEducations WHERE CandidateId = ? ORDER BY EndDate DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            
            st.setLong(1, candidateId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    CandidateEducation edu = new CandidateEducation();
                    edu.setEducationId(rs.getInt("EducationId"));
                    edu.setSchoolName(rs.getString("SchoolName"));
                    edu.setDegree(rs.getString("Degree"));
                    edu.setMajor(rs.getString("Major"));
                    edu.setStartDate(rs.getDate("StartDate"));
                    edu.setEndDate(rs.getDate("EndDate"));
                    edu.setGpa(rs.getDouble("GPA"));
                    edu.setDescription(rs.getString("Description"));
                    list.add(edu);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}