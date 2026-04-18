<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("jwtToken") != null) {
        response.sendRedirect(request.getContextPath() + "/user/dashboard");
        return;
    }

    response.sendRedirect(request.getContextPath() + "/jobs");
%>