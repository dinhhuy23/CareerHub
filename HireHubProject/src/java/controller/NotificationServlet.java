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

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }

        long userId = (Long) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole"); // 👈 QUAN TRỌNG
        String view = request.getParameter("view");

// =============================
// 👉 ADMIN
// =============================
        if ("ADMIN".equals(role)) {

            // 👉 nếu chưa có view thì auto chuyển sang sent
            if (view == null) {
                response.sendRedirect("notification?view=sent");
                return;
            }

            // 👉 ADMIN xem list đã gửi
            if ("sent".equals(view)) {

                int page = 1;
                int pageSize = 5;

                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                }

                int offset = (page - 1) * pageSize;

                String keyword = request.getParameter("keyword");

                List<Notification> list;
                int total;

                if (keyword != null && !keyword.trim().isEmpty()) {
                    list = dao.searchNotifications(keyword, offset, pageSize);
                    total = dao.getTotalSearchNotifications(keyword);
                    request.setAttribute("keyword", keyword);
                } else {
                    list = dao.getNotificationsPaging(offset, pageSize);
                    total = dao.getTotalNotifications();
                }

                int totalPages = (int) Math.ceil((double) total / pageSize);

                request.setAttribute("notifications", list);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);

                request.getRequestDispatcher("notifications_sent.jsp")
                        .forward(request, response);
                return;
            }
        }

// =============================
// 👉 USER (mặc định)
// =============================
        List<Notification> list = dao.getByUser(userId);

        request.setAttribute("notifications", list);
        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp")
                .forward(request, response);
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
                response.sendRedirect("admin?success=1");
            } else {
                response.sendRedirect("admin?error=1");
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
