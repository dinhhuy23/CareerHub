package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Department;

public class DepartmentDAO {

    private final DBContext dbContext = new DBContext();

    // GET ALL with company name join
    public List<Department> getAll() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT d.*, c.CompanyName FROM Departments d "
                + "LEFT JOIN Companies c ON d.CompanyId = c.CompanyId "
                + "ORDER BY d.DepartmentId ASC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Department d = new Department();
                d.setDepartmentId(rs.getLong("DepartmentId"));
                d.setDepartmentName(rs.getString("DepartmentName"));
                d.setDescription(rs.getString("Description"));
                d.setIsActive(rs.getBoolean("IsActive"));
                d.setCompanyId(rs.getLong("CompanyId"));
                d.setCompanyName(rs.getString("CompanyName"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET BY COMPANY ID
    public List<Department> getByCompanyId(int companyId) {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM Departments WHERE CompanyId = ? AND IsActive = 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, companyId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Department d = new Department();
                d.setDepartmentId(rs.getLong("DepartmentId"));
                d.setDepartmentName(rs.getString("DepartmentName"));
                d.setCompanyId(rs.getLong("CompanyId"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET BY ID
    public Department getById(long id) {
        String sql = "SELECT d.*, c.CompanyName FROM Departments d "
                + "LEFT JOIN Companies c ON d.CompanyId = c.CompanyId "
                + "WHERE d.DepartmentId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Department d = new Department();
                d.setDepartmentId(rs.getLong("DepartmentId"));
                d.setDepartmentName(rs.getString("DepartmentName"));
                d.setDescription(rs.getString("Description"));
                d.setIsActive(rs.getBoolean("IsActive"));
                d.setCompanyId(rs.getLong("CompanyId"));
                d.setCompanyName(rs.getString("CompanyName"));
                return d;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // INSERT
    public void insert(Department d) {
        String sql = "INSERT INTO Departments (DepartmentName, Description, CompanyId, IsActive) VALUES (?, ?, ?, 1)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, d.getDepartmentName());
            ps.setString(2, d.getDescription());
            ps.setLong(3, d.getCompanyId());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // UPDATE
    public void update(Department d) {
        String sql = "UPDATE Departments SET DepartmentName = ?, Description = ?, CompanyId = ? WHERE DepartmentId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, d.getDepartmentName());
            ps.setString(2, d.getDescription());
            ps.setLong(3, d.getCompanyId());
            ps.setLong(4, d.getDepartmentId());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // SOFT DELETE (set IsActive = 0)
    public void delete(long id) {
        String sql = "UPDATE Departments SET IsActive = 0 WHERE DepartmentId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
