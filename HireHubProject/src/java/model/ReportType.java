package model;

public class ReportType {

    private long reportTypeId;
    private String reportCode;
    private String reportName;
    private String description;
    private boolean isActive;

    public ReportType() {
    }

    public ReportType(long reportTypeId, String reportCode, String reportName, String description, boolean isActive) {
        this.reportTypeId = reportTypeId;
        this.reportCode = reportCode;
        this.reportName = reportName;
        this.description = description;
        this.isActive = isActive;
    }

    public long getReportTypeId() {
        return reportTypeId;
    }

    public void setReportTypeId(long reportTypeId) {
        this.reportTypeId = reportTypeId;
    }

    public String getReportCode() {
        return reportCode;
    }

    public void setReportCode(String reportCode) {
        this.reportCode = reportCode;
    }

    public String getReportName() {
        return reportName;
    }

    public void setReportName(String reportName) {
        this.reportName = reportName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}
