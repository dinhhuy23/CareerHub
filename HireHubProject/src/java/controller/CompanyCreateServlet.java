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

@WebServlet(name = "CompanyCreateServlet", urlPatterns = {"/company/create"})
public class CompanyCreateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LocationDAO locationDAO = new LocationDAO();
        List<Location> locations = locationDAO.getAllActive();

        request.setAttribute("locations", locations);
        request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        if (error != null) {
            LocationDAO locationDAO = new LocationDAO();
            request.setAttribute("locations", locationDAO.getAllActive());
            request.setAttribute("error", error);

            request.setAttribute("companyName", companyName);
            request.setAttribute("taxCode", taxCode);
            request.setAttribute("websiteUrl", websiteUrl);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("logoUrl", logoUrl);
            request.setAttribute("description", description);
            request.setAttribute("foundedYear", foundedYearRaw);
            request.setAttribute("companySize", companySize);
            request.setAttribute("industry", industry);
            request.setAttribute("addressLine", addressLine);
            request.setAttribute("locationId", locationIdRaw);
            request.setAttribute("status", status);

            request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
            return;
        }

        Company company = new Company();
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

        // Chưa làm login nên tạm set cứng
        company.setCreatedByUserId(1L);

        CompanyDAO companyDAO = new CompanyDAO();
        long newCompanyId = companyDAO.insertCompanyAndReturnId(company);

        if (newCompanyId > 0) {
            response.sendRedirect(request.getContextPath() + "/company/detail?id=" + newCompanyId);
        } else {
            LocationDAO locationDAO = new LocationDAO();
            request.setAttribute("locations", locationDAO.getAllActive());
            request.setAttribute("error", "Failed to create company. Please try again.");
            request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
        }
    }
}