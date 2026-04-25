package model;

import java.sql.Timestamp;

public class Department {
    private long departmentId;
    private String departmentName;
    private String description;
    private boolean isActive;
    private Timestamp createdAt;

    // Extra fields (JOIN)
    private long companyId;
    private String companyName;
    
    // New fields
    private String managerName;
    private String contactEmail;
    private String phoneNumber;
    private String location;

    public Department() {}

    public Department(long departmentId, String departmentName, String description, boolean isActive, Timestamp createdAt) {
        this.departmentId = departmentId;
        this.departmentName = departmentName;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public long getDepartmentId() { return departmentId; }
    public void setDepartmentId(long departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public long getCompanyId() { return companyId; }
    public void setCompanyId(long companyId) { this.companyId = companyId; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    
    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}
