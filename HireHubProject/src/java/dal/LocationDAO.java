package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Location;

public class LocationDAO extends DBContext {
    private final DBContext dbContext = new DBContext();
    public List<Location> getAllActiveLocations() {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT LocationId, LocationName FROM Locations WHERE IsActive = 1 ORDER BY LocationName";

        try {
            PreparedStatement ps = dbContext.getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Location location = new Location();
                location.setLocationId(rs.getLong("LocationId"));
                location.setLocationName(rs.getString("LocationName"));
                list.add(location);
            }
        } catch (Exception e) {
            e.printStackTrace();
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