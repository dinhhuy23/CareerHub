package dal;

import model.User;
import java.sql.*;
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
     * Lấy danh sách tất cả ứng viên (role CANDIDATE) kèm CV mặc định
     */
    public java.util.List<User> findAllCandidates() {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT u.*, r.RoleCode, r.RoleName, "
                   + "(SELECT TOP 1 cr.FileUrl FROM CandidateResumes cr "
                   + " JOIN CandidateProfiles cp ON cr.CandidateId = cp.CandidateId "
                   + " WHERE cp.UserId = u.UserId AND cr.IsDefault = 1) as DefaultCvUrl "
                   + "FROM Users u "
                   + "JOIN UserRoles ur ON u.UserId = ur.UserId AND ur.IsActive = 1 "
                   + "JOIN Roles r ON ur.RoleId = r.RoleId "
                   + "WHERE r.RoleCode = 'CANDIDATE' "
                   + "ORDER BY u.CreatedAt DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setCvUrl(rs.getString("DefaultCvUrl"));
                list.add(user);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all candidates", e);
        }
        return list;
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

        // Cột ContactEmail có thể null nếu chưa thiết lập
        try {
            user.setContactEmail(rs.getString("ContactEmail"));
        } catch (SQLException e) {
            // column không có trong query này, bỏ qua
        }

        // Role info (may be null if no role assigned)
        try {
            user.setRoleCode(rs.getString("RoleCode"));
            user.setRoleName(rs.getString("RoleName"));
        } catch (SQLException e) {
            // Role columns not present in query
        }

        return user;
    }

    /**
     * Cập nhật ContactEmail (Gmail liên hệ) của user.
     * Hoàn toàn độc lập với Email đăng nhập.
     * @param userId  ID người dùng
     * @param contactEmail  Giá trị mới (có thể null nếu muốn xóa liên kết)
     * @return true nếu cập nhật thành công
     */
    public boolean updateContactEmail(long userId, String contactEmail) {
        String sql = "UPDATE Users SET ContactEmail = ?, UpdatedAt = SYSUTCDATETIME() WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (contactEmail == null || contactEmail.trim().isEmpty()) {
                ps.setNull(1, java.sql.Types.VARCHAR);
            } else {
                ps.setString(1, contactEmail.trim().toLowerCase());
            }
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating contactEmail for user: " + userId, e);
        }
        return false;
    }

    /**
     * Kiểm tra xem ContactEmail đã được sử dụng bởi user khác chưa.
     * Mọi người chỉ được liên kết 1 ContactEmail duy nhất.
     * @param contactEmail  Email cần kiểm tra
     * @param excludeUserId  Trừ user hiện tại khỏi kiểm tra
     * @return true nếu email đã tồn tại ở user khác
     */
    public boolean contactEmailExistsForOtherUser(String contactEmail, long excludeUserId) {
        String sql = "SELECT COUNT(*) FROM Users WHERE ContactEmail = ? AND UserId != ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contactEmail.trim().toLowerCase());
            ps.setLong(2, excludeUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking contactEmail uniqueness", e);
        }
        return false;
    }
}
