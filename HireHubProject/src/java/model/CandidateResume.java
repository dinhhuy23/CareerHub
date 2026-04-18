package model;

import java.sql.Timestamp;

public class CandidateResume {
    private long resumeId;
    private long candidateId;
    private String resumeTitle;
    private String fileUrl;
    private String fileType;
    private Integer fileSizeKB;
    private int versionNo;
    private boolean isDefault;
    private Timestamp uploadedAt;

    public CandidateResume() {}

    public long getResumeId() { return resumeId; }
    public void setResumeId(long resumeId) { this.resumeId = resumeId; }

    public long getCandidateId() { return candidateId; }
    public void setCandidateId(long candidateId) { this.candidateId = candidateId; }

    public String getResumeTitle() { return resumeTitle; }
    public void setResumeTitle(String resumeTitle) { this.resumeTitle = resumeTitle; }

    public String getFileUrl() { return fileUrl; }
    public void setFileUrl(String fileUrl) { this.fileUrl = fileUrl; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public Integer getFileSizeKB() { return fileSizeKB; }
    public void setFileSizeKB(Integer fileSizeKB) { this.fileSizeKB = fileSizeKB; }

    public int getVersionNo() { return versionNo; }
    public void setVersionNo(int versionNo) { this.versionNo = versionNo; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}
