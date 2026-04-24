package dal;

import java.sql.*;
import java.util.*;
import model.ReportType;

public class ReportTypeDAO {

    DBContext db = new DBContext();

    public List<ReportType> getAll() {
        List<ReportType> list = new ArrayList<>();
        String sql = "SELECT * FROM ReportTypes WHERE IsActive = 1";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ReportType rt = new ReportType();
                rt.setReportTypeId(rs.getLong("ReportTypeId"));
                rt.setReportCode(rs.getString("ReportCode"));
                rt.setReportName(rs.getString("ReportName"));
                rt.setDescription(rs.getString("Description"));
                rt.setIsActive(rs.getBoolean("IsActive"));

                list.add(rt);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
