/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CompanyDAO;
import dal.DepartmentDAO;
import dal.RecruiterDAO;
import dal.RoleDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Recruiter;
import model.Role;
import model.User;
import utils.SecurityUtil;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RecruiterController", urlPatterns = {"/admin/recruiters"})
public class RecruiterController extends HttpServlet {

    private final RecruiterDAO recruiterDAO = new RecruiterDAO();

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();
    private final CompanyDAO companyDAO = new CompanyDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

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
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                request.setAttribute("companies", companyDAO.getAll());
                request.setAttribute("departments", departmentDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/recruiter-form.jsp")
                        .forward(request, response);
                break;
            case "delete":
                long id = Long.parseLong(request.getParameter("id"));
                recruiterDAO.delete(id);
                response.sendRedirect("/HireHubProject/admin/recruiters");
                break;

            case "edit":
                long editId = Long.parseLong(request.getParameter("id"));
                request.setAttribute("recruiter", recruiterDAO.getById(editId));
                request.setAttribute("companies", companyDAO.getAll());
                request.setAttribute("departments", departmentDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/recruiter-form.jsp").forward(request, response);
                break;

            default:
                request.setAttribute("list", recruiterDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/recruiter-list.jsp").forward(request, response);
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
        processRequest(request, response);
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
        String id = request.getParameter("id");
        Recruiter r = new Recruiter();
        
        if (id == null || id.isEmpty()) {
            String email = request.getParameter("email");
            User existingUser = userDAO.findByEmail(email);
            long userId;

            if (existingUser != null) {
                // Nếu User đã tồn tại, kiểm tra xem họ đã có Profile chưa
                Recruiter existingProfile = recruiterDAO.getByUserId(existingUser.getUserId());
                if (existingProfile != null) {
                    request.setAttribute("error", "Người dùng với email này đã có hồ sơ tuyển dụng tại công ty: " + existingProfile.getCompanyName());
                    
                    // Reload form data
                    request.setAttribute("companies", companyDAO.getAll());
                    request.setAttribute("departments", departmentDAO.getAll());
                    request.getRequestDispatcher("/WEB-INF/views/recruiter-form.jsp").forward(request, response);
                    return;
                }
                
                userId = existingUser.getUserId();
                
                // Đảm bảo User này có Role là RECRUITER (nếu chưa có thì gán)
                boolean hasRecruiterRole = false;
                for (Role role : roleDAO.findRolesByUserId(userId)) {
                    if ("RECRUITER".equals(role.getRoleCode())) {
                        hasRecruiterRole = true;
                        break;
                    }
                }
                
                if (!hasRecruiterRole) {
                    Role recruiterRole = roleDAO.findByRoleCode("RECRUITER");
                    if (recruiterRole != null) {
                        roleDAO.assignRole(userId, recruiterRole.getRoleId());
                    }
                }
            } else {
                // Nếu User chưa tồn tại, tạo mới hoàn toàn
                User u = new User();
                u.setEmail(email);
                u.setPasswordHash(SecurityUtil.hashPassword("Abc@123456"));
                u.setFullName(request.getParameter("fullName"));
                u.setStatus("ACTIVE");

                userId = userDAO.insert(u);

                // Assign role
                Role role = roleDAO.findByRoleCode("RECRUITER");
                if (role != null) {
                    roleDAO.assignRole(userId, role.getRoleId());
                }
            }

            // Tạo hồ sơ recruiter (link UserId với CompanyId)
            r.setUserId(userId);
            r.setCompanyId(Long.parseLong(request.getParameter("companyId")));
            String deptIdStr = request.getParameter("departmentId");
            if (deptIdStr != null && !deptIdStr.isEmpty()) {
                r.setDepartmentId(Long.parseLong(deptIdStr));
            } else {
                r.setDepartmentId(null);
            }
            r.setJobTitle(request.getParameter("jobTitle"));
            r.setBio(request.getParameter("bio"));
            r.setStatus("ACTIVE");

            recruiterDAO.insert(r);
        } else {
            r = recruiterDAO.getById(Long.parseLong(id));
            r.setCompanyId(Long.parseLong(request.getParameter("companyId")));
            String deptIdStr = request.getParameter("departmentId");
            if (deptIdStr != null && !deptIdStr.isEmpty()) {
                r.setDepartmentId(Long.parseLong(deptIdStr));
            } else {
                r.setDepartmentId(null);
            }
            r.setJobTitle(request.getParameter("jobTitle"));
            r.setBio(request.getParameter("bio"));
            recruiterDAO.update(r);
        }

        response.sendRedirect(request.getContextPath() + "/admin/recruiters");
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
