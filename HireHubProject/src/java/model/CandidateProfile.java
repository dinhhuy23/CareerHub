package model;

import java.util.List;

public class CandidateProfile {
    private long candidateId;
    private long userId;
    private String fullName; // Lấy từ bảng Users thông qua JOIN
    private String phoneNumber; // Lấy từ bảng Users thông qua JOIN
    private String email; // Lấy từ bảng Users thông qua JOIN
    
    private String headline;
    private String summary;
    private String currentLocationName; // Lấy từ bảng Locations thông qua JOIN
    private String linkedinUrl;
    private String portfolioUrl;
    private String githubUrl;
    private int yearsOfExperience;
    private String employmentStatus;
    private String highestDegree;

    // Danh sách đối tượng cụ thể để quản lý thông tin chi tiết
    private List<CandidateEducation> educations;
    private List<String> experiences; 

    // Constructor mặc định
    public CandidateProfile() {
    }

    // Getters and Setters
    public long getCandidateId() { return candidateId; }
    public void setCandidateId(long candidateId) { this.candidateId = candidateId; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    // Đã cập nhật Getter/Setter cho Headline
    public String getHeadline() { return headline; }
    public void setHeadline(String headline) { this.headline = headline; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public String getCurrentLocationName() { return currentLocationName; }
    public void setCurrentLocationName(String currentLocationName) { this.currentLocationName = currentLocationName; }

    public String getLinkedinUrl() { return linkedinUrl; }
    public void setLinkedinUrl(String linkedinUrl) { this.linkedinUrl = linkedinUrl; }

    public String getGithubUrl() { return githubUrl; }
    public void setGithubUrl(String githubUrl) { this.githubUrl = githubUrl; }

    public String getPortfolioUrl() { return portfolioUrl; }
    public void setPortfolioUrl(String portfolioUrl) { this.portfolioUrl = portfolioUrl; }

    public int getYearsOfExperience() { return yearsOfExperience; }
    public void setYearsOfExperience(int yearsOfExperience) { this.yearsOfExperience = yearsOfExperience; }

    public String getEmploymentStatus() { return employmentStatus; }
    public void setEmploymentStatus(String employmentStatus) { this.employmentStatus = employmentStatus; }

    public String getHighestDegree() { return highestDegree; }
    public void setHighestDegree(String highestDegree) { this.highestDegree = highestDegree; }

    public List<CandidateEducation> getEducations() { return educations; }
    public void setEducations(List<CandidateEducation> educations) { this.educations = educations; }

    public List<String> getExperiences() { return experiences; }
    public void setExperiences(List<String> experiences) { this.experiences = experiences; }
}