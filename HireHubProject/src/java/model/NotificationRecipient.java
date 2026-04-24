package model;

import java.util.Date;

public class NotificationRecipient {

    private long notificationRecipientId;
    private long notificationId;
    private long userId;
    private boolean isRead;
    private Date readAt;
    private String deliveryStatus;
    private Date createdAt;

    // ===== Constructor =====
    public NotificationRecipient() {
    }

    public NotificationRecipient(long notificationRecipientId, long notificationId, long userId,
                                 boolean isRead, Date readAt, String deliveryStatus, Date createdAt) {
        this.notificationRecipientId = notificationRecipientId;
        this.notificationId = notificationId;
        this.userId = userId;
        this.isRead = isRead;
        this.readAt = readAt;
        this.deliveryStatus = deliveryStatus;
        this.createdAt = createdAt;
    }

    // ===== Getter & Setter =====
    public long getNotificationRecipientId() {
        return notificationRecipientId;
    }

    public void setNotificationRecipientId(long notificationRecipientId) {
        this.notificationRecipientId = notificationRecipientId;
    }

    public long getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(long notificationId) {
        this.notificationId = notificationId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public boolean isIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public Date getReadAt() {
        return readAt;
    }

    public void setReadAt(Date readAt) {
        this.readAt = readAt;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}