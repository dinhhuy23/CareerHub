package controller;

import dal.CompanyDAO;
import dal.LocationDAO;
import dal.RecruiterDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Company;

@WebServlet(name = "CompanyDetailServlet", urlPatterns = {"/company/detail"})
public class CompanyDetailServlet extends HttpServlet {

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

            Company company = companyDAO.getCompanyById(companyId);

            if (company == null) {
                response.sendRedirect(request.getContextPath() + "/error/404.jsp");
                return;
            }

            String locationName = "";
            if (company.getLocationId() != null) {
                locationName = locationDAO.getLocationNameById(company.getLocationId());
            }

            request.setAttribute("company", company);
            request.setAttribute("recruiters", recruiterDAO.getRecruitersByCompanyId(companyId));
            request.setAttribute("locationName", locationName);

            request.getRequestDispatcher("/company/company-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/error/404.jsp");
        }
    }
}