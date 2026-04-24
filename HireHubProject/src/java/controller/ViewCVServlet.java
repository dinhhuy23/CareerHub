package controller;

import dal.CVTemplateDAO;
import dal.DBContext;
import dal.UserCVDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.UserCV;
import model.CVTemplate;

@WebServlet(name = "ViewCVServlet", urlPatterns = {"/user/cv/view"})
public class ViewCVServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/cv/manage_cv?msg=err");
            return;
        }

        try {
            int cvId = Integer.parseInt(idStr);
            UserCVDAO cvDAO = new UserCVDAO();
            UserCV cv = cvDAO.getCVById(cvId);

            if (cv != null) {
                // 1. Kiểm tra quyền sở hữu (Security Check)
                HttpSession session = request.getSession();
                Object userIdObj = session.getAttribute("userId");
                if (userIdObj == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                
                int sessionUserId = Integer.parseInt(userIdObj.toString());
                
                // Chặn trường hợp user này xem CV của user khác bằng cách thay đổi ID trên URL
                if (cv.getUserId() != sessionUserId) {
                    response.sendRedirect(request.getContextPath() + "/user/cv/manage_cv?msg=denied");
                    return;
                }

                // 2. PHÂN LUỒNG XỬ LÝ
                if (cv.getIsUpload() == 1) {
                    // TRƯỜNG HỢP 1: CV LÀ FILE PDF ĐÃ UPLOAD
                    // Lưu ý: cv.getAvatarUrl() lưu là "uploads/cv_files/ten_file.pdf"
                    // Theo context.xml: webAppMount="/uploads" trỏ vào "D:/HireHub_Uploads"
                    
                    String filePath = cv.getAvatarUrl(); 

                    // Nếu database lưu "uploads/cv_files/..." thì ta gọi trực tiếp qua contextPath
                    // Trình duyệt sẽ nhận diện file PDF và mở trình xem PDF mặc định
                    response.sendRedirect(request.getContextPath() + "/" + filePath);

                } else {
                    // TRƯỜNG HỢP 2: CV TẠO TỪ WEB BUILDER
                    CVTemplateDAO templateDAO = new CVTemplateDAO(new DBContext().getConnection());
                    CVTemplate selectedTemplate = templateDAO.getTemplateById(cv.getTemplateId());

                    // Nếu không có template, dùng template mặc định
                    String targetJsp = (selectedTemplate != null) ? selectedTemplate.getBaseFileJsp() : "template_1.jsp";

                    request.setAttribute("cvData", cv);
                    // Giả sử các file giao diện template nằm trong /WEB-INF/views/
                    request.getRequestDispatcher("/WEB-INF/views/" + targetJsp).forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/user/cv/manage_cv?msg=notfound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/cv/manage_cv?msg=error");
        }
    }
}