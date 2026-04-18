package model;

import java.sql.Timestamp;

public class Application {
    private long applicationId; // ID duy nhất của đơn ứng tuyển
    private long jobId;         // ID công việc ứng tuyển
    private long candidateId;   // ID ứng viên (User)
    private Long resumeId;      // ID file CV trong bảng CandidateResumes
    private String cvUrl;       // Đường dẫn tới file hoặc link CV
    private String coverLetter; // Thư giới thiệu của ứng viên
    private String status;      // Trạng thái: PENDING (Chờ), REVIEWING (Đang xem), INTERVIEWING (Phỏng vấn), OFFERED (Trúng tuyển), REJECTED (Từ chối)
    private Timestamp appliedAt; // Thời điểm ứng tuyển
    private Timestamp updatedAt; // Thời điểm cập nhật cuối cùng

    // Các trường dữ liệu bổ sung từ việc JOIN bảng (không có trong table Applications)
    private String jobTitle;        // Tiêu đề công việc
    private String candidateName;   // Tên ứng viên
    private String candidateEmail;  // Email ứng viên
    private String candidateAvatar; // Ảnh đại diện ứng viên
    private String companyName;     // Tên công ty
    private String hrNote;          // Ghi chú nội bộ của HR

    public Application() {}

    public long getApplicationId() { return applicationId; }
    public void setApplicationId(long applicationId) { this.applicationId = applicationId; }

    public long getJobId() { return jobId; }
    public void setJobId(long jobId) { this.jobId = jobId; }

    public long getCandidateId() { return candidateId; }
    public void setCandidateId(long candidateId) { this.candidateId = candidateId; }

    public Long getResumeId() { return resumeId; }
    public void setResumeId(Long resumeId) { this.resumeId = resumeId; }

    public String getCvUrl() { return cvUrl; }
    public void setCvUrl(String cvUrl) { this.cvUrl = cvUrl; }

    public String getCoverLetter() { return coverLetter; }
    public void setCoverLetter(String coverLetter) { this.coverLetter = coverLetter; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt) { this.appliedAt = appliedAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getJobTitle() { return jobTitle; }
    public void setJobTitle(String jobTitle) { this.jobTitle = jobTitle; }

    public String getCandidateName() { return candidateName; }
    public void setCandidateName(String candidateName) { this.candidateName = candidateName; }

    public String getCandidateEmail() { return candidateEmail; }
    public void setCandidateEmail(String candidateEmail) { this.candidateEmail = candidateEmail; }

    public String getCandidateAvatar() { return candidateAvatar; }
    public void setCandidateAvatar(String candidateAvatar) { this.candidateAvatar = candidateAvatar; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getHrNote() { return hrNote; }
    public void setHrNote(String hrNote) { this.hrNote = hrNote; }
}

