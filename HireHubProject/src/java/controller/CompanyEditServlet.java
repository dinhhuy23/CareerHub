package controller;

import dal.CompanyDAO;
import dal.LocationDAO;
import java.io.IOException;
import java.time.Year;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Company;
import model.Location;

@WebServlet(name = "CompanyEditServlet", urlPatterns = {"/company/edit"})
public class CompanyEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/company/company-list.jsp");
            return;
        }

        try {
            long companyId = Long.parseLong(idRaw);

            CompanyDAO companyDAO = new CompanyDAO();
            LocationDAO locationDAO = new LocationDAO();

            Company company = companyDAO.getCompanyById(companyId);
            List<Location> locations = locationDAO.getAllActive();

            if (company == null) {
                response.sendRedirect(request.getContextPath() + "/company/company-list.jsp");
                return;
            }

            request.setAttribute("company", company);
            request.setAttribute("locations", locations);
            request.setAttribute("mode", "edit");

            request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/company/company-list.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String companyIdRaw = request.getParameter("companyId");
        String companyName = request.getParameter("companyName");
        String taxCode = request.getParameter("taxCode");
        String websiteUrl = request.getParameter("websiteUrl");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String logoUrl = request.getParameter("logoUrl");
        String description = request.getParameter("description");
        String foundedYearRaw = request.getParameter("foundedYear");
        String companySize = request.getParameter("companySize");
        String industry = request.getParameter("industry");
        String addressLine = request.getParameter("addressLine");
        String locationIdRaw = request.getParameter("locationId");
        String status = request.getParameter("status");

        String error = null;
        Integer foundedYear = null;
        Long locationId = null;
        long companyId = 0;

        try {
            companyId = Long.parseLong(companyIdRaw);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/company/company-list.jsp");
            return;
        }

        if (companyName == null || companyName.trim().isEmpty()) {
            error = "Company name is required.";
        }

        if (error == null && foundedYearRaw != null && !foundedYearRaw.trim().isEmpty()) {
            try {
                foundedYear = Integer.parseInt(foundedYearRaw);
                int currentYear = Year.now().getValue();
                if (foundedYear < 1800 || foundedYear > currentYear) {
                    error = "Founded year is invalid.";
                }
            } catch (NumberFormatException e) {
                error = "Founded year must be a number.";
            }
        }

        if (error == null && locationIdRaw != null && !locationIdRaw.trim().isEmpty()) {
            try {
                locationId = Long.parseLong(locationIdRaw);
            } catch (NumberFormatException e) {
                error = "Location is invalid.";
            }
        }

        Company company = new Company();
        company.setCompanyId(companyId);
        company.setCompanyName(companyName);
        company.setTaxCode(taxCode);
        company.setWebsiteUrl(websiteUrl);
        company.setEmail(email);
        company.setPhoneNumber(phoneNumber);
        company.setLogoUrl(logoUrl);
        company.setDescription(description);
        company.setFoundedYear(foundedYear);
        company.setCompanySize(companySize);
        company.setIndustry(industry);
        company.setAddressLine(addressLine);
        company.setLocationId(locationId);
        company.setStatus((status == null || status.trim().isEmpty()) ? "ACTIVE" : status);

        if (error != null) {
            LocationDAO locationDAO = new LocationDAO();
            request.setAttribute("company", company);
            request.setAttribute("locations", locationDAO.getAllActive());
            request.setAttribute("mode", "edit");
            request.setAttribute("error", error);
            request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
            return;
        }

        CompanyDAO companyDAO = new CompanyDAO();
        boolean updated = companyDAO.updateCompany(company);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/company/detail?id=" + companyId);
        } else {
            LocationDAO locationDAO = new LocationDAO();
            request.setAttribute("company", company);
            request.setAttribute("locations", locationDAO.getAllActive());
            request.setAttribute("mode", "edit");
            request.setAttribute("error", "Failed to update company.");
            request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
        }
    }
}