package model;

import java.sql.Date;

public class CandidateEducation {
    private int educationId;
    private int candidateId;
    private String schoolName;
    private String degree;
    private String major;
    private Date startDate;
    private Date endDate;
    private double gpa;
    private String description;

    // Getters and Setters
    public int getEducationId() { return educationId; }
    public void setEducationId(int educationId) { this.educationId = educationId; }
    public String getSchoolName() { return schoolName; }
    public void setSchoolName(String schoolName) { this.schoolName = schoolName; }
    public String getDegree() { return degree; }
    public void setDegree(String degree) { this.degree = degree; }
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public double getGpa() { return gpa; }
    public void setGpa(double gpa) { this.gpa = gpa; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}