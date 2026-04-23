package controller;

import dal.CompanyDAO;
import dal.DepartmentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Department;

@WebServlet(name = "AdminDepartmentController", urlPatterns = {"/admin/departments"})
public class AdminDepartmentController extends HttpServlet {

    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                request.setAttribute("companies", companyDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/department-form.jsp").forward(request, response);
                break;

            case "edit":
                long editId = Long.parseLong(request.getParameter("id"));
                request.setAttribute("department", departmentDAO.getById(editId));
                request.setAttribute("companies", companyDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/department-form.jsp").forward(request, response);
                break;

            case "delete":
                long delId = Long.parseLong(request.getParameter("id"));
                departmentDAO.delete(delId);
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                break;

            default:
                request.setAttribute("list", departmentDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/department-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String name = request.getParameter("departmentName");
        String desc = request.getParameter("description");
        String companyIdStr = request.getParameter("companyId");

        // Validate
        if (name == null || name.trim().isEmpty() || companyIdStr == null || companyIdStr.isEmpty()) {
            request.setAttribute("error", "Tên phòng ban và công ty không được để trống.");
            request.setAttribute("companies", companyDAO.getAll());
            if (id != null && !id.isEmpty()) {
                request.setAttribute("department", departmentDAO.getById(Long.parseLong(id)));
            }
            request.getRequestDispatcher("/WEB-INF/views/department-form.jsp").forward(request, response);
            return;
        }

        Department d = new Department();
        d.setDepartmentName(name.trim());
        d.setDescription(desc != null ? desc.trim() : "");
        d.setCompanyId(Long.parseLong(companyIdStr));

        if (id == null || id.isEmpty()) {
            departmentDAO.insert(d);
        } else {
            d.setDepartmentId(Long.parseLong(id));
            departmentDAO.update(d);
        }

        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }
}
