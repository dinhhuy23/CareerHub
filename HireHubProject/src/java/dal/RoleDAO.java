package dal;

import model.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Roles and UserRoles tables.
 */
public class RoleDAO {

    private static final Logger LOGGER = Logger.getLogger(RoleDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    /**
     * Find a role by its code (e.g., CANDIDATE, RECRUITER, ADMIN).
     * @param roleCode The role code
     * @return Role object or null
     */
    public Role findByRoleCode(String roleCode) {
        String sql = "SELECT * FROM Roles WHERE RoleCode = ? AND IsActive = 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRole(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding role by code: " + roleCode, e);
        }
        return null;
    }

    /**
     * Find a role by its ID.
     * @param roleId The role ID
     * @return Role object or null
     */
    public Role findByRoleId(long roleId) {
        String sql = "SELECT * FROM Roles WHERE RoleId = ? AND IsActive = 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRole(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding role by ID: " + roleId, e);
        }
        return null;
    }

    /**
     * Get all roles assigned to a user.
     * @param userId The user ID
     * @return List of Role objects
     */
    public List<Role> findRolesByUserId(long userId) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT r.* FROM Roles r "
                   + "INNER JOIN UserRoles ur ON r.RoleId = ur.RoleId "
                   + "WHERE ur.UserId = ? AND ur.IsActive = 1 AND r.IsActive = 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roles.add(mapResultSetToRole(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding roles for user: " + userId, e);
        }
        return roles;
    }

    /**
     * Assign a role to a user.
     * @param userId The user ID
     * @param roleId The role ID
     * @return true if assignment was successful
     */
    public boolean assignRole(long userId, long roleId) {
        String sql = "INSERT INTO UserRoles (UserId, RoleId, AssignedAt, IsActive) "
                   + "VALUES (?, ?, SYSUTCDATETIME(), 1)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, roleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error assigning role " + roleId + " to user " + userId, e);
        }
        return false;
    }

    /**
     * Get all available roles.
     * @return List of active roles
     */
    public List<Role> findAllActiveRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM Roles WHERE IsActive = 1 ORDER BY RoleName";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roles.add(mapResultSetToRole(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all roles", e);
        }
        return roles;
    }

    /**
     * Ensure core roles exist for registration flow.
     * @return true if operation completed successfully
     */
    public boolean ensureDefaultRoles() {
        String candidateSql = "IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleCode = 'CANDIDATE') "
                + "INSERT INTO Roles (RoleCode, RoleName, [Description], IsActive, CreatedAt) "
                + "VALUES ('CANDIDATE', N'Ứng viên', N'Người tìm việc - Candidate', 1, SYSUTCDATETIME())";
        String recruiterSql = "IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleCode = 'RECRUITER') "
                + "INSERT INTO Roles (RoleCode, RoleName, [Description], IsActive, CreatedAt) "
                + "VALUES ('RECRUITER', N'Nhà tuyển dụng', N'Người đăng tin tuyển dụng - Recruiter', 1, SYSUTCDATETIME())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement candidatePs = conn.prepareStatement(candidateSql);
             PreparedStatement recruiterPs = conn.prepareStatement(recruiterSql)) {
            candidatePs.executeUpdate();
            recruiterPs.executeUpdate();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error ensuring default roles", e);
        }
        return false;
    }

    /**
     * Set one active role for a user (deactivate others).
     * @param userId User ID
     * @param roleId Role ID to activate
     * @return true if update was successful
     */
    public boolean setUserSingleRole(long userId, long roleId) {
        String deactivateSql = "UPDATE UserRoles SET IsActive = 0 WHERE UserId = ?";
        String activateExistingSql = "UPDATE UserRoles SET IsActive = 1, AssignedAt = SYSUTCDATETIME() "
                                 + "WHERE UserId = ? AND RoleId = ?";
        String insertSql = "INSERT INTO UserRoles (UserId, RoleId, AssignedAt, IsActive) "
                       + "VALUES (?, ?, SYSUTCDATETIME(), 1)";

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement deactivatePs = conn.prepareStatement(deactivateSql);
                 PreparedStatement activatePs = conn.prepareStatement(activateExistingSql);
                 PreparedStatement insertPs = conn.prepareStatement(insertSql)) {

                deactivatePs.setLong(1, userId);
                deactivatePs.executeUpdate();

                activatePs.setLong(1, userId);
                activatePs.setLong(2, roleId);
                int activatedRows = activatePs.executeUpdate();

                if (activatedRows == 0) {
                    insertPs.setLong(1, userId);
                    insertPs.setLong(2, roleId);
                    insertPs.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Error setting single role for user: " + userId, e);
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error handling transaction for role assignment", e);
        }

        return false;
    }

    // --- Helper ---
    private Role mapResultSetToRole(ResultSet rs) throws SQLException {
        Role role = new Role();
        role.setRoleId(rs.getLong("RoleId"));
        role.setRoleCode(rs.getString("RoleCode"));
        role.setRoleName(rs.getString("RoleName"));
        role.setDescription(rs.getString("Description"));
        role.setIsActive(rs.getBoolean("IsActive"));
        role.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return role;
    }
}
