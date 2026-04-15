<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recruiting Companies</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company.css">
</head>
<body>
    <div class="page-container">
        <div class="page-header">
            <h1 class="page-title">Recruiting Companies</h1>
            <p class="page-subtitle">Explore companies that are actively hiring on the system</p>
        </div>

        <div class="list-toolbar">
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
        </div>

        <div class="company-list-grid" id="companyList"></div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/js/company.js"></script>
</body>
</html>