package dal;

import model.Company;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CompanyDAO {
    private final DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(CompanyDAO.class.getName());

    public CompanyDAO() {
        this.dbContext = new DBContext();
    }

    public Company findById(long id) {
        String sql = "SELECT * FROM Companies WHERE CompanyId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Company c = new Company();
                    c.setCompanyId(rs.getLong("CompanyId"));
                    c.setCompanyName(rs.getString("CompanyName"));
                    c.setWebsiteUrl(rs.getString("WebsiteUrl"));
                    c.setLogoUrl(rs.getString("LogoUrl"));
                    c.setIndustry(rs.getString("Industry"));
                    c.setEstablishedYear(rs.getObject("EstablishedYear") != null ? rs.getInt("EstablishedYear") : null);
                    c.setAddress(rs.getString("Address"));
                    c.setDescription(rs.getString("Description"));
                    c.setStatus(rs.getString("Status"));
                    c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    return c;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding company id=" + id, e);
        }
        return null;
    }
}
