package model;

import java.sql.Timestamp;

/**
 * Model: Thông báo hệ thống.
 * Mỗi bản ghi tương ứng một thông báo gửi đến một người dùng cụ thể.
 */
public class Notification {
    private long notificationId;   // ID thông báo
    private long userId;           // Người nhận thông báo
    private String title;          // Tiêu đề ngắn
    private String message;        // Nội dung chi tiết
    private String type;           // Loại: APPLICATION_UPDATE / NEW_APPLICANT / SYSTEM
    private boolean isRead;        // Đã đọc chưa
    private long relatedId;        // ID liên quan (applicationId hoặc jobId)
    private Timestamp createdAt;   // Thời điểm tạo

    public Notification() {}

    // Constructor tiện dùng khi tạo nhanh
    public Notification(long userId, String title, String message, String type, long relatedId) {
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.type = type;
        this.relatedId = relatedId;
        this.isRead = false;
    }

    public long getNotificationId() { return notificationId; }
    public void setNotificationId(long notificationId) { this.notificationId = notificationId; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { this.isRead = read; }

    public long getRelatedId() { return relatedId; }
    public void setRelatedId(long relatedId) { this.relatedId = relatedId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
