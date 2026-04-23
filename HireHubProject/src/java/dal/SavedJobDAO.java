package dal;

import model.Job;
import model.SavedJob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SavedJobDAO {

    private static final Logger LOGGER = Logger.getLogger(SavedJobDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    private Long getCandidateIdByUserId(Connection conn, long userId) throws SQLException {
        String sql = "SELECT TOP 1 CandidateId FROM CandidateProfiles WHERE UserId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("CandidateId");
                }
            }
        }
        return null;
    }

    private Long getOrCreateCandidateIdByUserId(Connection conn, long userId) throws SQLException {
        Long candidateId = getCandidateIdByUserId(conn, userId);
        if (candidateId != null) {
            return candidateId;
        }

        String createProfileSql = "INSERT INTO CandidateProfiles (UserId, CreatedAt, UpdatedAt) " +
                "VALUES (?, SYSUTCDATETIME(), SYSUTCDATETIME())";

        try (PreparedStatement psCreate = conn.prepareStatement(createProfileSql, Statement.RETURN_GENERATED_KEYS)) {
            psCreate.setLong(1, userId);
            psCreate.executeUpdate();

            try (ResultSet rs = psCreate.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }

        return getCandidateIdByUserId(conn, userId);
    }

    private boolean isJobSaved(Connection conn, long candidateId, long jobId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM SavedJobs WHERE CandidateId = ? AND JobId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, candidateId);
            ps.setLong(2, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean isJobSaved(long candidateUserId, long jobId) {
        try (Connection conn = dbContext.getConnection()) {
            Long candidateId = getCandidateIdByUserId(conn, candidateUserId);
            if (candidateId == null) {
                LOGGER.warning("Không tìm thấy CandidateProfile cho UserId = " + candidateUserId);
                return false;
            }
            return isJobSaved(conn, candidateId, jobId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if job is saved", e);
            return false;
        }
    }

    public boolean saveJob(long candidateUserId, long jobId) {
        String sql = "INSERT INTO SavedJobs (CandidateId, JobId, SavedAt, IsFavorite) " +
                "VALUES (?, ?, SYSUTCDATETIME(), 0)";

        try (Connection conn = dbContext.getConnection()) {
            Long candidateId = getOrCreateCandidateIdByUserId(conn, candidateUserId);

            if (candidateId == null) {
                LOGGER.warning("Không thể tạo hoặc tìm thấy CandidateProfile cho UserId = " + candidateUserId);
                return false;
            }

            if (isJobSaved(conn, candidateId, jobId)) {
                return true;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, candidateId);
                ps.setLong(2, jobId);
                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving job", e);
            return false;
        }
    }

    public boolean unsaveJob(long candidateUserId, long jobId) {
        String sql = "DELETE FROM SavedJobs WHERE CandidateId = ? AND JobId = ?";

        try (Connection conn = dbContext.getConnection()) {
            Long candidateId = getCandidateIdByUserId(conn, candidateUserId);
            if (candidateId == null) {
                LOGGER.warning("Không tìm thấy CandidateProfile cho UserId = " + candidateUserId);
                return false;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, candidateId);
                ps.setLong(2, jobId);
                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unsaving job", e);
            return false;
        }
    }

    public boolean toggleFavorite(long candidateUserId, long jobId) {
        String insertIfNotSavedSql = "INSERT INTO SavedJobs (CandidateId, JobId, SavedAt, IsFavorite) " +
                "VALUES (?, ?, SYSUTCDATETIME(), 1)";

        String toggleSql = "UPDATE SavedJobs " +
                "SET IsFavorite = CASE WHEN ISNULL(IsFavorite, 0) = 1 THEN 0 ELSE 1 END " +
                "WHERE CandidateId = ? AND JobId = ?";

        try (Connection conn = dbContext.getConnection()) {
            Long candidateId = getOrCreateCandidateIdByUserId(conn, candidateUserId);

            if (candidateId == null) {
                LOGGER.warning("Không thể tạo hoặc tìm thấy CandidateProfile cho UserId = " + candidateUserId);
                return false;
            }

            if (!isJobSaved(conn, candidateId, jobId)) {
                try (PreparedStatement ps = conn.prepareStatement(insertIfNotSavedSql)) {
                    ps.setLong(1, candidateId);
                    ps.setLong(2, jobId);
                    return ps.executeUpdate() > 0;
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(toggleSql)) {
                ps.setLong(1, candidateId);
                ps.setLong(2, jobId);
                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error toggling favorite", e);
            return false;
        }
    }

    public List<SavedJob> getSavedJobsByCandidateId(long candidateUserId) {
        List<SavedJob> list = new ArrayList<>();

        String sql = "SELECT sj.SavedJobId, sj.CandidateId, sj.JobId, sj.SavedAt, ISNULL(sj.IsFavorite, 0) AS IsFavorite, "
                +
                "       j.Title, j.SalaryMin, j.SalaryMax, j.CurrencyCode, j.Status, " +
                "       u.FullName AS EmployerName, c.CompanyName, l.LocationName, et.TypeName " +
                "FROM SavedJobs sj " +
                "INNER JOIN Jobs j ON sj.JobId = j.JobId " +
                "LEFT JOIN RecruiterProfiles rp ON j.PostedByRecruiterId = rp.RecruiterId " +
                "LEFT JOIN Users u ON rp.UserId = u.UserId " +
                "LEFT JOIN Companies c ON j.CompanyId = c.CompanyId " +
                "LEFT JOIN Locations l ON j.LocationId = l.LocationId " +
                "LEFT JOIN EmploymentTypes et ON j.EmploymentTypeId = et.EmploymentTypeId " +
                "WHERE sj.CandidateId = ? " +
                "ORDER BY ISNULL(sj.IsFavorite, 0) DESC, sj.SavedAt DESC";

        try (Connection conn = dbContext.getConnection()) {
            Long candidateId = getCandidateIdByUserId(conn, candidateUserId);
            if (candidateId == null) {
                LOGGER.warning("Không tìm thấy CandidateProfile cho UserId = " + candidateUserId);
                return list;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, candidateId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        SavedJob sj = new SavedJob();
                        sj.setSavedJobId(rs.getLong("SavedJobId"));
                        sj.setCandidateId(rs.getLong("CandidateId"));
                        sj.setJobId(rs.getLong("JobId"));
                        sj.setSavedAt(rs.getTimestamp("SavedAt"));
                        sj.setFavorite(rs.getBoolean("IsFavorite"));

                        Job job = new Job();
                        job.setJobId(rs.getLong("JobId"));
                        job.setTitle(rs.getString("Title"));
                        job.setStatus(rs.getString("Status"));
                        job.setCompanyName(rs.getString("CompanyName"));
                        job.setEmployerName(rs.getString("EmployerName"));
                        job.setLocationName(rs.getString("LocationName"));
                        job.setEmploymentTypeName(rs.getString("TypeName"));
                        job.setSalaryMin(rs.getBigDecimal("SalaryMin"));
                        job.setSalaryMax(rs.getBigDecimal("SalaryMax"));
                        job.setCurrencyCode(rs.getString("CurrencyCode"));

                        sj.setJob(job);
                        list.add(sj);
                    }
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting saved jobs", e);
        }

        return list;
    }
}