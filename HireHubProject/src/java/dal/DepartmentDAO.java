/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Department;

/**
 *
 * @author Admin
 */
public class DepartmentDAO {

    private final DBContext dbContext = new DBContext();

    public List<Department> getAll() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT DepartmentId, DepartmentName FROM Departments";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Department d = new Department();
                d.setDepartmentId(rs.getLong("DepartmentId"));
                d.setDepartmentName(rs.getString("DepartmentName"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
