/*
 * Recruiter management controller with full validation,
 * per-field error messages, toast flash notifications, and server-side pagination.
 */
package controller;

import dal.CompanyDAO;
import dal.DepartmentDAO;
import dal.RecruiterDAO;
import dal.RoleDAO;
import dal.UserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Recruiter;
import model.Role;
import model.User;
import utils.SecurityUtil;

@WebServlet(name = "RecruiterController", urlPatterns = {"/admin/recruiters"})
public class RecruiterController extends HttpServlet {

    private final RecruiterDAO recruiterDAO   = new RecruiterDAO();
    private final UserDAO       userDAO       = new UserDAO();
    private final RoleDAO       roleDAO       = new RoleDAO();
    private final CompanyDAO    companyDAO    = new CompanyDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    // ── Limits (same values shown to user in JSP char counters) ──────────────
    private static final int MAX_EMAIL      = 255;
    private static final int MAX_FULL_NAME  = 150;
    private static final int MAX_JOB_TITLE  = 150;
    private static final int MAX_BIO        = 1000;

    // ── GET ───────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                request.setAttribute("isCreate",    true);
                request.setAttribute("companies",   companyDAO.getAll());
                request.setAttribute("departments", departmentDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/recruiter-form.jsp")
                       .forward(request, response);
                break;

            case "edit":
                long editId = Long.parseLong(request.getParameter("id"));
                request.setAttribute("isCreate",    false);
                request.setAttribute("recruiter",   recruiterDAO.getById(editId));
                request.setAttribute("companies",   companyDAO.getAll());
                request.setAttribute("departments", departmentDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/recruiter-form.jsp")
                       .forward(request, response);
                break;

            case "delete":
                long delId = Long.parseLong(request.getParameter("id"));
                recruiterDAO.delete(delId);
                setToast(request, "success", "Đã khóa nhà tuyển dụng thành công.");
                response.sendRedirect(request.getContextPath() + "/admin/recruiters");
                break;

            default:
                // Đọc toast từ session (do redirect để lại)
                HttpSession sess = request.getSession(false);
                if (sess != null) {
                    String toastType = (String) sess.getAttribute("toastType");
                    String toastMsg  = (String) sess.getAttribute("toastMsg");
                    if (toastType != null) {
                        request.setAttribute("toastType", toastType);
                        request.setAttribute("toastMsg",  toastMsg);
                        sess.removeAttribute("toastType");
                        sess.removeAttribute("toastMsg");
                    }
                }

                // ── Filter params ─────────────────────────────────────────────
                String keyword = trim(request.getParameter("keyword"));
                String status  = nvl(request.getParameter("status"),  "All");
                String company = nvl(request.getParameter("company"), "All");
                int rPage      = parsePage(request.getParameter("page"));

                // Stats (full-DB)
                int rTotal  = recruiterDAO.countAll();
                int rActive = recruiterDAO.countActive();

                // Filtered
                int rFiltered   = recruiterDAO.countFiltered(keyword, status, company);
                int rTotalPages = Math.max(1, (int) Math.ceil((double) rFiltered / PAGE_SIZE));
                rPage = Math.min(rPage, rTotalPages);

                request.setAttribute("list",         recruiterDAO.getFiltered(keyword, status, company, rPage, PAGE_SIZE));
                request.setAttribute("keyword",      keyword);
                request.setAttribute("statusFilter", status);
                request.setAttribute("companyFilter",company);
                request.setAttribute("currentPage",  rPage);
                request.setAttribute("totalPages",   rTotalPages);
                request.setAttribute("totalItems",   rFiltered);
                request.setAttribute("totalCount",   rTotal);
                request.setAttribute("activeCount",  rActive);
                request.setAttribute("pageNums",     buildPageNums(rPage, rTotalPages));
                request.setAttribute("allCompanies", companyDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/recruiter-list.jsp")
                       .forward(request, response);
        }
    }

    // ── POST ──────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id           = request.getParameter("id");
        String email        = trim(request.getParameter("email"));
        String fullName     = trim(request.getParameter("fullName"));
        String jobTitle     = trim(request.getParameter("jobTitle"));
        String bio          = trim(request.getParameter("bio"));
        String companyIdStr = trim(request.getParameter("companyId"));
        String deptIdStr    = trim(request.getParameter("departmentId"));

        boolean isCreate = (id == null || id.trim().isEmpty());

        // ── Validation ────────────────────────────────────────────────────────
        Map<String, String> errors = new HashMap<>();

        if (isCreate) {
            if (email.isEmpty()) {
                errors.put("email", "Email không được để trống.");
            } else if (!email.matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$")) {
                errors.put("email", "Email không đúng định dạng.");
            } else if (email.length() > MAX_EMAIL) {
                errors.put("email", "Email không được vượt quá " + MAX_EMAIL + " ký tự.");
            }

            if (fullName.isEmpty()) {
                errors.put("fullName", "Họ và tên không được để trống.");
            } else if (fullName.length() > MAX_FULL_NAME) {
                errors.put("fullName", "Họ và tên không được vượt quá " + MAX_FULL_NAME + " ký tự.");
            }
        }

        if (jobTitle.isEmpty()) {
            errors.put("jobTitle", "Chức danh công việc không được để trống.");
        } else if (jobTitle.length() > MAX_JOB_TITLE) {
            errors.put("jobTitle", "Chức danh không được vượt quá " + MAX_JOB_TITLE + " ký tự.");
        }

        if (companyIdStr.isEmpty()) {
            errors.put("companyId", "Vui lòng chọn công ty.");
        }

        if (!bio.isEmpty() && bio.length() > MAX_BIO) {
            errors.put("bio", "Bio không được vượt quá " + MAX_BIO + " ký tự.");
        }

        // ── Nếu có lỗi → trả lại ĐÚNG form (add hoặc edit), không chạm DB ────
        if (!errors.isEmpty()) {
            // Dựng lại recruiter bean để giữ giá trị đã nhập
            Recruiter r = new Recruiter();
            r.setEmail(email);
            r.setFullName(fullName);
            r.setJobTitle(jobTitle);
            r.setBio(bio);
            if (!companyIdStr.isEmpty()) {
                try { r.setCompanyId(Long.parseLong(companyIdStr)); } catch (NumberFormatException ignored) {}
            }
            if (!deptIdStr.isEmpty()) {
                try { r.setDepartmentId(Long.parseLong(deptIdStr)); } catch (NumberFormatException ignored) {}
            }
            if (!isCreate) {
                try { r.setRecruiterId(Long.parseLong(id)); } catch (NumberFormatException ignored) {}
            }

            // isCreate quyết định form hiển thị chế độ Thêm hay Sửa
            request.setAttribute("isCreate",   isCreate);
            request.setAttribute("recruiter",  r);
            request.setAttribute("errors",     errors);
            request.setAttribute("error",      "Vui lòng kiểm tra lại thông tin đã nhập.");
            request.setAttribute("companies",  companyDAO.getAll());
            request.setAttribute("departments",departmentDAO.getAll());
            request.getRequestDispatcher("/WEB-INF/views/recruiter-form.jsp")
                   .forward(request, response);
            return;
        }

        // ── Không có lỗi → xử lý DB ──────────────────────────────────────────
        try {
            if (isCreate) {
                // Kiểm tra email đã tồn tại chưa
                User existingUser = userDAO.findByEmail(email);
                long userId;

                if (existingUser != null) {
                    Recruiter existingProfile = recruiterDAO.getByUserId(existingUser.getUserId());
                    if (existingProfile != null) {
                        request.setAttribute("error",
                            "Email này đã có hồ sơ tuyển dụng tại công ty: " + existingProfile.getCompanyName());
                        Recruiter r = new Recruiter();
                        r.setEmail(email); r.setFullName(fullName); r.setJobTitle(jobTitle); r.setBio(bio);
                        request.setAttribute("isCreate",    true);   // vẫn là trang Thêm mới
                        request.setAttribute("recruiter",   r);
                        request.setAttribute("companies",   companyDAO.getAll());
                        request.setAttribute("departments", departmentDAO.getAll());
                        request.getRequestDispatcher("/WEB-INF/views/recruiter-form.jsp")
                               .forward(request, response);
                        return;
                    }
                    userId = existingUser.getUserId();
                    // Gán role RECRUITER nếu chưa có
                    boolean hasRole = false;
                    for (Role role : roleDAO.findRolesByUserId(userId)) {
                        if ("RECRUITER".equals(role.getRoleCode())) { hasRole = true; break; }
                    }
                    if (!hasRole) {
                        Role recruiterRole = roleDAO.findByRoleCode("RECRUITER");
                        if (recruiterRole != null) roleDAO.assignRole(userId, recruiterRole.getRoleId());
                    }
                } else {
                    // Tạo user mới
                    User u = new User();
                    u.setEmail(email);
                    u.setPasswordHash(SecurityUtil.hashPassword("Abc@123456"));
                    u.setFullName(fullName);
                    u.setStatus("ACTIVE");
                    userId = userDAO.insert(u);

                    Role role = roleDAO.findByRoleCode("RECRUITER");
                    if (role != null) roleDAO.assignRole(userId, role.getRoleId());
                }

                // Tạo recruiter profile
                Recruiter r = new Recruiter();
                r.setUserId(userId);
                r.setCompanyId(Long.parseLong(companyIdStr));
                if (!deptIdStr.isEmpty()) r.setDepartmentId(Long.parseLong(deptIdStr));
                r.setJobTitle(jobTitle);
                r.setBio(bio.isEmpty() ? null : bio);
                r.setStatus("ACTIVE");

                boolean ok = recruiterDAO.insert(r);
                setToast(request, ok ? "success" : "error",
                    ok ? "Thêm nhà tuyển dụng thành công!"
                       : "Thêm nhà tuyển dụng thất bại. Vui lòng thử lại.");

            } else {
                // Cập nhật
                Recruiter r = recruiterDAO.getById(Long.parseLong(id));
                r.setCompanyId(Long.parseLong(companyIdStr));
                if (!deptIdStr.isEmpty()) {
                    r.setDepartmentId(Long.parseLong(deptIdStr));
                } else {
                    r.setDepartmentId(null);
                }
                r.setJobTitle(jobTitle);
                r.setBio(bio.isEmpty() ? null : bio);

                boolean ok = recruiterDAO.update(r);
                setToast(request, ok ? "success" : "error",
                    ok ? "Cập nhật nhà tuyển dụng thành công!"
                       : "Cập nhật thất bại. Vui lòng thử lại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            setToast(request, "error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/recruiters");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────
    private static final int PAGE_SIZE = 10;

    /** null-safe trim */
    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private static String nvl(String s, String def) {
        return (s == null || s.trim().isEmpty()) ? def : s.trim();
    }

    private static int parsePage(String s) {
        try { int p = Integer.parseInt(s); return p < 1 ? 1 : p; }
        catch (Exception e) { return 1; }
    }

    /** Xây dựng danh sách số trang, -1 = ellipsis. */
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

    /** Lưu toast vào session để hiện sau redirect */
    private static void setToast(HttpServletRequest request, String type, String msg) {
        HttpSession sess = request.getSession(true);
        sess.setAttribute("toastType", type);
        sess.setAttribute("toastMsg",  msg);
    }

    @Override
    public String getServletInfo() { return "Recruiter Admin Controller"; }
}
