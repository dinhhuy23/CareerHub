package model;

public class Location {
    private long locationId;
    private String locationName;

    public Location() {
    }

    public Location(long locationId, String locationName) {
        this.locationId = locationId;
        this.locationName = locationName;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }
}