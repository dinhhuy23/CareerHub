package controller;

import dal.JobDAO;
import dal.JobCategoryDAO;
import dal.LocationDAO;
import dal.EmploymentTypeDAO;
import dal.ExperienceLevelDAO;
import model.Job;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "JobListingController", urlPatterns = {"/jobs"})
public class JobListingController extends HttpServlet {

    private final JobDAO jobDAO = new JobDAO();
    private final JobCategoryDAO categoryDAO = new JobCategoryDAO();
    private final LocationDAO locationDAO = new LocationDAO();
    private final EmploymentTypeDAO typeDAO = new EmploymentTypeDAO();
    private final ExperienceLevelDAO levelDAO = new ExperienceLevelDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Pass filter lists to JSP
        request.setAttribute("categories", categoryDAO.getAllActive());
        request.setAttribute("locations", locationDAO.getAllActive());
        request.setAttribute("employmentTypes", typeDAO.getAllActive());
        request.setAttribute("experienceLevels", levelDAO.getAllActive());

        // Parse search params
        String keyword = request.getParameter("keyword");
        Long categoryId = parseLongOrNull(request.getParameter("category"));
        Long locationId = parseLongOrNull(request.getParameter("location"));
        Long typeId = parseLongOrNull(request.getParameter("type"));
        Long levelId = parseLongOrNull(request.getParameter("level"));

        // Pagination
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException e) {}
            if (page < 1) page = 1;
        }

        int offset = (page - 1) * pageSize;

        List<Job> jobs = jobDAO.searchAndFilter(keyword, categoryId, locationId, typeId, levelId, offset, pageSize);
        int totalJobs = jobDAO.countSearchAndFilter(keyword, categoryId, locationId, typeId, levelId);
        int totalPages = (int) Math.ceil((double) totalJobs / pageSize);

        request.setAttribute("jobs", jobs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalJobs", totalJobs);

        // Retain search values
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedLocation", locationId);
        request.setAttribute("selectedType", typeId);
        request.setAttribute("selectedLevel", levelId);

        request.getRequestDispatcher("/WEB-INF/views/jobs.jsp").forward(request, response);
    }

    private Long parseLongOrNull(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try { return Long.parseLong(val); } catch (NumberFormatException e) { return null; }
    }
}
