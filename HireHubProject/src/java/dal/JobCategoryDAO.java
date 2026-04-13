package dal;

import model.JobCategory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class JobCategoryDAO {
    private static final Logger LOGGER = Logger.getLogger(JobCategoryDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    public List<JobCategory> getAllActive() {
        List<JobCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM JobCategories WHERE IsActive = 1 ORDER BY CategoryName";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JobCategory c = new JobCategory();
                c.setCategoryId(rs.getLong("CategoryId"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setParentCategoryId(rs.getObject("ParentCategoryId") != null ? rs.getLong("ParentCategoryId") : null);
                c.setDescription(rs.getString("Description"));
                c.setActive(rs.getBoolean("IsActive"));
                c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(c);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting job categories", e);
        }
        return list;
    }
}
