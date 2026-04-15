/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;
import com.cloudinary.Cloudinary;
import java.util.HashMap;
import java.util.Map;
/**
 *
 * @author Admin
 */
public class CloudinaryConfig {

    public static Cloudinary getCloudinary() {
        Map<String, String> config = new HashMap<>();
        config.put("cloud_name", "your_cloud_name");
        config.put("api_key", "your_api_key");
        config.put("api_secret", "your_api_secret");

        return new Cloudinary(config);
    }
}
