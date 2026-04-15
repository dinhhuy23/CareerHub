package dal;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Users table.
 * Provides CRUD operations for user management.
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    /**
     * Find a user by email address.
     * @param email The email to search
     * @return User object or null if not found
     */
    public User findByEmail(String email) {
        String sql = "SELECT u.*, ur.RoleId, r.RoleCode, r.RoleName "
                   + "FROM Users u "
                   + "LEFT JOIN UserRoles ur ON u.UserId = ur.UserId AND ur.IsActive = 1 "
                   + "LEFT JOIN Roles r ON ur.RoleId = r.RoleId "
                   + "WHERE u.Email = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user by email: " + email, e);
        }
        return null;
    }

    /**
     * Find a user by their ID.
     * @param userId The user ID
     * @return User object or null
     */
    public User findById(long userId) {
        String sql = "SELECT u.*, ur.RoleId, r.RoleCode, r.RoleName "
                   + "FROM Users u "
                   + "LEFT JOIN UserRoles ur ON u.UserId = ur.UserId AND ur.IsActive = 1 "
                   + "LEFT JOIN Roles r ON ur.RoleId = r.RoleId "
                   + "WHERE u.UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user by ID: " + userId, e);
        }
        return null;
    }

    /**
     * Check if an email already exists in the database.
     * @param email The email to check
     * @return true if email exists
     */
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking email existence: " + email, e);
        }
        return false;
    }

    /**
     * Insert a new user into the database.
     * @param user The user to insert
     * @return The generated user ID, or -1 if failed
     */
    public long insert(User user) {
        String sql = "INSERT INTO Users (Email, PasswordHash, FullName, PhoneNumber, "
                   + "Gender, Status, EmailVerified, CreatedAt, UpdatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME(), SYSUTCDATETIME())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getGender());
            ps.setString(6, "ACTIVE");
            ps.setBoolean(7, false);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getLong(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting user: " + user.getEmail(), e);
        }
        return -1;
    }

    /**
     * Delete a user by ID.
     * @param userId The user ID
     * @return true if delete was successful
     */
    public boolean deleteById(long userId) {
        String sql = "DELETE FROM Users WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting user: " + userId, e);
        }
        return false;
    }

    /**
     * Update user profile information.
     * @param user The user with updated data
     * @return true if update was successful
     */
    public boolean update(User user) {
        String sql = "UPDATE Users SET Email = ?, FullName = ?, PhoneNumber = ?, "
                   + "Gender = ?, DateOfBirth = ?, UpdatedAt = SYSUTCDATETIME() "
                   + "WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getGender());
            ps.setDate(5, user.getDateOfBirth());
            ps.setLong(6, user.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user: " + user.getUserId(), e);
        }
        return false;
    }

    /**
     * Update user's password.
     * @param userId The user ID
     * @param newPasswordHash The new BCrypt hashed password
     * @return true if update was successful
     */
    public boolean updatePassword(long userId, String newPasswordHash) {
        String sql = "UPDATE Users SET PasswordHash = ?, UpdatedAt = SYSUTCDATETIME() WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating password for user: " + userId, e);
        }
        return false;
    }

    /**
     * Update the last login timestamp for a user.
     * @param userId The user ID
     */
    public void updateLastLogin(long userId) {
        String sql = "UPDATE Users SET LastLoginAt = SYSUTCDATETIME() WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating last login for user: " + userId, e);
        }
    }

    /**
     * Check if email exists for another user (used during profile update).
     * @param email Email to check
     * @param excludeUserId User ID to exclude from check
     * @return true if email is taken by another user
     */
    public boolean emailExistsForOtherUser(String email, long excludeUserId) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ? AND UserId != ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setLong(2, excludeUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking email for other user", e);
        }
        return false;
    }

    /**
     * Find users for admin listing with optional filtering and paging.
     * @param keyword Email or full name keyword
     * @param roleCode Role code filter
     * @param status Status filter
     * @param page Page number (1-based)
     * @param pageSize Page size
     * @return List of users
     */
    public List<User> findUsersForAdmin(String keyword, String roleCode, String status, int page, int pageSize) {
        List<User> users = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.*, r.RoleCode, r.RoleName ")
           .append("FROM Users u ")
           .append("LEFT JOIN UserRoles ur ON u.UserId = ur.UserId AND ur.IsActive = 1 ")
           .append("LEFT JOIN Roles r ON ur.RoleId = r.RoleId ")
           .append("WHERE 1 = 1 ");

        List<Object> params = new ArrayList<>();
        appendAdminUserFilters(sql, params, keyword, roleCode, status);

        sql.append(" ORDER BY u.CreatedAt DESC ")
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        int safePage = Math.max(1, page);
        int safePageSize = Math.max(1, pageSize);
        int offset = (safePage - 1) * safePageSize;

        params.add(offset);
        params.add(safePageSize);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding users for admin", e);
        }

        return users;
    }

    /**
     * Count users for admin listing with optional filtering.
     * @param keyword Email or full name keyword
     * @param roleCode Role code filter
     * @param status Status filter
     * @return Number of users
     */
    public int countUsersForAdmin(String keyword, String roleCode, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ")
           .append("FROM Users u ")
           .append("LEFT JOIN UserRoles ur ON u.UserId = ur.UserId AND ur.IsActive = 1 ")
           .append("LEFT JOIN Roles r ON ur.RoleId = r.RoleId ")
           .append("WHERE 1 = 1 ");

        List<Object> params = new ArrayList<>();
        appendAdminUserFilters(sql, params, keyword, roleCode, status);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindParams(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting users for admin", e);
        }

        return 0;
    }

    /**
     * Insert a new user by admin with configurable status.
     * @param user The user to insert
     * @param status Initial status
     * @return Generated user ID, or -1 if failed
     */
    public long insertByAdmin(User user, String status) {
        String sql = "INSERT INTO Users (Email, PasswordHash, FullName, PhoneNumber, "
                   + "Gender, DateOfBirth, Status, EmailVerified, CreatedAt, UpdatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME(), SYSUTCDATETIME())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getGender());
            ps.setDate(6, user.getDateOfBirth());
            ps.setString(7, status);
            ps.setBoolean(8, false);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getLong(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting user by admin: " + user.getEmail(), e);
        }

        return -1;
    }

    /**
     * Update user profile fields by admin.
     * @param user User data to update
     * @param status New status
     * @return true if update successful
     */
    public boolean updateByAdmin(User user, String status) {
        String sql = "UPDATE Users SET Email = ?, FullName = ?, PhoneNumber = ?, "
                   + "Gender = ?, DateOfBirth = ?, Status = ?, UpdatedAt = SYSUTCDATETIME() "
                   + "WHERE UserId = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getGender());
            ps.setDate(5, user.getDateOfBirth());
            ps.setString(6, status);
            ps.setLong(7, user.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user by admin: " + user.getUserId(), e);
        }

        return false;
    }

    /**
     * Update only status field for a user.
     * @param userId User ID
     * @param status New status
     * @return true if update successful
     */
    public boolean updateUserStatus(long userId, String status) {
        String sql = "UPDATE Users SET Status = ?, UpdatedAt = SYSUTCDATETIME() WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user status for user: " + userId, e);
        }
        return false;
    }

    private void appendAdminUserFilters(StringBuilder sql, List<Object> params,
                                        String keyword, String roleCode, String status) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.Email LIKE ? OR u.FullName LIKE ?)");
            String keywordParam = "%" + keyword.trim() + "%";
            params.add(keywordParam);
            params.add(keywordParam);
        }

        if (roleCode != null && !roleCode.trim().isEmpty()) {
            sql.append(" AND r.RoleCode = ?");
            params.add(roleCode.trim());
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND u.Status = ?");
            params.add(status.trim());
        }
    }

    private void bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            Object param = params.get(i);
            int index = i + 1;

            if (param instanceof Integer) {
                ps.setInt(index, (Integer) param);
            } else if (param instanceof Long) {
                ps.setLong(index, (Long) param);
            } else if (param instanceof String) {
                ps.setString(index, (String) param);
            } else {
                ps.setObject(index, param);
            }
        }
    }

    // --- Helper method to map ResultSet to User ---
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getLong("UserId"));
        user.setEmail(rs.getString("Email"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setFullName(rs.getString("FullName"));
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setAvatarUrl(rs.getString("AvatarUrl"));
        user.setGender(rs.getString("Gender"));
        user.setDateOfBirth(rs.getDate("DateOfBirth"));
        user.setStatus(rs.getString("Status"));
        user.setEmailVerified(rs.getBoolean("EmailVerified"));
        user.setLastLoginAt(rs.getTimestamp("LastLoginAt"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        user.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

        // Role info (may be null if no role assigned)
        try {
            user.setRoleCode(rs.getString("RoleCode"));
            user.setRoleName(rs.getString("RoleName"));
        } catch (SQLException e) {
            // Role columns not present in query
        }

        return user;
    }
}
