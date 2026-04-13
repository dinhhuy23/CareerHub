package model;

import java.sql.Timestamp;

public class SavedJob {
    private long savedJobId;
    private long candidateId;
    private long jobId;
    private Timestamp savedAt;
    
    // Display fields
    private Job job;

    public long getSavedJobId() { return savedJobId; }
    public void setSavedJobId(long savedJobId) { this.savedJobId = savedJobId; }

    public long getCandidateId() { return candidateId; }
    public void setCandidateId(long candidateId) { this.candidateId = candidateId; }

    public long getJobId() { return jobId; }
    public void setJobId(long jobId) { this.jobId = jobId; }

    public Timestamp getSavedAt() { return savedAt; }
    public void setSavedAt(Timestamp savedAt) { this.savedAt = savedAt; }

    public Job getJob() { return job; }
    public void setJob(Job job) { this.job = job; }
}
