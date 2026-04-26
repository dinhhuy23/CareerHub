package dal;

import model.Report;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    DBContext db = new DBContext();

    // Thêm report
    public void insert(Report r) {
        String sql = "INSERT INTO Report (ReporterId, TargetType, TargetId, ReportTypeId, Content, Status) "
                   + "VALUES (?, ?, ?, ?, ?, 'PENDING')";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, r.getReporterId());
            ps.setString(2, r.getTargetType());
            ps.setLong(3, r.getTargetId());
            ps.setLong(4, r.getReportTypeId());
            ps.setString(5, r.getContent());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public Report getById(long id) {
    String sql = "SELECT * FROM Report WHERE ReportId = ?";
    try (Connection con = db.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setLong(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Report r = new Report();
            r.setReportId(rs.getLong("ReportId"));
            r.setReporterId(rs.getLong("ReporterId"));
            return r;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
    
    // Lấy tất cả report (admin)
    public List<Report> getAll() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT * FROM Report";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Report r = new Report();
                r.setReportId(rs.getLong("ReportId"));
                r.setReporterId(rs.getLong("ReporterId"));
                r.setTargetType(rs.getString("TargetType"));
                r.setTargetId(rs.getLong("TargetId"));
                r.setReportTypeId(rs.getLong("ReportTypeId"));
                r.setContent(rs.getString("Content"));
                r.setStatus(rs.getString("Status"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Update status (admin xử lý)
    public void updateStatus(long id, String status, long adminId) {
        String sql = "UPDATE Report SET Status=?, HandledBy=?, HandledAt=GETDATE() WHERE ReportId=?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setLong(2, adminId);
            ps.setLong(3, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
