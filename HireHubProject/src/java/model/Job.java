package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Job {
    private long jobId;
    private Long companyId;
    private Long departmentId;
    private long postedByRecruiterId;
    private Long categoryId;
    private Long employmentTypeId;
    private Long experienceLevelId;
    
    private String title;
    private String jobCode;
    private String description;
    private String requirements;
    private String responsibilities;
    
    private Long locationId;
    private String addressDetail;
    
    private BigDecimal salaryMin;
    private BigDecimal salaryMax;
    private String currencyCode;
    private Integer vacancyCount;
    
    private Timestamp deadlineAt;
    private Timestamp publishedAt;
    private Timestamp closedAt;
    private String status; // 'DRAFT', 'PUBLISHED', 'CLOSED', 'DELETED'
    
    private int viewCount;
    private boolean isFeatured;
    
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Display fields from joins
    private String employerName;
    private String categoryName;
    private String locationName;
    private String employmentTypeName;
    private String experienceLevelName;
    private String companyName;

    public long getJobId() { return jobId; }
    public void setJobId(long jobId) { this.jobId = jobId; }
    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }
    public Long getDepartmentId() { return departmentId; }
    public void setDepartmentId(Long departmentId) { this.departmentId = departmentId; }
    public long getPostedByRecruiterId() { return postedByRecruiterId; }
    public void setPostedByRecruiterId(long postedByRecruiterId) { this.postedByRecruiterId = postedByRecruiterId; }
    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
    public Long getEmploymentTypeId() { return employmentTypeId; }
    public void setEmploymentTypeId(Long employmentTypeId) { this.employmentTypeId = employmentTypeId; }
    public Long getExperienceLevelId() { return experienceLevelId; }
    public void setExperienceLevelId(Long experienceLevelId) { this.experienceLevelId = experienceLevelId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getJobCode() { return jobCode; }
    public void setJobCode(String jobCode) { this.jobCode = jobCode; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }
    public String getResponsibilities() { return responsibilities; }
    public void setResponsibilities(String responsibilities) { this.responsibilities = responsibilities; }
    public Long getLocationId() { return locationId; }
    public void setLocationId(Long locationId) { this.locationId = locationId; }
    public String getAddressDetail() { return addressDetail; }
    public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }
    public BigDecimal getSalaryMin() { return salaryMin; }
    public void setSalaryMin(BigDecimal salaryMin) { this.salaryMin = salaryMin; }
    public BigDecimal getSalaryMax() { return salaryMax; }
    public void setSalaryMax(BigDecimal salaryMax) { this.salaryMax = salaryMax; }
    public String getCurrencyCode() { return currencyCode; }
    public void setCurrencyCode(String currencyCode) { this.currencyCode = currencyCode; }
    public Integer getVacancyCount() { return vacancyCount; }
    public void setVacancyCount(Integer vacancyCount) { this.vacancyCount = vacancyCount; }
    public Timestamp getDeadlineAt() { return deadlineAt; }
    public void setDeadlineAt(Timestamp deadlineAt) { this.deadlineAt = deadlineAt; }
    public Timestamp getPublishedAt() { return publishedAt; }
    public void setPublishedAt(Timestamp publishedAt) { this.publishedAt = publishedAt; }
    public Timestamp getClosedAt() { return closedAt; }
    public void setClosedAt(Timestamp closedAt) { this.closedAt = closedAt; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }
    public boolean isFeatured() { return isFeatured; }
    public void setFeatured(boolean isFeatured) { this.isFeatured = isFeatured; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getEmployerName() { return employerName; }
    public void setEmployerName(String employerName) { this.employerName = employerName; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }
    public String getEmploymentTypeName() { return employmentTypeName; }
    public void setEmploymentTypeName(String employmentTypeName) { this.employmentTypeName = employmentTypeName; }
    public String getExperienceLevelName() { return experienceLevelName; }
    public void setExperienceLevelName(String experienceLevelName) { this.experienceLevelName = experienceLevelName; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getFormattedSalary() {
        if (salaryMin == null || salaryMax == null) return "Thỏa thuận";
        long min = salaryMin.longValue();
        long max = salaryMax.longValue();
        
        String minStr = formatCurrency(min);
        String maxStr = formatCurrency(max);
        
        if (minStr.equals(maxStr)) return minStr;
        return minStr + " - " + maxStr;
    }
    
    private String formatCurrency(long amount) {
        if (amount >= 1000000) {
            long tr = amount / 1000000;
            long le = (amount % 1000000) / 100000;
            if (le > 0) return tr + "." + le + "tr";
            return tr + "tr";
        }
        if (amount >= 1000) {
            return (amount / 1000) + "k";
        }
        return amount + "";
    }
}
