package controller;

import dal.CompanyDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Company;

@WebServlet(name = "AdminCompanyController", urlPatterns = {"/admin/company"})
public class AdminCompanyController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // ── Flash toast từ session ────────────────────────────────────────────
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

        // ── Filter params ─────────────────────────────────────────────────────
        String keyword  = nvl(request.getParameter("keyword"));
        String industry = nvl(request.getParameter("industry"), "All");
        String location = nvl(request.getParameter("location"), "All");

        // ── Phân trang ────────────────────────────────────────────────────────
        int page = parsePage(request.getParameter("page"));

        // Stats (always full-DB counts, không phụ thuộc filter)
        int totalCount  = companyDAO.countAll();
        int activeCount = companyDAO.countActive();

        // Filtered counts
        int totalItems = companyDAO.countFiltered(keyword, industry, location);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));
        page = Math.min(page, totalPages);

        List<Company> companies = companyDAO.getFiltered(keyword, industry, location, page, PAGE_SIZE);

        // ── Attributes ────────────────────────────────────────────────────────
        request.setAttribute("companies",    companies);
        request.setAttribute("keyword",      keyword);
        request.setAttribute("industry",     industry);
        request.setAttribute("location",     location);
        request.setAttribute("currentPage",  page);
        request.setAttribute("totalPages",   totalPages);
        request.setAttribute("totalItems",   totalItems);
        request.setAttribute("pageSize",     PAGE_SIZE);
        request.setAttribute("totalCount",   totalCount);
        request.setAttribute("activeCount",  activeCount);
        request.setAttribute("pageNums",     buildPageNums(page, totalPages));

        request.getRequestDispatcher("/company/company-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────
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

    /**
     * Xây dựng danh sách số trang để render nút phân trang.
     * -1 đại diện cho dấu "..." (ellipsis).
     */
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

    @Override
    public String getServletInfo() { return "Admin Company Controller"; }
}
