package model;

import java.sql.Timestamp;

public class Interview {
    private long interviewId;
    private long applicationId;
    private long interviewTypeId;       // ID loại phỏng vấn VD: 1 (Online), 2 (Offline)
    private Long scheduledByUserId;     // ID Người lên lịch (HR)
    private Long interviewerUserId;     // ID Người phỏng vấn chính (nếu có)
    private Timestamp startAt;
    private Timestamp endAt;
    private String meetingLink;
    private String locationText;
    private String status;              // SCHEDULED, CANCELLED, COMPLETED, NO_SHOW
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Interview() {}

    public long getInterviewId() { return interviewId; }
    public void setInterviewId(long interviewId) { this.interviewId = interviewId; }

    public long getApplicationId() { return applicationId; }
    public void setApplicationId(long applicationId) { this.applicationId = applicationId; }

    public long getInterviewTypeId() { return interviewTypeId; }
    public void setInterviewTypeId(long interviewTypeId) { this.interviewTypeId = interviewTypeId; }

    public Long getScheduledByUserId() { return scheduledByUserId; }
    public void setScheduledByUserId(Long scheduledByUserId) { this.scheduledByUserId = scheduledByUserId; }

    public Long getInterviewerUserId() { return interviewerUserId; }
    public void setInterviewerUserId(Long interviewerUserId) { this.interviewerUserId = interviewerUserId; }

    public Timestamp getStartAt() { return startAt; }
    public void setStartAt(Timestamp startAt) { this.startAt = startAt; }

    public Timestamp getEndAt() { return endAt; }
    public void setEndAt(Timestamp endAt) { this.endAt = endAt; }

    public String getMeetingLink() { return meetingLink; }
    public void setMeetingLink(String meetingLink) { this.meetingLink = meetingLink; }

    public String getLocationText() { return locationText; }
    public void setLocationText(String locationText) { this.locationText = locationText; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
