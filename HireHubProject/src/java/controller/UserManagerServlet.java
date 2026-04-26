/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.NotificationDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.User;
import utils.SecurityUtil;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "usermanager", urlPatterns = {"/usermanager"})
public class UserManagerServlet extends HttpServlet {

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
            out.println("<title>Servlet UserManagerServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserManagerServlet at " + request.getContextPath() + "</h1>");
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

        UserDAO dao = new UserDAO();

        int page = 1;
        int pageSize = 5;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        int offset = (page - 1) * pageSize;

        List<User> list;
        int totalUsers;

        boolean hasFilter
                = (keyword != null && !keyword.trim().isEmpty())
                || (status != null && !status.trim().isEmpty());

        if (hasFilter) {

            list = dao.searchUsersAdvanced(keyword, status, offset, pageSize);
            totalUsers = dao.getTotalUsersAdvanced(keyword, status);

        } else {

            list = dao.getUsersPaging(offset, pageSize);
            totalUsers = dao.getTotalUsers();
        }

        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        request.setAttribute("list", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);

        String action = request.getParameter("action");

        try {
            if (action == null) {
                request.getRequestDispatcher("user-manager.jsp").forward(request, response);

            } else if ("view".equals(action)) {

                long id = Long.parseLong(request.getParameter("id"));
                User user = dao.findById(id);

                request.setAttribute("user", user);
                request.getRequestDispatcher("user-detail.jsp").forward(request, response);

            } else if ("delete".equals(action)) {

                long id = Long.parseLong(request.getParameter("id"));
                String reason = request.getParameter("reason");

                dao.deactivateUser(id, reason);

                response.sendRedirect("usermanager");
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
        request.setCharacterEncoding("UTF-8");

        UserDAO dao = new UserDAO();

        try {
            String idStr = request.getParameter("userId");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // 🔥 VALIDATE TRƯỚC
            if (phone == null || !phone.matches("^0\\d{9,10}$")) {
                request.setAttribute("error", "SĐT phải hợp lệ");
                request.getRequestDispatcher("user-manager.jsp").forward(request, response);
                return;
            }

            if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                request.setAttribute("error", "Email không đúng");
                request.getRequestDispatcher("user-manager.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setEmail(email);
            user.setFullName(request.getParameter("fullName"));
            user.setPhoneNumber(phone);
            user.setGender(request.getParameter("gender"));

            String password = request.getParameter("password");

            // 👉 CREATE
            if (idStr == null || idStr.isEmpty()) {

                if (password == null || password.isEmpty()) {
                    password = "123456";
                }

                user.setPasswordHash(SecurityUtil.hashPassword(password));
                dao.insert(user);

            } else {
                // 👉 UPDATE
                long id = Long.parseLong(idStr);
                user.setUserId(id);

                if (password != null && !password.isEmpty()) {
                    user.setPasswordHash(SecurityUtil.hashPassword(password));
                } else {
                    User oldUser = dao.findById(id);
                    user.setPasswordHash(oldUser.getPasswordHash());
                }

                dao.update(user);
            }

            response.sendRedirect("usermanager");

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
