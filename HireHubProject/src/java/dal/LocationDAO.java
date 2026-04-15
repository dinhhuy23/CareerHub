package dal;

import model.Location;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LocationDAO {
    private static final Logger LOGGER = Logger.getLogger(LocationDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    public List<Location> getAllActive() {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT * FROM Locations WHERE IsActive = 1 ORDER BY LocationName";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Location l = new Location();
                l.setLocationId(rs.getLong("LocationId"));
                l.setLocationName(rs.getString("LocationName"));
                l.setLocationType(rs.getString("LocationType"));
                l.setParentLocationId(rs.getObject("ParentLocationId") != null ? rs.getLong("ParentLocationId") : null);
                l.setPostalCode(rs.getString("PostalCode"));
                l.setActive(rs.getBoolean("IsActive"));
                list.add(l);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting locations", e);
        }
        return list;
    }

    public String getLocationNameById(long locationId) {
        String sql = "SELECT LocationName FROM Locations WHERE LocationId = ?";
        try {
            PreparedStatement ps = dbContext.getConnection().prepareStatement(sql);
            ps.setLong(1, locationId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("LocationName");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
}
