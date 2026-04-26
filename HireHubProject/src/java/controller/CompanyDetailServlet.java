package controller;

import dal.CompanyDAO;
import dal.LocationDAO;
import dal.RecruiterDAO;
import dal.DepartmentDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Company;
import model.Recruiter;
import model.Department;

@WebServlet(name = "CompanyDetailServlet", urlPatterns = {"/company/detail"})
public class CompanyDetailServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/error/404.jsp");
            return;
        }

        try {
            long companyId = Long.parseLong(idRaw);

            CompanyDAO companyDAO = new CompanyDAO();
            LocationDAO locationDAO = new LocationDAO();
            RecruiterDAO recruiterDAO = new RecruiterDAO();
            DepartmentDAO departmentDAO = new DepartmentDAO();

            Company company = companyDAO.getCompanyById(companyId);

            if (company == null) {
                response.sendRedirect(request.getContextPath() + "/error/404.jsp");
                return;
            }

            String locationName = "";
            if (company.getLocationId() != null) {
                locationName = locationDAO.getLocationNameById(company.getLocationId());
            }

            // --- Recruiter Pagination & Filtering ---
            String recKeyword = nvl(request.getParameter("recKeyword"));
            String recJobTitle = nvl(request.getParameter("recJobTitle"), "All");
            String recStatus = nvl(request.getParameter("recStatus"), "All");
            int recPage = parsePage(request.getParameter("recPage"));

            int recTotalItems = recruiterDAO.countFilteredByCompanyId(companyId, recKeyword, recJobTitle, recStatus);
            int recTotalPages = Math.max(1, (int) Math.ceil((double) recTotalItems / PAGE_SIZE));
            recPage = Math.min(recPage, recTotalPages);

            List<Recruiter> recruiters = recruiterDAO.getFilteredByCompanyId(companyId, recKeyword, recJobTitle, recStatus, recPage, PAGE_SIZE);
            List<String> jobTitlesList = recruiterDAO.getDistinctJobTitlesByCompanyId(companyId);

            // --- Department Pagination & Filtering ---
            String deptKeyword = nvl(request.getParameter("deptKeyword"));
            String deptStatus = nvl(request.getParameter("deptStatus"), "All");
            int deptPage = parsePage(request.getParameter("deptPage"));

            int deptTotalItems = departmentDAO.countFilteredByCompanyId(companyId, deptKeyword, deptStatus);
            int deptTotalPages = Math.max(1, (int) Math.ceil((double) deptTotalItems / PAGE_SIZE));
            deptPage = Math.min(deptPage, deptTotalPages);

            List<Department> departments = departmentDAO.getFilteredByCompanyId(companyId, deptKeyword, deptStatus, deptPage, PAGE_SIZE);

            // Set attributes
            request.setAttribute("company", company);
            request.setAttribute("locationName", locationName);
            
            // Recruiter attributes
            request.setAttribute("recruiters", recruiters);
            request.setAttribute("recKeyword", recKeyword);
            request.setAttribute("recJobTitle", recJobTitle);
            request.setAttribute("recStatus", recStatus);
            request.setAttribute("recPage", recPage);
            request.setAttribute("recTotalPages", recTotalPages);
            request.setAttribute("recTotalItems", recTotalItems);
            request.setAttribute("jobTitlesList", jobTitlesList);
            request.setAttribute("recPageNums", buildPageNums(recPage, recTotalPages));

            // Department attributes
            request.setAttribute("departments", departments);
            request.setAttribute("deptKeyword", deptKeyword);
            request.setAttribute("deptStatus", deptStatus);
            request.setAttribute("deptPage", deptPage);
            request.setAttribute("deptTotalPages", deptTotalPages);
            request.setAttribute("deptTotalItems", deptTotalItems);
            request.setAttribute("deptPageNums", buildPageNums(deptPage, deptTotalPages));

            request.getRequestDispatcher("/company/company-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/error/404.jsp");
        }
    }

    private static String nvl(String s) {
        return s == null ? "" : s.trim();
    }

    private static String nvl(String s, String def) {
        return (s == null || s.trim().isEmpty()) ? def : s.trim();
    }

    private static int parsePage(String s) {
        try { int p = Integer.parseInt(s); return p < 1 ? 1 : p; }
        catch (Exception e) { return 1; }
    }

    static List<Integer> buildPageNums(int current, int total) {
        List<Integer> nums = new ArrayList<>();
        if (total <= 1) return nums;
        if (total <= 7) {
            for (int i = 1; i <= total; i++) nums.add(i);
            return nums;
        }
        nums.add(1);
        int start = Math.max(2, current - 2);
        int end   = Math.min(total - 1, current + 2);
        if (start > 2)       nums.add(-1);
        for (int i = start; i <= end; i++) nums.add(i);
        if (end < total - 1) nums.add(-1);
        nums.add(total);
        return nums;
    }
}