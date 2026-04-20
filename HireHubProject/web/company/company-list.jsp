<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Recruiting Companies</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/header.jsp" />

        <div class="page-container">
            <div class="page-header">
                <h1 class="page-title">Companies</h1>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/company/create">+ Add Company</a>
            </div>

<!--            <div class="list-toolbar">
                <input type="text" class="search-box" id="searchInput" placeholder="Search company name...">

                <select class="filter-select" id="industryFilter">
                    <option value="All">All Industries</option>
                    <option value="Information Technology">Information Technology</option>
                    <option value="Technology & Digital Services">Technology & Digital Services</option>
                    <option value="Finance & Banking">Finance & Banking</option>
                    <option value="Software Outsourcing">Software Outsourcing</option>
                    <option value="Healthcare">Healthcare</option>
                    <option value="Human Resources Technology">Human Resources Technology</option>
                </select>

                <select class="filter-select" id="locationFilter">
                    <option value="All">All Locations</option>
                    <option value="Ha Noi">Ha Noi</option>
                    <option value="Ho Chi Minh City">Ho Chi Minh City</option>
                    <option value="Da Nang">Da Nang</option>
                </select>
            </div>-->

            <div class="company-list-grid" id="companyList">
                <c:forEach items="${companies}" var="company">
                    <div class="company-card">
                        <div class="company-card-header">
                            <img src="${company.logoUrl}" alt="${company.companyName} Logo" class="company-card-logo">
                            <div class="company-card-info">
                                <h2>${company.companyName}</h2>
                                <p>${company.industry}</p>
                                <span class="status-badge status-active">${company.status}</span>
                            </div>
                        </div>

                        <div class="company-card-body">
                            <p><strong>Size:</strong> ${company.companySize}</p>
                            <p><strong>Location:</strong> ${company.location.locationName}</p>
                            <p><strong>Website:</strong> ${company.websiteUrl}</p>
                            <p class="company-short-desc">${company.description}</p>
                        </div>

                        <div class="company-card-footer">
                            <a href="${pageContext.request.contextPath}/company/detail?id=${company.companyId}" class="btn btn-primary">View Detail</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <!--<script src="${pageContext.request.contextPath}/js/company.js"></script>-->
    </body>
</html>