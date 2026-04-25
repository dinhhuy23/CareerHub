package controller;

import dal.CompanyDAO;
import dal.JobDAO;
import model.Company;
import model.Job;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CompanyController", urlPatterns = {"/company"})
public class CompanyController extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();
    private final JobDAO jobDAO = new JobDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        try {
            long companyId = Long.parseLong(idParam);
            Company company = companyDAO.findById(companyId);

            if (company == null || !"ACTIVE".equals(company.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/jobs");
                return;
            }

            // Lấy danh sách các jobs đang mở của công ty này
            List<Job> companyJobs = jobDAO.findByCompanyId(companyId);
            request.setAttribute("company", company);
            request.setAttribute("companyJobs", companyJobs);

            request.getRequestDispatcher("/WEB-INF/views/company_detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
    }
}
