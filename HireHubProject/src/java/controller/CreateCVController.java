package controller;

import dal.CVTemplateDAO;
import dal.UserDAO;
import dal.CandidateProfileDAO; // Giả sử bạn đã tạo
import dal.CandidateEducationDAO; // Giả sử bạn đã tạo
import dal.CandidateExperienceDAO;
import model.CVTemplate;
import model.User;
import model.CandidateProfile;
import model.CandidateEducation;
import dal.DBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import model.CandidateExperience;

@WebServlet(name = "CreateCVController", urlPatterns = {"/user/create_cv"})
public class CreateCVController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String templateIdRaw = request.getParameter("template");
        String action = request.getParameter("action");
        String contextPath = request.getContextPath();

        if (templateIdRaw == null || templateIdRaw.isEmpty()) {
            response.sendRedirect(contextPath + "/user/cv_template");
            return;
        }

        Connection conn = null;
        try {
            int templateId = Integer.parseInt(templateIdRaw);
            conn = new DBContext().getConnection();

            CVTemplateDAO templateDao = new CVTemplateDAO(conn);
            CVTemplate selectedTemplate = templateDao.getById(templateId);

            if (selectedTemplate == null) {
                response.sendRedirect(contextPath + "/user/cv_template");
                return;
            }
            request.setAttribute("selectedTemplate", selectedTemplate);

            // XỬ LÝ KHI NGƯỜI DÙNG VÀO FORM NHẬP LIỆU (action=form)
            if ("form".equals(action)) {
                HttpSession session = request.getSession(false);
                Object userIdObj = (session != null) ? session.getAttribute("userId") : null;

                if (userIdObj != null) {
                    long userId = Long.parseLong(userIdObj.toString());

                    // 1. Lấy thông tin cơ bản từ bảng Users (Họ tên, Email, Phone)
                    UserDAO userDAO = new UserDAO();
                    User userBase = userDAO.findById(userId);

                    // 2. Lấy thông tin chuyên sâu từ CandidateProfiles (Headline, Summary, Location, URLs)
                    CandidateProfileDAO profileDAO = new CandidateProfileDAO();
                    CandidateProfile profile = profileDAO.getByUserId(userId);

                    if (userBase != null) {
                        // Nếu chưa có profile, ta vẫn cho tạo CV nhưng các trường profile sẽ để trống
                        request.setAttribute("userBase", userBase);

                        if (profile != null) {
                            // 3. Lấy danh sách học vấn từ CandidateEducations
                            CandidateEducationDAO eduDAO = new CandidateEducationDAO();
                            List<CandidateEducation> listEdu = eduDAO.getByCandidateId(profile.getCandidateId());

                            // MỚI: Lấy danh sách kinh nghiệm
                            CandidateExperienceDAO expDAO = new CandidateExperienceDAO();
                            List<CandidateExperience> listExp = expDAO.getByCandidateId(profile.getCandidateId());

                            // Đẩy các thông tin vào request
                            request.setAttribute("profile", profile);
                            request.setAttribute("listEdu", listEdu);
                            request.setAttribute("listExp", listExp);
                        }

                        request.getRequestDispatcher("/WEB-INF/views/cv_form.jsp").forward(request, response);
                        return;
                    }
                }
                response.sendRedirect(contextPath + "/login");
                return;
            }

            // MẶC ĐỊNH: Trang xem trước mẫu
            request.getRequestDispatcher("/WEB-INF/views/create_cv.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(contextPath + "/user/cv_template");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(contextPath + "/user/dashboard");
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
