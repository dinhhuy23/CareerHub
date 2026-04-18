package dal;

import model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO: Xử lý CRUD cho bảng Notifications.
 * Cung cấp các hàm: tạo thông báo, lấy danh sách, đánh dấu đã đọc.
 */
public class NotificationDAO {
    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    // ==========================================
    // Tạo một thông báo mới
    // ==========================================
    public boolean insert(Notification n) {
        String sql = "INSERT INTO Notifications (UserId, Title, Message, Type, RelatedId, IsRead, CreatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, 0, SYSUTCDATETIME())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, n.getUserId());
            ps.setString(2, n.getTitle());
            ps.setString(3, n.getMessage());
            ps.setString(4, n.getType() != null ? n.getType() : "SYSTEM");
            if (n.getRelatedId() > 0) ps.setLong(5, n.getRelatedId());
            else ps.setNull(5, Types.BIGINT);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting notification for userId=" + n.getUserId(), e);
        }
        return false;
    }

    // ==========================================
    // Lấy tất cả thông báo của người dùng (mới nhất trước)
    // ==========================================
    public List<Notification> findByUserId(long userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT TOP 30 * FROM Notifications WHERE UserId = ? ORDER BY CreatedAt DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching notifications for userId=" + userId, e);
        }
        return list;
    }

    // ==========================================
    // Đếm số thông báo chưa đọc (cho badge trên chuông)
    // ==========================================
    public int countUnread(long userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE UserId = ? AND IsRead = 0";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unread notifications", e);
        }
        return 0;
    }

    // ==========================================
    // Đánh dấu tất cả là đã đọc
    // ==========================================
    public boolean markAllAsRead(long userId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE UserId = ? AND IsRead = 0";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notifications as read", e);
        }
        return false;
    }

    // ==========================================
    // Đánh dấu một thông báo là đã đọc
    // ==========================================
    public boolean markAsRead(long notificationId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read", e);
        }
        return false;
    }

    // ==========================================
    // Helper: Map ResultSet -> Notification object
    // ==========================================
    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getLong("NotificationId"));
        n.setUserId(rs.getLong("UserId"));
        n.setTitle(rs.getString("Title"));
        n.setMessage(rs.getString("Message"));
        n.setType(rs.getString("Type"));
        n.setRead(rs.getBoolean("IsRead"));
        long relId = rs.getLong("RelatedId");
        if (!rs.wasNull()) n.setRelatedId(relId);
        n.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return n;
    }
}
