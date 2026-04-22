package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

/**
 * FileServlet to serve uploaded files (CVs, images, etc.) from the server's file system.
 * This ensures that files are always accessible even if Tomcat doesn't automatically 
 * recognize the new 'uploads' directory.
 */
@WebServlet(name = "FileServlet", urlPatterns = {"/uploads/*"})
public class FileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 0. Security check: User must be logged in to view any files in /uploads/
        // (AuthenticationFilter should have set these attributes)
        Object userId = request.getAttribute("userId");
        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please log in to access this file.");
            return;
        }
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 2. Resolve the real path on the disk
        // We use the persistent storage directory outside the build folder
        String uploadsRoot = utils.FileUtil.UPLOAD_BASE_DIR;
        String filePath = uploadsRoot + File.separator + URLDecoder.decode(pathInfo, StandardCharsets.UTF_8.name());
        
        File file = new File(filePath);

        // 3. Basic Security Check: Ensure the file is not outside the uploads directory
        if (!file.exists() || !file.getCanonicalPath().startsWith(new File(uploadsRoot).getCanonicalPath())) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 4. Set correct Content-Type (e.g. application/pdf)
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLength((int) file.length());

        // 5. Transfer file content to response
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
