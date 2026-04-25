package model;

import java.util.List;

public class InterviewQuestion {
    private int id;
    private String category;
    private String categoryLabel;
    private String level;
    private String levelLabel;
    private String question;
    private String answer;
    private List<String> tags;

    public InterviewQuestion() {}

    public InterviewQuestion(int id, String category, String categoryLabel,
                              String level, String levelLabel,
                              String question, String answer, List<String> tags) {
        this.id = id;
        this.category = category;
        this.categoryLabel = categoryLabel;
        this.level = level;
        this.levelLabel = levelLabel;
        this.question = question;
        this.answer = answer;
        this.tags = tags;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getCategoryLabel() { return categoryLabel; }
    public void setCategoryLabel(String categoryLabel) { this.categoryLabel = categoryLabel; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public String getLevelLabel() { return levelLabel; }
    public void setLevelLabel(String levelLabel) { this.levelLabel = levelLabel; }
    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }
    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }
    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }
}
