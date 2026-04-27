/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.NotificationDAO;
import dal.ReportDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Report;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "report", urlPatterns = {"/report"})
public class ReportServlet extends HttpServlet {

    ReportDAO dao = new ReportDAO();
    NotificationDAO notiDao = new NotificationDAO();
    private static final int PAGE_SIZE = 5;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ReportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReportServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // =========================
        // CHECK LOGIN + ROLE
        // =========================
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("userRole");

        if (!"ADMIN".equals(role)) {
            response.sendRedirect("jobs");
            return;
        }

        try {
            ReportDAO dao = new ReportDAO();

            // =========================
            // FILTER INPUT
            // =========================
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");

            keyword = (keyword != null) ? keyword.trim() : "";
            status = (status != null) ? status.trim() : "";

            // =========================
            // PAGINATION SAFETY
            // =========================
            int page = 1;
            String pageParam = request.getParameter("page");

            try {
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                }
            } catch (NumberFormatException e) {
                page = 1;
            }

            int offset = (page - 1) * PAGE_SIZE;

            // =========================
            // CHECK FILTER MODE
            // =========================
            boolean hasFilter = !keyword.isEmpty() || !status.isEmpty();

            List<Report> list;
            int totalReports;

            // =========================
            // QUERY DATA
            // =========================
            if (hasFilter) {

                list = dao.searchReportsAdvanced(keyword, status, offset, PAGE_SIZE);
                totalReports = dao.countReportsAdvanced(keyword, status);

            } else {

                list = dao.getReportsPaging(offset, PAGE_SIZE);
                totalReports = dao.getTotalReports();
            }

            int totalPages = (int) Math.ceil((double) totalReports / PAGE_SIZE);

            // =========================
            // SET ATTRIBUTE FOR JSP
            // =========================
            request.setAttribute("reports", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);

            // =========================
            // FORWARD JSP
            // =========================
            request.getRequestDispatcher("report_manager.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Server Error");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            // =============================
            // 👉 USER GỬI REPORT
            // =============================
            if ("create".equals(action)) {

                HttpSession session = request.getSession();
                Long userId = (Long) session.getAttribute("userId");

                String targetType = request.getParameter("targetType");
                long targetId = Long.parseLong(request.getParameter("targetId"));
                long reportTypeId = Long.parseLong(request.getParameter("reportTypeId"));
                String content = request.getParameter("content");

                Report r = new Report();
                r.setReporterId(userId);
                r.setTargetType(targetType);
                r.setTargetId(targetId);
                r.setReportTypeId(reportTypeId);
                r.setContent(content);
                r.setStatus("PENDING");

                dao.insert(r);

                response.sendRedirect(
                        request.getContextPath() + "/job-detail?id=" + targetId + "&success=reported"
                );
                return;
            }

            // =============================
            // 👉 ADMIN XỬ LÝ REPORT
            // =============================
            if ("approve".equals(action) || "reject".equals(action)) {

                long reportId = Long.parseLong(request.getParameter("id"));
                String status = action.equals("approve") ? "APPROVED" : "REJECTED";

                HttpSession session = request.getSession();
                long adminId = (Long) session.getAttribute("userId");

                // 👉 Lấy report
                Report r = dao.getById(reportId);

                // 👉 Update DB
                dao.updateStatus(reportId, status, adminId);

                // 👉 Gửi notification
                if (r != null) {
                    notiDao.sendReportResult(r.getReporterId(), status);
                }

                response.sendRedirect("report");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
