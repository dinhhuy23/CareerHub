package dal;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Company;

public class CompanyDAO {

    private final DBContext dbContext = new DBContext();

    public List<Company> getAll() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT CompanyId, CompanyName FROM Companies";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Company c = new Company();
                c.setCompanyId(rs.getLong("CompanyId"));
                c.setCompanyName(rs.getString("CompanyName"));
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

        try {
            PreparedStatement ps = dbContext.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

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
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getLong(1);
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

        try {
            PreparedStatement ps = dbContext.getConnection().prepareStatement(sql);

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
}
