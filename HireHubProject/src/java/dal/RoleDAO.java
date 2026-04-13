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
