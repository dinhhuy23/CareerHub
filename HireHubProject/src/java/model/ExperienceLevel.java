package model;

public class ExperienceLevel {
    private long experienceLevelId;
    private String levelCode;
    private String levelName;
    private int sortOrder;
    private boolean isActive;

    public long getExperienceLevelId() { return experienceLevelId; }
    public void setExperienceLevelId(long experienceLevelId) { this.experienceLevelId = experienceLevelId; }

    public String getLevelCode() { return levelCode; }
    public void setLevelCode(String levelCode) { this.levelCode = levelCode; }

    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }

    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
}
