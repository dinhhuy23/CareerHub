<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // If user is logged in, redirect to dashboard
    if (session.getAttribute("jwtToken") != null) {
        response.sendRedirect(request.getContextPath() + "/user/dashboard");
        return;
    }
    // Otherwise redirect to login page
    response.sendRedirect(request.getContextPath() + "/login");
%>
