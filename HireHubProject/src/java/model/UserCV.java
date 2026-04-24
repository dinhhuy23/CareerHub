/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
public class UserCV {

    private int userCVId;
    private int userId;
    private int templateId;
    private String cvTitle;

    private String fullName;
    private String targetRole;
    private String avatarUrl;
    private java.sql.Date birthDate;
    private String address;
    private String phone;
    private String email;
    private String gender;

    private String summary;
    private String educationRaw;
    private String experienceRaw;

    private int isUpload;
    private java.sql.Timestamp createdAt;
    private boolean isAccepted;
    private java.sql.Timestamp updatedAt;
    private int isSearchable;

    public UserCV() {
    }

    public UserCV(int userCVId, int userId, int templateId, String cvTitle, String fullName, String targetRole, String avatarUrl, Date birthDate, String address, String phone, String email, String gender, String summary, String educationRaw, String experienceRaw, int isUpload, Timestamp createdAt, boolean isAccepted, Timestamp updatedAt, int isSearchable) {
        this.userCVId = userCVId;
        this.userId = userId;
        this.templateId = templateId;
        this.cvTitle = cvTitle;
        this.fullName = fullName;
        this.targetRole = targetRole;
        this.avatarUrl = avatarUrl;
        this.birthDate = birthDate;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.gender = gender;
        this.summary = summary;
        this.educationRaw = educationRaw;
        this.experienceRaw = experienceRaw;
        this.isUpload = isUpload;
        this.createdAt = createdAt;
        this.isAccepted = isAccepted;
        this.updatedAt = updatedAt;
        this.isSearchable = isSearchable;
    }

    public int getUserCVId() {
        return userCVId;
    }

    public void setUserCVId(int userCVId) {
        this.userCVId = userCVId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public String getCvTitle() {
        return cvTitle;
    }

    public void setCvTitle(String cvTitle) {
        this.cvTitle = cvTitle;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getTargetRole() {
        return targetRole;
    }

    public void setTargetRole(String targetRole) {
        this.targetRole = targetRole;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getEducationRaw() {
        return educationRaw;
    }

    public void setEducationRaw(String educationRaw) {
        this.educationRaw = educationRaw;
    }

    public String getExperienceRaw() {
        return experienceRaw;
    }

    public void setExperienceRaw(String experienceRaw) {
        this.experienceRaw = experienceRaw;
    }

    public int getIsUpload() {
        return isUpload;
    }

    public void setIsUpload(int isUpload) {
        this.isUpload = isUpload;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isIsAccepted() {
        return isAccepted;
    }

    public void setIsAccepted(boolean isAccepted) {
        this.isAccepted = isAccepted;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getIsSearchable() {
        return isSearchable;
    }

    public void setIsSearchable(int isSearchable) {
        this.isSearchable = isSearchable;
    }
}
