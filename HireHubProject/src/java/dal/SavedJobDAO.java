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

    /**
     * Tìm CandidateId thật từ UserId đăng nhập
     */
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

    /**
     * Kiểm tra job đã được lưu chưa
     * Tham số truyền vào là UserId của user đang đăng nhập
     */
    public boolean isJobSaved(long candidateUserId, long jobId) {
        String sql = "SELECT COUNT(*) FROM SavedJobs WHERE CandidateId = ? AND JobId = ?";

        try (Connection conn = dbContext.getConnection()) {
            Long candidateId = getCandidateIdByUserId(conn, candidateUserId);
            if (candidateId == null) {
                LOGGER.warning("Không tìm thấy CandidateProfile cho UserId = " + candidateUserId);
                return false;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, candidateId);
                ps.setLong(2, jobId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if job is saved", e);
        }
        return false;
    }

    /**
     * Lưu việc làm
     * Tham số truyền vào là UserId của candidate
     */
    public boolean saveJob(long candidateUserId, long jobId) {
        String sql = "INSERT INTO SavedJobs (CandidateId, JobId, SavedAt) VALUES (?, ?, SYSUTCDATETIME())";

        try (Connection conn = dbContext.getConnection()) {
            Long candidateId = getCandidateIdByUserId(conn, candidateUserId);
            if (candidateId == null) {
                // Tự động tạo profile nếu chưa có (lazy creation)
                LOGGER.info("Tự động tạo CandidateProfile cho UserId = " + candidateUserId);
                String createProfileSql = "INSERT INTO CandidateProfiles (UserId, CreatedAt, UpdatedAt) VALUES (?, SYSUTCDATETIME(), SYSUTCDATETIME())";
                try (PreparedStatement psCreate = conn.prepareStatement(createProfileSql, Statement.RETURN_GENERATED_KEYS)) {
                    psCreate.setLong(1, candidateUserId);
                    psCreate.executeUpdate();
                    try (ResultSet rs = psCreate.getGeneratedKeys()) {
                        if (rs.next()) {
                            candidateId = rs.getLong(1);
                        } else {
                            // Backup: try to fetch again
                            candidateId = getCandidateIdByUserId(conn, candidateUserId);
                        }
                    }
                }
            }

            if (candidateId == null) {
                LOGGER.warning("Không thể tạo hoặc tìm thấy CandidateProfile cho UserId = " + candidateUserId);
                return false;
            }

            if (isJobSaved(candidateUserId, jobId)) {
                return true;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, candidateId);
                ps.setLong(2, jobId);
                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving job", e);
        }
        return false;
    }

    /**
     * Bỏ lưu việc làm
     * Tham số truyền vào là UserId của candidate
     */
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
        }
        return false;
    }

    /**
     * Lấy danh sách việc làm đã lưu theo UserId của candidate
     */
    public List<SavedJob> getSavedJobsByCandidateId(long candidateUserId) {
        List<SavedJob> list = new ArrayList<>();

        String sql = "SELECT sj.*, j.Title, j.SalaryMin, j.SalaryMax, j.CurrencyCode, j.Status, "
                   + "u.FullName as EmployerName, c.CompanyName, l.LocationName, et.TypeName "
                   + "FROM SavedJobs sj "
                   + "INNER JOIN Jobs j ON sj.JobId = j.JobId "
                   + "LEFT JOIN RecruiterProfiles rp ON j.PostedByRecruiterId = rp.RecruiterId "
                   + "LEFT JOIN Users u ON rp.UserId = u.UserId "
                   + "LEFT JOIN Companies c ON j.CompanyId = c.CompanyId "
                   + "LEFT JOIN Locations l ON j.LocationId = l.LocationId "
                   + "LEFT JOIN EmploymentTypes et ON j.EmploymentTypeId = et.EmploymentTypeId "
                   + "WHERE sj.CandidateId = ? "
                   + "ORDER BY sj.SavedAt DESC";

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
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting saved jobs", e);
        }

        return list;
    }
}