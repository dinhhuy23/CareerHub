package dal;

import model.EmploymentType;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmploymentTypeDAO {
    private static final Logger LOGGER = Logger.getLogger(EmploymentTypeDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    public List<EmploymentType> getAllActive() {
        List<EmploymentType> list = new ArrayList<>();
        String sql = "SELECT * FROM EmploymentTypes WHERE IsActive = 1 ORDER BY TypeName";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                EmploymentType e = new EmploymentType();
                e.setEmploymentTypeId(rs.getLong("EmploymentTypeId"));
                e.setTypeCode(rs.getString("TypeCode"));
                e.setTypeName(rs.getString("TypeName"));
                e.setActive(rs.getBoolean("IsActive"));
                list.add(e);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting employment types", e);
        }
        return list;
    }
}
