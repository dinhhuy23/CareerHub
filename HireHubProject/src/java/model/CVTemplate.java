package model;

import java.util.List;

public class CVTemplate {

    private int id;
    private String name;
    private String image;
    private List<String> tags; 
    
    // Bổ sung thêm trường này để biết mẫu này dùng file giao diện nào
    private String baseFileJsp; 
    private boolean isActive;

    public CVTemplate() {
    }

    public CVTemplate(int id, String name, String image, List<String> tags, String baseFileJsp, boolean isActive) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.tags = tags;
        this.baseFileJsp = baseFileJsp;
        this.isActive = isActive;
    }

    // Các Getter và Setter hiện tại giữ nguyên
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }

    // Bổ sung Getter/Setter cho các trường mới
    public String getBaseFileJsp() {
        return baseFileJsp;
    }

    public void setBaseFileJsp(String baseFileJsp) {
        this.baseFileJsp = baseFileJsp;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}