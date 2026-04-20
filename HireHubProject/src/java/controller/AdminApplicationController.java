package controller;

import dal.ApplicationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Application;
import java.io.IOException;
import java.util.List;

/**
 * Controller for Admin to manage all job applications in the system.
 */
@WebServlet(name = "AdminApplicationController", urlPatterns = {"/admin/applications"})
public class AdminApplicationController extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Fetch all applications from the database
        List<Application> allApplications = applicationDAO.findAll();
        
        // Put list into request attribute
        request.setAttribute("list", allApplications);
        
        // Forward to the admin application view
        request.getRequestDispatcher("/WEB-INF/views/admin-application-list.jsp").forward(request, response);
    }
}
