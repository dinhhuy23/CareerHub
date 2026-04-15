package model;

public class Location {
    private long locationId;
    private String locationName;
    private String locationType;
    private Long parentLocationId;
    private String postalCode;
    private boolean isActive;

    public long getLocationId() { return locationId; }
    public void setLocationId(long locationId) { this.locationId = locationId; }

    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }

    public String getLocationType() { return locationType; }
    public void setLocationType(String locationType) { this.locationType = locationType; }

    public Long getParentLocationId() { return parentLocationId; }
    public void setParentLocationId(Long parentLocationId) { this.parentLocationId = parentLocationId; }

    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
}
