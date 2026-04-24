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
        String errorMsg = null;
        if (name == null || name.trim().isEmpty() || companyIdStr == null || companyIdStr.isEmpty()) {
            errorMsg = "Tên phòng ban và công ty không được để trống.";
        } else if (name.trim().length() > 150) {
            errorMsg = "Tên phòng ban không được vượt quá 150 ký tự.";
        } else if (desc != null && desc.trim().length() > 500) {
            errorMsg = "Mô tả không được vượt quá 500 ký tự.";
        }

        Department d = new Department();
        if (id != null && !id.isEmpty()) {
            try { d.setDepartmentId(Long.parseLong(id)); } catch (NumberFormatException ignored) {}
        }
        d.setDepartmentName(name != null ? name.trim() : "");
        d.setDescription(desc != null ? desc.trim() : "");
        if (companyIdStr != null && !companyIdStr.isEmpty()) {
            try { d.setCompanyId(Long.parseLong(companyIdStr)); } catch (NumberFormatException ignored) {}
        }

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            request.setAttribute("companies", companyDAO.getAll());
            request.setAttribute("department", d);
            request.getRequestDispatcher("/WEB-INF/views/department-form.jsp").forward(request, response);
            return;
        }

        if (id == null || id.isEmpty()) {
            departmentDAO.insert(d);
        } else {
            departmentDAO.update(d);
        }

        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }
}
