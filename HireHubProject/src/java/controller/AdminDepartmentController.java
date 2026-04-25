package controller;

import dal.CompanyDAO;
import dal.DepartmentDAO;
import dal.RecruiterDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
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
    private final RecruiterDAO recruiterDAO = new RecruiterDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                request.setAttribute("companies", companyDAO.getAll());
                request.setAttribute("allRecruiters", recruiterDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/department-form.jsp").forward(request, response);
                break;

            case "view":
                long viewId = Long.parseLong(request.getParameter("id"));
                request.setAttribute("department", departmentDAO.getById(viewId));
                request.getRequestDispatcher("/WEB-INF/views/department-detail.jsp").forward(request, response);
                break;

            case "edit":
                long editId = Long.parseLong(request.getParameter("id"));
                request.setAttribute("department", departmentDAO.getById(editId));
                request.setAttribute("companies", companyDAO.getAll());
                request.setAttribute("allRecruiters", recruiterDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/department-form.jsp").forward(request, response);
                break;

            case "delete":
                long delId = Long.parseLong(request.getParameter("id"));
                departmentDAO.delete(delId);
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                break;

            default:
                String keyword = nvl(request.getParameter("keyword"));
                String dStatus = nvl(request.getParameter("status"),  "All");
                String dComp   = nvl(request.getParameter("company"), "All");
                int dPage      = parsePage(request.getParameter("page"));

                // Stats (full-DB, không phụ thuộc filter)
                int dTotal  = departmentDAO.countAll();
                int dActive = departmentDAO.countActive();

                // Filtered
                String statusKey = "All".equals(dStatus) ? "" : dStatus;
                int dFiltered   = departmentDAO.countFiltered(keyword, statusKey, dComp);
                int dTotalPages = Math.max(1, (int) Math.ceil((double) dFiltered / PAGE_SIZE));
                dPage = Math.min(dPage, dTotalPages);

                request.setAttribute("list",         departmentDAO.getFiltered(keyword, statusKey, dComp, dPage, PAGE_SIZE));
                request.setAttribute("keyword",      keyword);
                request.setAttribute("statusFilter", dStatus);
                request.setAttribute("companyFilter",dComp);
                request.setAttribute("currentPage",  dPage);
                request.setAttribute("totalPages",   dTotalPages);
                request.setAttribute("totalItems",   dFiltered);
                request.setAttribute("totalCount",   dTotal);
                request.setAttribute("activeCount",  dActive);
                request.setAttribute("pageNums",     buildPageNums(dPage, dTotalPages));
                request.setAttribute("allCompanies", companyDAO.getAll());
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
        
        String managerName = request.getParameter("managerName");
        String contactEmail = request.getParameter("contactEmail");
        String phoneNumber = request.getParameter("phoneNumber");
        String location = request.getParameter("location");

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
        
        d.setManagerName(managerName != null ? managerName.trim() : "");
        d.setContactEmail(contactEmail != null ? contactEmail.trim() : "");
        d.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : "");
        d.setLocation(location != null ? location.trim() : "");
        
        String isActiveStr = request.getParameter("isActive");
        if (isActiveStr != null) {
            d.setIsActive("1".equals(isActiveStr));
        } else {
            d.setIsActive(true); // default for new
        }

        String[] recruiterIds = request.getParameterValues("recruiterIds");

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            request.setAttribute("companies", companyDAO.getAll());
            request.setAttribute("allRecruiters", recruiterDAO.getAll());
            request.setAttribute("department", d);
            request.getRequestDispatcher("/WEB-INF/views/department-form.jsp").forward(request, response);
            return;
        }

        if (id == null || id.isEmpty()) {
            long newDeptId = departmentDAO.insert(d);
            if (newDeptId > 0 && recruiterIds != null && recruiterIds.length > 0) {
                recruiterDAO.assignDepartment(newDeptId, recruiterIds);
            }
        } else {
            long deptId = d.getDepartmentId();
            departmentDAO.update(d);
            recruiterDAO.clearDepartment(deptId);
            if (recruiterIds != null && recruiterIds.length > 0) {
                recruiterDAO.assignDepartment(deptId, recruiterIds);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }

    // ── Pagination helpers ──────────────────────────────────────────────────
    private static final int PAGE_SIZE = 10;

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
