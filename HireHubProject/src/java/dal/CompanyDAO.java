package dal;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Company;
import model.Location;

public class CompanyDAO {

    private final DBContext dbContext = new DBContext();

    public List<Company> getAll() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT C.*, L.LocationName FROM Companies C left join Locations L on C.LocationId = L.LocationId";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Company c = new Company();
                c.setCompanyId(rs.getLong("CompanyId"));
                c.setCompanyName(rs.getString("CompanyName"));
                c.setIndustry(rs.getString("Industry"));
                c.setCompanySize(rs.getString("CompanySize"));
                Location location = new Location();
                location.setLocationName(rs.getString("LocationName"));
                c.setLocation(location);
                c.setWebsiteUrl(rs.getString("WebsiteUrl"));
                c.setStatus(rs.getString("Status"));
                c.setLogoUrl(rs.getString("LogoUrl"));
                c.setDescription(rs.getString("Description"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public long insertCompanyAndReturnId(Company company) {
        String sql = "INSERT INTO Companies "
                + "(CompanyName, TaxCode, WebsiteUrl, Email, PhoneNumber, LogoUrl, Description, "
                + "FoundedYear, CompanySize, Industry, AddressLine, LocationId, Status, CreatedByUserId) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getTaxCode());
            ps.setString(3, company.getWebsiteUrl());
            ps.setString(4, company.getEmail());
            ps.setString(5, company.getPhoneNumber());
            ps.setString(6, company.getLogoUrl());
            ps.setString(7, company.getDescription());

            if (company.getFoundedYear() != null) {
                ps.setInt(8, company.getFoundedYear());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            ps.setString(9, company.getCompanySize());
            ps.setString(10, company.getIndustry());
            ps.setString(11, company.getAddressLine());

            if (company.getLocationId() != null) {
                ps.setLong(12, company.getLocationId());
            } else {
                ps.setNull(12, java.sql.Types.BIGINT);
            }

            ps.setString(13, company.getStatus());

            if (company.getCreatedByUserId() != null) {
                ps.setLong(14, company.getCreatedByUserId());
            } else {
                ps.setNull(14, java.sql.Types.BIGINT);
            }

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getLong(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public Company getCompanyById(long companyId) {
        String sql = "SELECT * FROM Companies WHERE CompanyId = ?";
        try {
            PreparedStatement ps = dbContext.getConnection().prepareStatement(sql);
            ps.setLong(1, companyId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Company company = new Company();
                company.setCompanyId(rs.getLong("CompanyId"));
                company.setCompanyName(rs.getString("CompanyName"));
                company.setTaxCode(rs.getString("TaxCode"));
                company.setWebsiteUrl(rs.getString("WebsiteUrl"));
                company.setEmail(rs.getString("Email"));
                company.setPhoneNumber(rs.getString("PhoneNumber"));
                company.setLogoUrl(rs.getString("LogoUrl"));
                company.setDescription(rs.getString("Description"));

                int foundedYear = rs.getInt("FoundedYear");
                if (!rs.wasNull()) {
                    company.setFoundedYear(foundedYear);
                }

                company.setCompanySize(rs.getString("CompanySize"));
                company.setIndustry(rs.getString("Industry"));
                company.setAddressLine(rs.getString("AddressLine"));

                long locationId = rs.getLong("LocationId");
                if (!rs.wasNull()) {
                    company.setLocationId(locationId);
                }

                company.setStatus(rs.getString("Status"));

                long createdByUserId = rs.getLong("CreatedByUserId");
                if (!rs.wasNull()) {
                    company.setCreatedByUserId(createdByUserId);
                }

                company.setCreatedAt(rs.getTimestamp("CreatedAt"));
                company.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                return company;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateCompany(Company company) {
        String sql = "UPDATE Companies SET "
                + "CompanyName = ?, "
                + "TaxCode = ?, "
                + "WebsiteUrl = ?, "
                + "Email = ?, "
                + "PhoneNumber = ?, "
                + "LogoUrl = ?, "
                + "Description = ?, "
                + "FoundedYear = ?, "
                + "CompanySize = ?, "
                + "Industry = ?, "
                + "AddressLine = ?, "
                + "LocationId = ?, "
                + "Status = ?, "
                + "UpdatedAt = SYSDATETIME() "
                + "WHERE CompanyId = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getTaxCode());
            ps.setString(3, company.getWebsiteUrl());
            ps.setString(4, company.getEmail());
            ps.setString(5, company.getPhoneNumber());
            ps.setString(6, company.getLogoUrl());
            ps.setString(7, company.getDescription());

            if (company.getFoundedYear() != null) {
                ps.setInt(8, company.getFoundedYear());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            ps.setString(9, company.getCompanySize());
            ps.setString(10, company.getIndustry());
            ps.setString(11, company.getAddressLine());

            if (company.getLocationId() != null) {
                ps.setLong(12, company.getLocationId());
            } else {
                ps.setNull(12, java.sql.Types.BIGINT);
            }

            ps.setString(13, company.getStatus());
            ps.setLong(14, company.getCompanyId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Company findById(long id) {
        return getCompanyById(id);
    }

    // ── Pagination & filtering ────────────────────────────────────────────────

    /** Total companies in DB – dùng cho stats strip (không phụ thuộc filter). */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Companies";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /** Active companies – dùng cho stats strip. */
    public int countActive() {
        String sql = "SELECT COUNT(*) FROM Companies WHERE Status = 'ACTIVE'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Trả về một trang công ty đã được lọc.
     * Truyền null/""/""All"" để bỏ qua một điều kiện lọc.
     */
    public List<Company> getFiltered(String keyword, String industry,
                                     String location, int page, int pageSize) {
        List<Company> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT C.*, L.LocationName FROM Companies C " +
            "LEFT JOIN Locations L ON C.LocationId = L.LocationId WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        applyCompanyFilters(sql, params, keyword, industry, location);
        sql.append("ORDER BY C.CompanyId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Company c = new Company();
                c.setCompanyId(rs.getLong("CompanyId"));
                c.setCompanyName(rs.getString("CompanyName"));
                c.setIndustry(rs.getString("Industry"));
                c.setCompanySize(rs.getString("CompanySize"));
                Location loc = new Location();
                loc.setLocationName(rs.getString("LocationName"));
                c.setLocation(loc);
                c.setWebsiteUrl(rs.getString("WebsiteUrl"));
                c.setStatus(rs.getString("Status"));
                c.setLogoUrl(rs.getString("LogoUrl"));
                c.setDescription(rs.getString("Description"));
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Đếm số công ty thỏa filter – dùng để tính totalPages. */
    public int countFiltered(String keyword, String industry, String location) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM Companies C " +
            "LEFT JOIN Locations L ON C.LocationId = L.LocationId WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        applyCompanyFilters(sql, params, keyword, industry, location);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private void applyCompanyFilters(StringBuilder sql, List<Object> params,
                                     String keyword, String industry, String location) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (C.CompanyName LIKE ? OR C.Industry LIKE ?) ");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        if (industry != null && !industry.isEmpty() && !"All".equals(industry)) {
            sql.append("AND C.Industry = ? ");
            params.add(industry);
        }
        if (location != null && !location.isEmpty() && !"All".equals(location)) {
            sql.append("AND L.LocationName = ? ");
            params.add(location);
        }
    }
}
