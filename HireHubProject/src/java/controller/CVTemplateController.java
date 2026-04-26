package controller;

import dal.DBContext;
import dal.CVTemplateDAO;
import model.CVTemplate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet(name = "CVTemplateController", urlPatterns = {"/user/cv_template"})
public class CVTemplateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. GET PARAM
        String tag = request.getParameter("tag");

        if (tag == null || tag.trim().isEmpty()) {
            tag = "all";
        }

        tag = tag.toLowerCase().trim();

        Connection conn = null;

        try {
            // 2. GET CONNECTION
            DBContext dbContext = new DBContext();
            conn = dbContext.getConnection();

            // 3. DAO
            CVTemplateDAO dao = new CVTemplateDAO(conn);

            List<CVTemplate> cvList = dao.filterByTag(tag);

            // 4. SET DATA
            request.setAttribute("cvList", cvList);
            request.setAttribute("currentTag", tag);

            // 5. FORWARD
            request.getRequestDispatcher("/WEB-INF/views/cv_template.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);

        } finally {
            DBContext.closeConnection(conn);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/user/cv_template");
    }
}