package dal;

import model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO: Xử lý CRUD cho bảng Notifications. Cung cấp các hàm: tạo thông báo, lấy
 * danh sách, đánh dấu đã đọc.
 */
public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    // ==========================================
    // Tạo một thông báo mới
    // ==========================================
    public boolean insert(Notification n) {
        String sql = "INSERT INTO Notifications (UserId, Title, Content, Type, RelatedId, IsRead, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, 0, SYSUTCDATETIME())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, n.getUserId());
            ps.setString(2, n.getTitle());
            ps.setString(3, n.getMessage());
            ps.setString(4, n.getType() != null ? n.getType() : "SYSTEM");
            if (n.getRelatedId() > 0) {
                ps.setLong(5, n.getRelatedId());
            } else {
                ps.setNull(5, Types.BIGINT);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting notification for userId=" + n.getUserId(), e);
        }
        return false;
    }
  public List<Notification> searchNotifications(String keyword, int offset, int limit) {
    List<Notification> list = new ArrayList<>();

    String sql = "SELECT * FROM Notifications "
            + "WHERE Title LIKE ? "
            + "ORDER BY CreatedAt DESC "
            + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (Connection con = dbContext.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, "%" + keyword + "%");
        ps.setInt(2, offset);
        ps.setInt(3, limit);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Notification n = new Notification();

            n.setNotificationId(rs.getLong("NotificationId"));
            n.setTitle(rs.getString("Title"));
            n.setMessage(rs.getString("Content"));
            n.setCreatedAt(rs.getTimestamp("CreatedAt"));

            list.add(n);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
public int getTotalSearchNotifications(String keyword) {
    String sql = "SELECT COUNT(*) FROM Notifications WHERE Title LIKE ?";

    try (Connection con = dbContext.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, "%" + keyword + "%");

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return 0;
}

    public List<Notification> getNotificationsPaging(int offset, int limit) {
    List<Notification> list = new ArrayList<>();

    String sql = "SELECT * FROM Notifications "
               + "ORDER BY CreatedAt DESC "
               + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, offset);
        ps.setInt(2, limit);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Notification n = new Notification();
            n.setNotificationId(rs.getLong("NotificationId"));
            n.setTitle(rs.getString("Title"));
            n.setMessage(rs.getString("Content"));
            n.setCreatedAt(rs.getTimestamp("CreatedAt"));
            list.add(n);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    public int getTotalNotifications() {
    String sql = "SELECT COUNT(*) FROM Notifications";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            return rs.getInt(1);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return 0;
}

public List<Notification> getAllNotifications() {
    List<Notification> list = new ArrayList<>();

    String sql = "SELECT * FROM Notifications ORDER BY CreatedAt DESC";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Notification n = new Notification();
            n.setNotificationId(rs.getLong("NotificationId"));
            n.setTitle(rs.getString("Title"));
            n.setMessage(rs.getString("Content"));
            n.setCreatedAt(rs.getTimestamp("CreatedAt"));
            list.add(n);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    // ==========================================
    // Lấy tất cả thông báo của người dùng (mới nhất trước)
    // ==========================================
    public List<Notification> findByUserId(long userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT TOP 30 * FROM Notifications WHERE UserId = ? ORDER BY CreatedAt DESC";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
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
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
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

        String sql = "UPDATE NotificationRecipients "
                + "SET IsRead = 1, ReadAt = GETDATE() "
                + "WHERE UserId = ? AND IsRead = 0";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==========================================
    // Đánh dấu một thông báo là đã đọc
    // ==========================================
    public void markAsRead(long recipientId) {
        String sql = "UPDATE NotificationRecipients SET IsRead = 1, ReadAt = GETDATE() WHERE NotificationRecipientId = ?";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, recipientId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void sendResult(long userId, String status) {

        String title = "📢 Báo cáo của bạn đã được xử lý";

        String content = status.equals("APPROVED")
                ? "Báo cáo của bạn đã được chấp nhận ✅"
                : "Báo cáo của bạn đã bị từ chối ❌";

        sendToUser(userId, title, content);
    }
    public void sendReportResult(long userId, String status) {

        String title = "📢 Báo cáo của bạn đã được xử lý";

        String content = status.equals("APPROVED")
                ? "Báo cáo của bạn đã được chấp nhận ✅"
                : "Báo cáo của bạn đã bị từ chối ❌";

        sendToUser(userId, title, content);
    }

    // ==========================================
    // Helper: Map ResultSet -> Notification object
    // ==========================================
    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getLong("NotificationId"));
        n.setUserId(rs.getLong("UserId"));
        n.setTitle(rs.getString("Title"));
        n.setMessage(rs.getString("Content"));
        n.setType(rs.getString("Type"));
        n.setRead(rs.getBoolean("IsRead"));
        long relId = rs.getLong("RelatedId");
        if (!rs.wasNull()) {
            n.setRelatedId(relId);
        }
        n.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return n;
    }

    public boolean sendToUser(long userId, String title, String content, long adminId) {

        String insertNoti = "INSERT INTO Notifications (Title, Content, NotificationType, CreatedByUserId, CreatedAt) "
                + "VALUES (?, ?, 'SYSTEM', ?, GETDATE())";

        String insertRec = "INSERT INTO NotificationRecipients (NotificationId, UserId, IsRead, DeliveryStatus, CreatedAt) "
                + "VALUES (?, ?, 0, 'SENT', GETDATE())";

        try (Connection con = dbContext.getConnection()) {

            con.setAutoCommit(false); // 🔥 đảm bảo atomic

            PreparedStatement ps1 = con.prepareStatement(insertNoti, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, title);
            ps1.setString(2, content);
            ps1.setLong(3, adminId);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            if (!rs.next()) {
                con.rollback();
                return false;
            }

            long notiId = rs.getLong(1);

            PreparedStatement ps2 = con.prepareStatement(insertRec);
            ps2.setLong(1, notiId);
            ps2.setLong(2, userId);
            ps2.executeUpdate();

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
     public void scheduleDeactivate(long userId) {

        String sql = "UPDATE Users SET DeactivateAt = DATEADD(day, 1, GETDATE()) WHERE UserId = ?";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.executeUpdate();

            // 🔔 gửi thông báo
            sendToUser(userId,
                    "⚠ Tài khoản sắp bị khóa",
                    "Tài khoản của bạn sẽ bị khóa sau 24h. Nếu có thắc mắc hãy liên hệ admin."
            );

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void sendToUser(long userId, String title, String content) {

        String insertNoti = "INSERT INTO Notifications (Title, Content, NotificationType, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        String insertRec = "INSERT INTO NotificationRecipients (NotificationId, UserId, IsRead, DeliveryStatus, CreatedAt) VALUES (?, ?, 0, 'SENT', GETDATE())";

        try (Connection con = dbContext.getConnection()) {

            // tạo notification
            PreparedStatement ps1 = con.prepareStatement(insertNoti, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, title);
            ps1.setString(2, content);
            ps1.setString(3, "SYSTEM");
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            rs.next();
            long notiId = rs.getLong(1);

            // insert recipient
            PreparedStatement ps2 = con.prepareStatement(insertRec);
            ps2.setLong(1, notiId);
            ps2.setLong(2, userId);
            ps2.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean sendToRole(String role, String title, String content, long adminId) {

        String insertNoti = "INSERT INTO Notifications (Title, Content, NotificationType, CreatedByUserId, CreatedAt) "
                + "VALUES (?, ?, 'SYSTEM', ?, GETDATE())";

        String getUsers = "SELECT UserId FROM Users WHERE Role = ?";

        String insertRec = "INSERT INTO NotificationRecipients (NotificationId, UserId, IsRead, DeliveryStatus, CreatedAt) "
                + "VALUES (?, ?, 0, 'SENT', GETDATE())";

        try (Connection con = dbContext.getConnection()) {

            con.setAutoCommit(false);

            PreparedStatement ps1 = con.prepareStatement(insertNoti, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, title);
            ps1.setString(2, content);
            ps1.setLong(3, adminId);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            if (!rs.next()) {
                con.rollback();
                return false;
            }

            long notiId = rs.getLong(1);

            PreparedStatement psUser = con.prepareStatement(getUsers);
            psUser.setString(1, role);
            ResultSet rsUser = psUser.executeQuery();

            PreparedStatement ps2 = con.prepareStatement(insertRec);

            while (rsUser.next()) {
                ps2.setLong(1, notiId);
                ps2.setLong(2, rsUser.getLong("UserId"));
                ps2.addBatch();
            }

            ps2.executeBatch();

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Notification> getByUser(long userId) {

        String sql = "SELECT n.*, r.IsRead, r.NotificationRecipientId "
                + "FROM Notifications n "
                + "JOIN NotificationRecipients r ON n.NotificationId = r.NotificationId "
                + "WHERE r.UserId = ? "
                + "ORDER BY n.CreatedAt DESC";

        List<Notification> list = new ArrayList<>();

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Notification n = new Notification();

                n.setNotificationId(rs.getLong("NotificationId"));
                n.setTitle(rs.getString("Title"));
                n.setMessage(rs.getString("Content"));
                n.setRead(rs.getBoolean("IsRead"));
                n.setCreatedAt(rs.getTimestamp("CreatedAt"));

                // ⚠️ QUAN TRỌNG (để mark read)
                n.setRelatedId(rs.getLong("NotificationRecipientId"));

                list.add(n);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean sendToAll(String title, String content, long adminId) {

        String insertNoti = "INSERT INTO Notifications (Title, Content, NotificationType, CreatedByUserId, CreatedAt) "
                + "VALUES (?, ?, 'SYSTEM', ?, GETDATE())";

        String getUsers = "SELECT UserId FROM Users";

        String insertRec = "INSERT INTO NotificationRecipients (NotificationId, UserId, IsRead, DeliveryStatus, CreatedAt) "
                + "VALUES (?, ?, 0, 'SENT', GETDATE())";

        try (Connection con = dbContext.getConnection()) {

            con.setAutoCommit(false);

            // 1. tạo notification
            PreparedStatement ps1 = con.prepareStatement(insertNoti, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, title);
            ps1.setString(2, content);
            ps1.setLong(3, adminId);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            if (!rs.next()) {
                con.rollback();
                return false;
            }

            long notiId = rs.getLong(1);

            // 2. lấy user
            PreparedStatement psUser = con.prepareStatement(getUsers);
            ResultSet rsUser = psUser.executeQuery();

            // 3. insert hàng loạt
            PreparedStatement ps2 = con.prepareStatement(insertRec);

            while (rsUser.next()) {
                ps2.setLong(1, notiId);
                ps2.setLong(2, rsUser.getLong("UserId"));
                ps2.addBatch();
            }

            ps2.executeBatch(); // 🔥 tối ưu performance

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void createAndSendToRole(String title, String content, long adminId, String role) {

        String insertNoti = "INSERT INTO Notifications (Title, Content, CreatedByUserId) VALUES (?, ?, ?)";
        String getUsers = "SELECT UserId FROM Users WHERE Role = ?";
        String insertRecipient = "INSERT INTO NotificationRecipients (NotificationId, UserId, IsRead) VALUES (?, ?, 0)";

        try (Connection con = dbContext.getConnection()) {

            // 1. insert notification
            PreparedStatement ps = con.prepareStatement(insertNoti, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setLong(3, adminId);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            long notificationId = 0;

            if (rs.next()) {
                notificationId = rs.getLong(1);
            }

            // 2. lấy user theo role
            PreparedStatement psUser = con.prepareStatement(getUsers);
            psUser.setString(1, role);
            ResultSet rsUser = psUser.executeQuery();

            // 3. insert vào NotificationRecipients
            while (rsUser.next()) {
                PreparedStatement psRec = con.prepareStatement(insertRecipient);
                psRec.setLong(1, notificationId);
                psRec.setLong(2, rsUser.getLong("UserId"));
                psRec.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

   

    public void autoDeactivateUsers() {

        String sql = "UPDATE Users "
                + "SET Status = 'INACTIVE' "
                + "WHERE DeactivateAt IS NOT NULL "
                + "AND DeactivateAt <= GETDATE() "
                + "AND Status = 'ACTIVE'";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int updated = ps.executeUpdate();
            if (updated > 0) {
                System.out.println("AUTO DEACTIVATED: " + updated + " users");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
