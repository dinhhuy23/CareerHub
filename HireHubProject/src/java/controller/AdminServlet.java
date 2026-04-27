/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.JobDAO;
import dal.ReportDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Job;
import model.Report;
import model.User;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

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
            out.println("<title>Servlet AdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession(false);

//         🔐 CHECK LOGIN
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");

//         🔐 CHECK ADMIN
//        System.out.println("SESSION ROLE = " + session.getAttribute("userRole"));
        if (!"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        // 👉 load data
        UserDAO userDAO = new UserDAO();
        JobDAO jobDAO = new JobDAO();
        ReportDAO reportDAO = new ReportDAO();

        int totalUsers = userDAO.getAllUsers().size();
        int totalJobs = jobDAO.getAllJobs().size();
        int totalReports = reportDAO.getAll().size();

        List<Report> reports = reportDAO.getAll();
        List<Job> listJob = jobDAO.getLatestJobs(5);
// 🔥 THÊM Ở ĐÂY
        List<User> listuser = userDAO.getTopUsers(5);

// 👉 set attribute
        request.setAttribute("listJob", listJob);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalJobs", totalJobs);
        request.setAttribute("totalReports", totalReports);
        request.setAttribute("reports", reports);
        request.setAttribute("listuser", listuser); // 🔥 QUAN TRỌNG

// 👉 forward
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);

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
        String action = request.getParameter("action");

        // 👉 xử lý report
        if ("updateReport".equals(action)) {

            long reportId = Long.parseLong(request.getParameter("id"));
            String status = request.getParameter("status");

            HttpSession session = request.getSession();
            long adminId = (Long) session.getAttribute("userId");

            ReportDAO dao = new ReportDAO();
            dao.updateStatus(reportId, status, adminId);
        }

        response.sendRedirect("AdminServlet");

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
