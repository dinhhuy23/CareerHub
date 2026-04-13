package model;

public class EmploymentType {
    private long employmentTypeId;
    private String typeCode;
    private String typeName;
    private boolean isActive;

    public long getEmploymentTypeId() { return employmentTypeId; }
    public void setEmploymentTypeId(long employmentTypeId) { this.employmentTypeId = employmentTypeId; }

    public String getTypeCode() { return typeCode; }
    public void setTypeCode(String typeCode) { this.typeCode = typeCode; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
}
