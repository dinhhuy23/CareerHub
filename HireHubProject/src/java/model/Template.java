/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class Template {
    private int templateId;
    private String name;
    private String imageThumbnail;
    private String baseFileJsp;
    private int isActive;

    public Template() {
    }

    public Template(int templateId, String name, String imageThumbnail, String baseFileJsp, int isActive) {
        this.templateId = templateId;
        this.name = name;
        this.imageThumbnail = imageThumbnail;
        this.baseFileJsp = baseFileJsp;
        this.isActive = isActive;
    }

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageThumbnail() {
        return imageThumbnail;
    }

    public void setImageThumbnail(String imageThumbnail) {
        this.imageThumbnail = imageThumbnail;
    }

    public String getBaseFileJsp() {
        return baseFileJsp;
    }

    public void setBaseFileJsp(String baseFileJsp) {
        this.baseFileJsp = baseFileJsp;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }
    
    
}
