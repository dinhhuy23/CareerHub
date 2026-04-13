package dal;

import model.ExperienceLevel;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ExperienceLevelDAO {
    private static final Logger LOGGER = Logger.getLogger(ExperienceLevelDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    public List<ExperienceLevel> getAllActive() {
        List<ExperienceLevel> list = new ArrayList<>();
        String sql = "SELECT * FROM ExperienceLevels WHERE IsActive = 1 ORDER BY SortOrder";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ExperienceLevel e = new ExperienceLevel();
                e.setExperienceLevelId(rs.getLong("ExperienceLevelId"));
                e.setLevelCode(rs.getString("LevelCode"));
                e.setLevelName(rs.getString("LevelName"));
                e.setSortOrder(rs.getInt("SortOrder"));
                e.setActive(rs.getBoolean("IsActive"));
                list.add(e);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting experience levels", e);
        }
        return list;
    }
}
