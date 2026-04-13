package model;

import java.sql.Timestamp;

public class UserRole {
    private long userRoleId;
    private long userId;
    private long roleId;
    private Timestamp assignedAt;
    private Long assignedByUserId;
    private boolean isActive;

    public UserRole() {
    }

    public UserRole(long userRoleId, long userId, long roleId, Timestamp assignedAt,
                    Long assignedByUserId, boolean isActive) {
        this.userRoleId = userRoleId;
        this.userId = userId;
        this.roleId = roleId;
        this.assignedAt = assignedAt;
        this.assignedByUserId = assignedByUserId;
        this.isActive = isActive;
    }

    // Getters and Setters
    public long getUserRoleId() { return userRoleId; }
    public void setUserRoleId(long userRoleId) { this.userRoleId = userRoleId; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public long getRoleId() { return roleId; }
    public void setRoleId(long roleId) { this.roleId = roleId; }

    public Timestamp getAssignedAt() { return assignedAt; }
    public void setAssignedAt(Timestamp assignedAt) { this.assignedAt = assignedAt; }

    public Long getAssignedByUserId() { return assignedByUserId; }
    public void setAssignedByUserId(Long assignedByUserId) { this.assignedByUserId = assignedByUserId; }

    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }
}
