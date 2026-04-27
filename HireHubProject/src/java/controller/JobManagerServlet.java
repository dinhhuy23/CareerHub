/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.JobDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Job;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "jobmanager", urlPatterns = {"/jobmanager"})
public class JobManagerServlet extends HttpServlet {

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
            out.println("<title>Servlet JobManagerServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet JobManagerServlet at " + request.getContextPath() + "</h1>");
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
        JobDAO dao = new JobDAO();

    int page = 1;
    int pageSize = 5;

    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        page = Integer.parseInt(pageParam);
    }

    int offset = (page - 1) * pageSize;

    // 🔥 LẤY PARAM FILTER
    String keyword = request.getParameter("keyword");
    String status = request.getParameter("status");
    String sortSalary = request.getParameter("sortSalary");

    // 👉 gọi DAO mới
    List<Job> list = dao.searchJobs(keyword, status, sortSalary, offset, pageSize);
    int totalJobs = dao.countSearchJobs(keyword, status);
    int totalPages = (int) Math.ceil((double) totalJobs / pageSize);

    request.setAttribute("list", list);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);

    // 👉 giữ lại giá trị filter cho JSP
    request.setAttribute("keyword", keyword);
    request.setAttribute("status", status);
    request.setAttribute("sortSalary", sortSalary);

    String action = request.getParameter("action");

    try {
        if (action == null) {
            request.getRequestDispatcher("job-manager.jsp").forward(request, response);

        } else if ("view".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            Job job = dao.findById(id);

            request.setAttribute("job", job);
            request.getRequestDispatcher("job-detail-admin.jsp").forward(request, response);

        } else if ("delete".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            dao.closeJob(id);

            response.sendRedirect("jobmanager");
        }

    } catch (Exception e) {
        e.printStackTrace();
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
        JobDAO dao = new JobDAO();

        try {
            String idStr = request.getParameter("jobId");

            Job job = new Job();
            String title = request.getParameter("title");
            long jobId = Long.parseLong(request.getParameter("jobId"));
            Double salaryMin = Double.parseDouble(request.getParameter("salaryMin"));
            Double salaryMax = Double.parseDouble(request.getParameter("salaryMax"));
            job.setResponsibilities(request.getParameter("responsibilities"));
            job.setRequirements(request.getParameter("requirements"));
            job.setPostedByRecruiterId(1); // 👈 tạm hardcode hoặc lấy từ session

            // 👉 CREATE
            if (idStr == null || idStr.isEmpty()) {

                dao.insert(job);
                System.out.println("CREATE JOB SUCCESS");

            } else {
                // 👉 UPDATE
                dao.updateBasic(jobId, title, salaryMin, salaryMax);
                System.out.println("UPDATE JOB SUCCESS");
            }

            response.sendRedirect("jobmanager");

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
