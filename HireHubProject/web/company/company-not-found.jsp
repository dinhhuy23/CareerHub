<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Not Found</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company.css">
</head>
<body>
    <div class="page-container">
        <div class="detail-card">
            <h1 class="page-title">Company Not Found</h1>
            <p class="page-subtitle">
                <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "The requested company does not exist." %>
            </p>

            <div class="button-group">
                <a href="${pageContext.request.contextPath}/company/company-list.jsp" class="btn btn-primary">Back to Company List</a>
            </div>
        </div>
    </div>
</body>
</html>