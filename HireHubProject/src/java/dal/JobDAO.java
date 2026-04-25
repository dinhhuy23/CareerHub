package dal;

import model.Job;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class JobDAO {

    private static final Logger LOGGER = Logger.getLogger(JobDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    private Job mapResultSetToJob(ResultSet rs) throws SQLException {
        Job job = new Job();
        job.setJobId(rs.getLong("JobId"));
        job.setCompanyId(rs.getObject("CompanyId") != null ? rs.getLong("CompanyId") : null);
        job.setDepartmentId(rs.getObject("DepartmentId") != null ? rs.getLong("DepartmentId") : null);
        job.setPostedByRecruiterId(rs.getLong("PostedByRecruiterId"));
        job.setCategoryId(rs.getObject("CategoryId") != null ? rs.getLong("CategoryId") : null);
        job.setEmploymentTypeId(rs.getObject("EmploymentTypeId") != null ? rs.getLong("EmploymentTypeId") : null);
        job.setExperienceLevelId(rs.getObject("ExperienceLevelId") != null ? rs.getLong("ExperienceLevelId") : null);
        job.setTitle(rs.getString("Title"));
        job.setJobCode(rs.getString("JobCode"));
        job.setDescription(rs.getString("Description"));
        job.setRequirements(rs.getString("Requirements"));
        job.setResponsibilities(rs.getString("Responsibilities"));
        job.setLocationId(rs.getObject("LocationId") != null ? rs.getLong("LocationId") : null);
        job.setAddressDetail(rs.getString("AddressDetail"));
        job.setSalaryMin(rs.getBigDecimal("SalaryMin"));
        job.setSalaryMax(rs.getBigDecimal("SalaryMax"));
        job.setCurrencyCode(rs.getString("CurrencyCode"));
        job.setVacancyCount(rs.getObject("VacancyCount") != null ? rs.getInt("VacancyCount") : null);
        job.setDeadlineAt(rs.getTimestamp("DeadlineAt"));
        job.setPublishedAt(rs.getTimestamp("PublishedAt"));
        job.setClosedAt(rs.getTimestamp("ClosedAt"));
        job.setStatus(rs.getString("Status"));
        job.setViewCount(rs.getInt("ViewCount"));
        job.setFeatured(rs.getBoolean("IsFeatured"));
        job.setCreatedAt(rs.getTimestamp("CreatedAt"));
        job.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

        // Join display fields if present
        try {
            job.setCategoryName(rs.getString("CategoryName"));
        } catch (Exception e) {
        }
        try {
            job.setLocationName(rs.getString("LocationName"));
        } catch (Exception e) {
        }
        try {
            job.setEmploymentTypeName(rs.getString("TypeName"));
        } catch (Exception e) {
        }
        try {
            job.setExperienceLevelName(rs.getString("LevelName"));
        } catch (Exception e) {
        }
        try {
            job.setEmployerName(rs.getString("FullName"));
        } catch (Exception e) {
        }
        try {
            job.setCompanyName(rs.getString("CompanyName"));
        } catch (Exception e) {
        }
        try {
            job.setCompanyLogoUrl(rs.getString("CompanyLogoUrl"));
        } catch (Exception e) {
        }

        return job;
    }

    public long insert(Job job) throws SQLException {
        // 1. Lấy RecruiterId và CompanyId của nhà tuyển dụng từ UserId
        long companyId = 1; // Default fallback
        long trueRecruiterId = job.getPostedByRecruiterId(); // Assume it's already RecruiterId, fallback if not

        String getProfileSql = "SELECT RecruiterId, CompanyId FROM RecruiterProfiles WHERE UserId = ?";


        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(getProfileSql)) {

            ps.setLong(1, job.getPostedByRecruiterId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    trueRecruiterId = rs.getLong("RecruiterId");
                    companyId = rs.getLong("CompanyId");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting company id", e);
        }

        // 2. Chèn dữ liệu vào bảng Jobs với các cột NOT NULL bị thiếu
        String sql = "INSERT INTO Jobs (PostedByRecruiterId, CompanyId, Title, Description, Requirements, Responsibilities, "
                + "SalaryMin, SalaryMax, CategoryId, LocationId, EmploymentTypeId, ExperienceLevelId, "
                + "DeadlineAt, Status, CurrencyCode, VacancyCount, IsFeatured, ViewCount, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'VND', 1, 0, 0, SYSUTCDATETIME(), SYSUTCDATETIME())";



        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, trueRecruiterId);
            ps.setLong(2, companyId);
            ps.setString(3, job.getTitle());
            ps.setString(4, job.getDescription());
            ps.setString(5, job.getRequirements());
            ps.setString(6, job.getResponsibilities());
            ps.setObject(7, job.getSalaryMin());
            ps.setObject(8, job.getSalaryMax());
            ps.setObject(9, job.getCategoryId());
            ps.setObject(10, job.getLocationId());
            ps.setObject(11, job.getEmploymentTypeId());
            ps.setObject(12, job.getExperienceLevelId());
            ps.setTimestamp(13, job.getDeadlineAt());
            ps.setString(14, job.getStatus() != null ? job.getStatus() : "PUBLISHED");

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {


                    if (keys.next()) {
                        return keys.getLong(1);
                    }

                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting job", e);
            throw e; // Ném lỗi ra Controller để hiển thị lên màn hình
        }
        return -1;
    }

    // Helper method to convert UserId to RecruiterId
    private long getActualRecruiterId(long userId) {
        String sql = "SELECT RecruiterId FROM RecruiterProfiles WHERE UserId = ?";


        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }

            }
        } catch (SQLException e) {
        }
        return userId; // Fallback
    }

    public boolean update(Job job) {
        long trueRecruiterId = getActualRecruiterId(job.getPostedByRecruiterId());
        String sql = "UPDATE Jobs SET Title = ?, Description = ?, Requirements = ?, Responsibilities = ?, "
                + "SalaryMin = ?, SalaryMax = ?, CategoryId = ?, LocationId = ?, EmploymentTypeId = ?, "
                + "ExperienceLevelId = ?, DeadlineAt = ?, Status = ?, UpdatedAt = SYSUTCDATETIME() "
                + "WHERE JobId = ? AND PostedByRecruiterId = ?";


        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, job.getTitle());
            ps.setString(2, job.getDescription());
            ps.setString(3, job.getRequirements());
            ps.setString(4, job.getResponsibilities());
            ps.setObject(5, job.getSalaryMin());
            ps.setObject(6, job.getSalaryMax());
            ps.setObject(7, job.getCategoryId());
            ps.setObject(8, job.getLocationId());
            ps.setObject(9, job.getEmploymentTypeId());
            ps.setObject(10, job.getExperienceLevelId());
            ps.setTimestamp(11, job.getDeadlineAt());
            ps.setString(12, job.getStatus());
            ps.setLong(13, job.getJobId());
            ps.setLong(14, trueRecruiterId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating job", e);
        }
        return false;
    }
    public boolean updateBasic(long jobId, String title, Double salaryMin, Double salaryMax) {
    String sql = "UPDATE Jobs SET Title = ?, SalaryMin = ?, SalaryMax = ?, UpdatedAt = SYSUTCDATETIME() WHERE JobId = ?";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, title);
        ps.setObject(2, salaryMin);
        ps.setObject(3, salaryMax);
        ps.setLong(4, jobId);

        return ps.executeUpdate() > 0;

    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
    public boolean closeJob(long jobId) {
        String sql = """
        UPDATE Jobs 
        SET Status = 'CLOSED',
            ClosedAt = SYSUTCDATETIME(),
            UpdatedAt = SYSUTCDATETIME()
        WHERE JobId = ?
    """;

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, jobId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error closing job", e);
        }
        return false;
    }

    public boolean updateStatus(long jobId, long recruiterOrUserId, String status) {
        long trueRecruiterId = getActualRecruiterId(recruiterOrUserId);
        String sql = "UPDATE Jobs SET Status = ?, UpdatedAt = SYSUTCDATETIME() WHERE JobId = ? AND PostedByRecruiterId = ?";


        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setLong(2, jobId);
            ps.setLong(3, trueRecruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating status", e);
        }
        return false;
    }

    public Job findById(long jobId) {
        String sql = "SELECT j.*, jc.CategoryName, l.LocationName, et.TypeName, el.LevelName, u.FullName "
                + "FROM Jobs j "
                + "LEFT JOIN JobCategories jc ON j.CategoryId = jc.CategoryId "
                + "LEFT JOIN Locations l ON j.LocationId = l.LocationId "
                + "LEFT JOIN EmploymentTypes et ON j.EmploymentTypeId = et.EmploymentTypeId "
                + "LEFT JOIN ExperienceLevels el ON j.ExperienceLevelId = el.ExperienceLevelId "
                + "LEFT JOIN Users u ON j.PostedByRecruiterId = u.UserId "
                + "WHERE j.JobId = ?";


        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToJob(rs);
                }

            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding job by ID", e);
        }
        return null;
    }

    // Hàm gốc: Lấy tất cả job không lọc
    public List<Job> findByEmployerId(long employerUserId) {
        return findByEmployerId(employerUserId, null, null);
    }

    // Hàm mở rộng: Lấy job có hỗ trợ lọc theo Keyword (Tiêu đề) và Status (Trạng thái)
    public List<Job> findByEmployerId(long employerUserId, String keyword, String status) {
        long trueRecruiterId = getActualRecruiterId(employerUserId);
        List<Job> list = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
                  "SELECT j.*, jc.CategoryName, l.LocationName, et.TypeName, el.LevelName, c.CompanyName, c.LogoUrl AS CompanyLogoUrl "
                + "FROM Jobs j "
                + "LEFT JOIN JobCategories jc ON j.CategoryId = jc.CategoryId "
                + "LEFT JOIN Locations l ON j.LocationId = l.LocationId "
                + "LEFT JOIN EmploymentTypes et ON j.EmploymentTypeId = et.EmploymentTypeId "
                + "LEFT JOIN ExperienceLevels el ON j.ExperienceLevelId = el.ExperienceLevelId "
                + "LEFT JOIN RecruiterProfiles rp ON j.PostedByRecruiterId = rp.RecruiterId "
                + "LEFT JOIN Companies c ON rp.CompanyId = c.CompanyId "
                + "WHERE j.PostedByRecruiterId = ? AND j.Status != 'DELETED' ");

        List<Object> params = new ArrayList<>();
        params.add(trueRecruiterId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND j.Title LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND j.Status = ? ");
            params.add(status.trim());
        }

        sql.append("ORDER BY j.CreatedAt DESC");

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToJob(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding filtered jobs by employer ID", e);
        }
        return list;
    }

    public List<Job> searchAndFilter(String keyword, Long categoryId, Long locationId, Long typeId, Long levelId,
            int offset, int fetchSize) {
        List<Job> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT j.*, jc.CategoryName, l.LocationName, et.TypeName, el.LevelName, u.FullName, c.CompanyName, c.LogoUrl AS CompanyLogoUrl "
                        + "FROM Jobs j "
                        + "LEFT JOIN JobCategories jc ON j.CategoryId = jc.CategoryId "
                        + "LEFT JOIN Locations l ON j.LocationId = l.LocationId "
                        + "LEFT JOIN EmploymentTypes et ON j.EmploymentTypeId = et.EmploymentTypeId "
                        + "LEFT JOIN ExperienceLevels el ON j.ExperienceLevelId = el.ExperienceLevelId "
                        + "LEFT JOIN Users u ON j.PostedByRecruiterId = u.UserId "
                        + "LEFT JOIN RecruiterProfiles rp ON j.PostedByRecruiterId = rp.RecruiterId "
                        + "LEFT JOIN Companies c ON rp.CompanyId = c.CompanyId "
                        + "WHERE j.Status = 'PUBLISHED' AND c.Status = 'ACTIVE' ");


        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (j.Title LIKE ? OR j.Description LIKE ? OR u.FullName LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND j.CategoryId = ? ");
            params.add(categoryId);
        }
        if (locationId != null && locationId > 0) {
            sql.append("AND j.LocationId = ? ");
            params.add(locationId);
        }
        if (typeId != null && typeId > 0) {
            sql.append("AND j.EmploymentTypeId = ? ");
            params.add(typeId);
        }
        if (levelId != null && levelId > 0) {
            sql.append("AND j.ExperienceLevelId = ? ");
            params.add(levelId);
        }

        sql.append("ORDER BY j.CreatedAt DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(fetchSize);


        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {


            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {


                while (rs.next()) {
                    list.add(mapResultSetToJob(rs));
                }

            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching jobs", e);
        }
        return list;
    }

    public int countSearchAndFilter(String keyword, Long categoryId, Long locationId, Long typeId, Long levelId) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(j.JobId) "

                + "FROM Jobs j "
                + "LEFT JOIN Users u ON j.PostedByRecruiterId = u.UserId "
                + "LEFT JOIN RecruiterProfiles rp ON j.PostedByRecruiterId = rp.RecruiterId "
                + "LEFT JOIN Companies c ON rp.CompanyId = c.CompanyId "
                + "WHERE j.Status = 'PUBLISHED' AND c.Status = 'ACTIVE' "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (j.Title LIKE ? OR j.Description LIKE ? OR u.FullName LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND j.CategoryId = ? ");
            params.add(categoryId);
        }
        if (locationId != null && locationId > 0) {
            sql.append("AND j.LocationId = ? ");
            params.add(locationId);
        }
        if (typeId != null && typeId > 0) {
            sql.append("AND j.EmploymentTypeId = ? ");
            params.add(typeId);
        }
        if (levelId != null && levelId > 0) {
            sql.append("AND j.ExperienceLevelId = ? ");
            params.add(levelId);
        }


        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {


            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting jobs", e);
        }
        return 0;
    }

    public void incrementViewCount(long jobId) {
        String sql = "UPDATE Jobs SET ViewCount = ViewCount + 1 WHERE JobId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, jobId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error incrementing view count", e);
        }
    }

    // Đếm tổng số lượng tin tuyển dụng mà Nhà tuyển dụng này đã đăng
    public int countJobsByEmployer(long employerUserId) {
        long trueRecruiterId = getActualRecruiterId(employerUserId);
        String sql = "SELECT COUNT(*) FROM Jobs WHERE PostedByRecruiterId = ? AND Status != 'DELETED'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, trueRecruiterId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting employer jobs", e);
        }
        return 0;
    }

    // Tính tổng tất cả lượt xem từ tất cả các tin tuyển dụng của một Nhà tuyển dụng
    // cụ thể
    public long getTotalViewsByEmployer(long employerUserId) {
        long trueRecruiterId = getActualRecruiterId(employerUserId);
        String sql = "SELECT SUM(ViewCount) FROM Jobs WHERE PostedByRecruiterId = ? AND Status != 'DELETED'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, trueRecruiterId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }

            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total views", e);
        }
        return 0;
    }

    public List<Job> getAllJobs() {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM Jobs";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Job j = new Job();

                j.setJobId(rs.getLong("JobId"));
                j.setCompanyId(rs.getLong("CompanyId"));
                j.setDepartmentId(rs.getLong("DepartmentId"));
                j.setPostedByRecruiterId(rs.getLong("PostedByRecruiterId"));
                j.setCategoryId(rs.getLong("CategoryId"));
                j.setEmploymentTypeId(rs.getLong("EmploymentTypeId"));
                j.setExperienceLevelId(rs.getLong("ExperienceLevelId"));

                j.setTitle(rs.getString("Title"));
                j.setJobCode(rs.getString("JobCode"));
                j.setDescription(rs.getString("Description"));
                j.setRequirements(rs.getString("Requirements"));
                j.setResponsibilities(rs.getString("Responsibilities"));

                j.setLocationId(rs.getLong("LocationId"));
                j.setAddressDetail(rs.getString("AddressDetail"));

                j.setSalaryMin(rs.getBigDecimal("SalaryMin"));
                j.setSalaryMax(rs.getBigDecimal("SalaryMax"));
                j.setCurrencyCode(rs.getString("CurrencyCode"));
                j.setVacancyCount(rs.getInt("VacancyCount"));

                j.setDeadlineAt(rs.getTimestamp("DeadlineAt"));
                j.setPublishedAt(rs.getTimestamp("PublishedAt"));
                j.setClosedAt(rs.getTimestamp("ClosedAt"));

                j.setStatus(rs.getString("Status"));
                j.setViewCount(rs.getInt("ViewCount"));
//            j.setIsFeatured(rs.getBoolean("IsFeatured"));

                j.setCreatedAt(rs.getTimestamp("CreatedAt"));
                j.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                list.add(j);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Job> findByCompanyId(long companyId) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.*, rp.UserId as EmployerUserId, "
                + "COALESCE(c.CompanyName, u.FullName) as EmployerName, "
                + "c.CompanyName, "
                + "jc.CategoryName, "
                + "l.LocationName, "
                + "et.TypeName as EmploymentTypeName, "
                + "el.LevelName as ExperienceLevelName "
                + "FROM Jobs j "
                + "JOIN RecruiterProfiles rp ON j.PostedByRecruiterId = rp.RecruiterId "
                + "JOIN Users u ON rp.UserId = u.UserId "
                + "LEFT JOIN Companies c ON j.CompanyId = c.CompanyId "
                + "LEFT JOIN JobCategories jc ON j.CategoryId = jc.CategoryId "
                + "LEFT JOIN Locations l ON j.LocationId = l.LocationId "
                + "LEFT JOIN EmploymentTypes et ON j.EmploymentTypeId = et.EmploymentTypeId "
                + "LEFT JOIN ExperienceLevels el ON j.ExperienceLevelId = el.ExperienceLevelId "
                + "WHERE j.CompanyId = ? AND j.Status = 'PUBLISHED' "
                + "ORDER BY j.PublishedAt DESC";


        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToJob(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding jobs by company", e);
        }
        return list;
    }

    public List<Job> getJobsPaging(int offset, int pageSize) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM Jobs ORDER BY CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToJob(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countAllJobs() {
        String sql = "SELECT COUNT(*) FROM Jobs";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Job> getRecommendedJobs(String targetRole, int limit) {
        List<Job> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT TOP (?) j.*, c.CompanyName " +
            "FROM Jobs j " +
            "LEFT JOIN Companies c ON j.CompanyId = c.CompanyId " +
            "WHERE j.Status = 'PUBLISHED' AND c.Status = 'ACTIVE' "
        );
        
        String[] words = null;
        if (targetRole != null && !targetRole.trim().isEmpty()) {
            // Tách các từ, loại bỏ khoảng trắng thừa
            words = targetRole.trim().split("\\s+");
            if (words.length > 0) {
                sql.append("AND (");
                for (int i = 0; i < words.length; i++) {
                    if (i > 0) sql.append(" OR ");
                    sql.append("j.Title LIKE ?");
                }
                sql.append(") ");
            }
        }
        
        sql.append("ORDER BY j.UpdatedAt DESC");
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int paramIndex = 1;
            ps.setInt(paramIndex++, limit);
            
            if (words != null && words.length > 0) {
                for (String word : words) {
                    ps.setString(paramIndex++, "%" + word + "%");
                }
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Job job = new Job();
                    job.setJobId(rs.getLong("JobId"));
                    job.setTitle(rs.getString("Title"));
                    job.setSalaryMin(rs.getBigDecimal("SalaryMin"));
                    job.setSalaryMax(rs.getBigDecimal("SalaryMax"));
                    job.setCurrencyCode(rs.getString("CurrencyCode"));
                    try { job.setCompanyName(rs.getString("CompanyName")); } catch(Exception e){}
                    list.add(job);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
