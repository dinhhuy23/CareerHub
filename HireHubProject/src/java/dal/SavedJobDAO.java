package dal;

import model.SavedJob;
import model.Job;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SavedJobDAO {
    private static final Logger LOGGER = Logger.getLogger(SavedJobDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    public boolean isJobSaved(long candidateId, long jobId) {
        String sql = "SELECT COUNT(*) FROM SavedJobs WHERE CandidateId = ? AND JobId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, candidateId);
            ps.setLong(2, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if job is saved", e);
        }
        return false;
    }

    public boolean saveJob(long candidateId, long jobId) {
        if (isJobSaved(candidateId, jobId)) return true; // Already saved

        String sql = "INSERT INTO SavedJobs (CandidateId, JobId, SavedAt) VALUES (?, ?, SYSUTCDATETIME())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, candidateId);
            ps.setLong(2, jobId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving job", e);
        }
        return false;
    }

    public boolean unsaveJob(long candidateId, long jobId) {
        String sql = "DELETE FROM SavedJobs WHERE CandidateId = ? AND JobId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, candidateId);
            ps.setLong(2, jobId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unsaving job", e);
        }
        return false;
    }

    public List<SavedJob> getSavedJobsByCandidateId(long candidateId) {
        List<SavedJob> list = new ArrayList<>();
        String sql = "SELECT sj.*, j.Title, j.CompanyName, u.FullName as EmployerName, "
                   + "l.LocationName, et.TypeName, j.SalaryMin, j.SalaryMax, j.CurrencyCode, j.Status "
                   + "FROM SavedJobs sj "
                   + "INNER JOIN Jobs j ON sj.JobId = j.JobId "
                   + "LEFT JOIN Locations l ON j.LocationId = l.LocationId "
                   + "LEFT JOIN EmploymentTypes et ON j.EmploymentTypeId = et.EmploymentTypeId "
                   + "LEFT JOIN Users u ON j.PostedByRecruiterId = u.UserId "
                   + "WHERE sj.CandidateId = ? "
                   + "ORDER BY sj.SavedAt DESC";
                   
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SavedJob sj = new SavedJob();
                    sj.setSavedJobId(rs.getLong("SavedJobId"));
                    sj.setCandidateId(rs.getLong("CandidateId"));
                    sj.setJobId(rs.getLong("JobId"));
                    sj.setSavedAt(rs.getTimestamp("SavedAt"));
                    
                    Job job = new Job();
                    job.setJobId(rs.getLong("JobId"));
                    job.setTitle(rs.getString("Title"));
                    job.setStatus(rs.getString("Status"));
                    try { job.setCompanyName(rs.getString("CompanyName")); } catch (Exception e) {}
                    try { job.setEmployerName(rs.getString("EmployerName")); } catch (Exception e) {}
                    try { job.setLocationName(rs.getString("LocationName")); } catch (Exception e) {}
                    try { job.setEmploymentTypeName(rs.getString("TypeName")); } catch (Exception e) {}
                    
                    job.setSalaryMin(rs.getBigDecimal("SalaryMin"));
                    job.setSalaryMax(rs.getBigDecimal("SalaryMax"));
                    job.setCurrencyCode(rs.getString("CurrencyCode"));
                    
                    sj.setJob(job);
                    list.add(sj);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting saved jobs", e);
        }
        return list;
    }
}
