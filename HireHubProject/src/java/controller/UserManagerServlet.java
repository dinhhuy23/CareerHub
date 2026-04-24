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
//        List<User> list = dao.getAllUsers(); // 👈 LẤY TẤT CẢ USER
        int page = 1;
        int pageSize = 5;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        int offset = (page - 1) * pageSize;

        List<User> list = dao.getUsersPaging(offset, pageSize);
        int totalUsers = dao.getTotalUsers();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        request.setAttribute("list", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
//        request.setAttribute("list", list);
//
//        request.getRequestDispatcher("users.jsp").forward(request, response);
        String action = request.getParameter("action");

        try {
            if (action == null) {
                request.setAttribute("usermanager", list);
                request.getRequestDispatcher("user-manager.jsp").forward(request, response);
            } else if ("view".equals(action)) {
                long id = Long.parseLong(request.getParameter("id"));

                User user = dao.findById(id);

                request.setAttribute("user", user);

                request.getRequestDispatcher("user-detail.jsp").forward(request, response);
            } else if (action.equals("delete")) {
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
        UserDAO dao = new UserDAO();
        try {
            String idStr = request.getParameter("userId");

            User user = new User();
//            user.setRoleCode(request.getParameter("role"));
            user.setEmail(request.getParameter("email"));
            user.setFullName(request.getParameter("fullName"));
//            user.setStatus(request.getParameter("status"));
            user.setPhoneNumber(request.getParameter("phone"));
            user.setGender(request.getParameter("gender"));
            String password = request.getParameter("password");

            // 👉 CREATE
            if (idStr == null || idStr.isEmpty()) {

                if (password == null || password.isEmpty()) {
                    password = "123456"; // default
                }

                user.setPasswordHash(SecurityUtil.hashPassword(password));
                dao.insert(user);

                System.out.println("CREATE USER SUCCESS");

            } else {
                // 👉 UPDATE
                long id = Long.parseLong(idStr);
                user.setUserId(id);

                // 🔥 GIỮ PASSWORD CŨ nếu không nhập
                if (password != null && !password.isEmpty()) {
                    user.setPasswordHash(password);
                } else {
                    User oldUser = dao.findById(id);
                    user.setPasswordHash(oldUser.getPasswordHash());
                }

                dao.update(user);

                System.out.println("UPDATE USER SUCCESS ID = " + id);
            }
            String phone = request.getParameter("phone");

// validate SĐT
            if (phone == null || !phone.matches("^0\\d{9,10}$")) {

                request.setAttribute("error", "SĐT phải là số, bắt đầu bằng 0 và có 10-11 số");

                // giữ lại dữ liệu user nhập
                request.setAttribute("oldEmail", request.getParameter("email"));
                request.setAttribute("oldName", request.getParameter("fullName"));
                request.setAttribute("oldPhone", phone);

                request.getRequestDispatcher("user-manager.jsp").forward(request, response);
                return;
            }
            String email = request.getParameter("email");

// validate email
            if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {

                request.setAttribute("error", "Email không đúng định dạng");

                request.setAttribute("oldEmail", email);
                request.setAttribute("oldName", request.getParameter("fullName"));
                request.setAttribute("oldPhone", request.getParameter("phone"));

                request.getRequestDispatcher("user-manager.jsp").forward(request, response);
                return;
            }
            response.sendRedirect("usermanager");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>ERROR POST: " + e.getMessage() + "</h2>");
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
