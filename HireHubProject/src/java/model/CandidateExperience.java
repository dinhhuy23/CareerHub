package model;

import java.sql.Date;

public class CandidateExperience {
    private int experienceId;
    private int candidateId;
    private String companyName;
    private String positionTitle;
    private Date startDate;
    private Date endDate;
    private boolean isCurrentJob;
    private String description;

    // Getters and Setters
    public int getExperienceId() { return experienceId; }
    public void setExperienceId(int experienceId) { this.experienceId = experienceId; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getPositionTitle() { return positionTitle; }
    public void setPositionTitle(String positionTitle) { this.positionTitle = positionTitle; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public boolean isIsCurrentJob() { return isCurrentJob; }
    public void setIsCurrentJob(boolean isCurrentJob) { this.isCurrentJob = isCurrentJob; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}