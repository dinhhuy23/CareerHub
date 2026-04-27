/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.NotificationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Notification;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "NotificationServlet", urlPatterns = {"/notification"})
public class NotificationServlet extends HttpServlet {

    NotificationDAO dao = new NotificationDAO();

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
            out.println("<title>Servlet NotificationServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NotificationServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        System.out.println("SESSION USER ID = " + session.getAttribute("userId"));
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login");
            return;
        }
        List<Notification> list = dao.getByUser(userId);

        request.setAttribute("notifications", list);
        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
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
        if ("create".equals(action)) {

            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String role = request.getParameter("role");
            String userIdStr = request.getParameter("userId");

            HttpSession session = request.getSession();
            Long adminObj = (Long) session.getAttribute("userId");

            if (adminObj == null) {
                response.sendRedirect("login");
                return;
            }

            long adminId = adminObj;

            boolean ok = false;

            if ("ALL".equals(role)) {
                ok = dao.sendToAll(title, content, adminId);

            } else if (userIdStr != null && !userIdStr.isEmpty()) {
                long userId = Long.parseLong(userIdStr);
                ok = dao.sendToUser(userId, title, content, adminId);

            } else {
                ok = dao.sendToRole(role, title, content, adminId);
            }

            if (ok) {
                response.sendRedirect("AdminServlet?success=1");
            } else {
                response.sendRedirect("AdminServlet?error=1");
            }
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
