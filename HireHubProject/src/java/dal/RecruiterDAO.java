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
        String sql = "SELECT r.*, c.CompanyName, d.DepartmentName FROM RecruiterProfiles r "
                + "LEFT JOIN Companies c ON r.CompanyId = c.CompanyId "
                + "LEFT JOIN Departments d ON r.DepartmentId = d.DepartmentId WHERE r.Status = 'ACTIVE'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // INSERT
    public void insert(Recruiter r) {
        String sql = "INSERT INTO RecruiterProfiles(UserId, CompanyId, DepartmentId, JobTitle, Bio) VALUES(?,?,?,?,?)";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, r.getUserId());
            ps.setLong(2, r.getCompanyId());
            if (r.getDepartmentId() != null) {
                ps.setLong(3, r.getDepartmentId());
            } else {
                ps.setNull(3, java.sql.Types.BIGINT);
            }
            ps.setString(4, r.getJobTitle());
            ps.setString(5, r.getBio());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
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

    // UPDATE
    public void update(Recruiter r) {
        String sql = "UPDATE RecruiterProfiles "
                + "SET CompanyId=?, DepartmentId=?, JobTitle=?, Bio=? "
                + "WHERE RecruiterId=?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
