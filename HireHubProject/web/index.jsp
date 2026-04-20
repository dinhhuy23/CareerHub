<%
    String role = (String) session.getAttribute("userRole");
    if (role != null) {
        if ("ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/recruiters");
        } else if ("RECRUITER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/employer/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/dashboard");
        }
        return;
    }

    response.sendRedirect(request.getContextPath() + "/jobs");
%>