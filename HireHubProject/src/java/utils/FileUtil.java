package utils;

import java.io.File;

public class FileUtil {
    // Constant path for uploads outside the build directory to ensure persistence
    // On Windows, this creates a folder at C:\HireHub_Data
    public static final String UPLOAD_BASE_DIR = "C:" + File.separator + "HireHub_Data" + File.separator + "uploads";

    public static String getUploadPath(String subFolder) {
        String path = UPLOAD_BASE_DIR + File.separator + subFolder;
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return path;
    }
}
