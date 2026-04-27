/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Recruiter;
import java.sql.*;

/**
 *
 * @author Admin
 */
public class RecruiterDAO {

    private final DBContext dbContext = new DBContext();

    // GET ALL
    public List<Recruiter> getAll() {
        List<Recruiter> list = new ArrayList<>();
        String sql = "SELECT r.*, c.CompanyName, d.DepartmentName, u.FullName, u.Email "
                + "FROM RecruiterProfiles r "
                + "LEFT JOIN Companies c ON r.CompanyId = c.CompanyId "
                + "LEFT JOIN Departments d ON r.DepartmentId = d.DepartmentId "
                + "LEFT JOIN Users u ON r.UserId = u.UserId";

        try (Connection conn = dbContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Recruiter r = new Recruiter();
                r.setRecruiterId(rs.getLong("RecruiterId"));
                r.setUserId(rs.getLong("UserId"));
                r.setCompanyId(rs.getLong("CompanyId"));
                r.setJobTitle(rs.getString("JobTitle"));
                r.setStatus(rs.getString("Status"));
                r.setCompanyName(rs.getString("CompanyName"));
                r.setDepartmentName(rs.getString("DepartmentName"));
                r.setBio(rs.getString("Bio"));
                r.setFullName(rs.getString("FullName"));
                r.setEmail(rs.getString("Email"));
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // INSERT – trả về true nếu thành công
    public boolean insert(Recruiter r) {
        String sql = "INSERT INTO RecruiterProfiles(UserId, CompanyId, DepartmentId, JobTitle, Bio) VALUES(?,?,?,?,?)";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, r.getUserId());
            ps.setLong(2, r.getCompanyId());
            if (r.getDepartmentId() != null) {
                ps.setLong(3, r.getDepartmentId());
            } else {
                ps.setNull(3, java.sql.Types.BIGINT);
            }
            ps.setString(4, r.getJobTitle());
            ps.setString(5, r.getBio());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    public void delete(long id) {
        String sql = "UPDATE RecruiterProfiles "
                + "SET Status='INACTIVE' "
                + "WHERE RecruiterId=?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // GET BY ID
    public Recruiter getById(long id) {
        String sql = "SELECT * FROM RecruiterProfiles WHERE RecruiterId=?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Recruiter r = new Recruiter();
                r.setRecruiterId(rs.getLong("RecruiterId"));
                r.setUserId(rs.getLong("UserId"));
                r.setCompanyId(rs.getLong("CompanyId"));
                r.setDepartmentId(rs.getLong("DepartmentId"));
                r.setJobTitle(rs.getString("JobTitle"));
                r.setStatus(rs.getString("Status"));
                r.setBio(rs.getString("Bio"));
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET BY USER ID
    public Recruiter getByUserId(long userId) {
        String sql = "SELECT * FROM RecruiterProfiles WHERE UserId=?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Recruiter r = new Recruiter();
                r.setRecruiterId(rs.getLong("RecruiterId"));
                r.setUserId(rs.getLong("UserId"));
                r.setCompanyId(rs.getLong("CompanyId"));
                r.setJobTitle(rs.getString("JobTitle"));
                r.setStatus(rs.getString("Status"));
                r.setBio(rs.getString("Bio"));
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE – trả về true nếu thành công
    public boolean update(Recruiter r) {
        String sql = "UPDATE RecruiterProfiles "
                + "SET CompanyId=?, DepartmentId=?, JobTitle=?, Bio=? "
                + "WHERE RecruiterId=?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // CompanyId (bắt buộc)
            ps.setLong(1, r.getCompanyId());

            // DepartmentId (có thể null)
            if (r.getDepartmentId() != null) {
                ps.setLong(2, r.getDepartmentId());
            } else {
                ps.setNull(2, java.sql.Types.BIGINT);
            }

            // JobTitle
            ps.setString(3, r.getJobTitle());

            // Bio (có thể null)
            ps.setString(4, r.getBio());

            // Where
            ps.setLong(5, r.getRecruiterId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Recruiter> getRecruitersByCompanyId(long companyId) {
        List<Recruiter> list = new ArrayList<>();

        String sql = "SELECT rp.RecruiterId, rp.UserId, rp.CompanyId, rp.JobTitle, rp.IsPrimaryContact, rp.Status, "
                + "u.FullName, u.Email, u.PhoneNumber, u.AvatarUrl "
                + "FROM RecruiterProfiles rp "
                + "INNER JOIN Users u ON rp.UserId = u.UserId "
                + "WHERE rp.CompanyId = ? "
                + "ORDER BY rp.IsPrimaryContact DESC, u.FullName ASC";

        try {
            PreparedStatement ps = dbContext.getConnection().prepareStatement(sql);
            ps.setLong(1, companyId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Recruiter recruiter = new Recruiter();
                recruiter.setRecruiterId(rs.getLong("RecruiterId"));
                recruiter.setUserId(rs.getLong("UserId"));
                recruiter.setCompanyId(rs.getLong("CompanyId"));
                recruiter.setJobTitle(rs.getString("JobTitle"));
                recruiter.setIsPrimaryContact(rs.getBoolean("IsPrimaryContact"));
                recruiter.setStatus(rs.getString("Status"));
                recruiter.setFullName(rs.getString("FullName"));
                recruiter.setEmail(rs.getString("Email"));
                recruiter.setPhoneNumber(rs.getString("PhoneNumber"));
                recruiter.setAvatarUrl(rs.getString("AvatarUrl"));

                list.add(recruiter);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Recruiter getRecruiterDetailById(long recruiterId) {
        String sql = "SELECT rp.RecruiterId, rp.UserId, rp.CompanyId, rp.JobTitle, rp.IsPrimaryContact, rp.Bio, rp.Status, "
                + "u.FullName, u.Email, u.PhoneNumber, u.AvatarUrl "
                + "FROM RecruiterProfiles rp "
                + "INNER JOIN Users u ON rp.UserId = u.UserId "
                + "WHERE rp.RecruiterId = ?";

        try {
            PreparedStatement ps = dbContext.getConnection().prepareStatement(sql);
            ps.setLong(1, recruiterId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Recruiter recruiter = new Recruiter();
                recruiter.setRecruiterId(rs.getLong("RecruiterId"));
                recruiter.setUserId(rs.getLong("UserId"));
                recruiter.setCompanyId(rs.getLong("CompanyId"));
                recruiter.setJobTitle(rs.getString("JobTitle"));
                recruiter.setIsPrimaryContact(rs.getBoolean("IsPrimaryContact"));
                recruiter.setStatus(rs.getString("Status"));
                recruiter.setFullName(rs.getString("FullName"));
                recruiter.setEmail(rs.getString("Email"));
                recruiter.setPhoneNumber(rs.getString("PhoneNumber"));
                recruiter.setAvatarUrl(rs.getString("AvatarUrl"));
                recruiter.setBio(rs.getString("Bio"));
                return recruiter;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ── Pagination & filtering ────────────────────────────────────────────────

    /** Tổng số recruiter trong DB – cho stats strip. */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM RecruiterProfiles";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /** Recruiter đang ACTIVE – cho stats strip. */
    public int countActive() {
        String sql = "SELECT COUNT(*) FROM RecruiterProfiles WHERE Status = 'ACTIVE'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /** Trả về một trang recruiter đã lọc (keyword, status, companyName). */
    public List<Recruiter> getFiltered(String keyword, String status,
                                       String company, int page, int pageSize) {
        List<Recruiter> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, c.CompanyName, d.DepartmentName, u.FullName, u.Email " +
            "FROM RecruiterProfiles r " +
            "LEFT JOIN Companies c ON r.CompanyId = c.CompanyId " +
            "LEFT JOIN Departments d ON r.DepartmentId = d.DepartmentId " +
            "LEFT JOIN Users u ON r.UserId = u.UserId WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        applyRecruiterFilters(sql, params, keyword, status, company);
        sql.append("ORDER BY r.RecruiterId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Recruiter r = new Recruiter();
                r.setRecruiterId(rs.getLong("RecruiterId"));
                r.setUserId(rs.getLong("UserId"));
                r.setCompanyId(rs.getLong("CompanyId"));
                r.setJobTitle(rs.getString("JobTitle"));
                r.setStatus(rs.getString("Status"));
                r.setCompanyName(rs.getString("CompanyName"));
                r.setDepartmentName(rs.getString("DepartmentName"));
                r.setBio(rs.getString("Bio"));
                r.setFullName(rs.getString("FullName"));
                r.setEmail(rs.getString("Email"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Đếm recruiter thỏa filter – dùng tính totalPages. */
    public int countFiltered(String keyword, String status, String company) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM RecruiterProfiles r " +
            "LEFT JOIN Companies c ON r.CompanyId = c.CompanyId " +
            "LEFT JOIN Users u ON r.UserId = u.UserId WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        applyRecruiterFilters(sql, params, keyword, status, company);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private void applyRecruiterFilters(StringBuilder sql, List<Object> params,
                                       String keyword, String status, String company) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (u.FullName LIKE ? OR u.Email LIKE ? OR c.CompanyName LIKE ?) ");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        if (status != null && !status.isEmpty() && !"All".equals(status)) {
            sql.append("AND r.Status = ? ");
            params.add(status);
        }
        if (company != null && !company.isEmpty() && !"All".equals(company)) {
            sql.append("AND c.CompanyName = ? ");
            params.add(company);
        }
    }
}
