<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tìm kiếm việc làm - HireHub</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .recruiter-card {
                padding: 24px;
                border-radius: 16px;
                backdrop-filter: blur(10px);
            }

            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .btn-add {
                background: linear-gradient(135deg, #6c63ff, #4f46e5);
                color: white;
                padding: 10px 16px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 500;
            }

            .recruiter-table {
                width: 100%;
                border-collapse: collapse;
            }

            .recruiter-table th {
                text-align: left;
                padding: 12px;
                opacity: 0.7;
                font-weight: 500;
            }

            .recruiter-table td {
                padding: 14px 12px;
                border-top: 1px solid rgba(255,255,255,0.05);
            }

            .recruiter-table tr:hover {
                background: rgba(255,255,255,0.03);
            }

            .job-title {
                font-weight: 600;
            }

            .bio {
                max-width: 250px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .badge {
                padding: 4px 10px;
                border-radius: 999px;
                font-size: 12px;
            }

            .badge.active {
                background: rgba(34,197,94,0.2);
                color: #22c55e;
            }

            .badge.inactive {
                background: rgba(239,68,68,0.2);
                color: #ef4444;
            }

            .badge.dept {
                background: rgba(59,130,246,0.2);
                color: #3b82f6;
            }

            .actions a {
                margin-right: 10px;
                text-decoration: none;
            }

            .btn-edit {
                color: #60a5fa;
            }

            .btn-delete {
                color: #f87171;
            }
        </style>
    </head>
    <body class="app-page">
        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container" style="margin-top: 30px;">


                <!-- Job List -->
                <div class="job-list-container">

                    <div class="jobs-grid">
                        <div class="glass-card recruiter-card">
                            <div class="card-header">
                                <h2>Recruiter Management</h2>
                                <a class="btn-add" href="${pageContext.request.contextPath}/admin/recruiters?action=create">+ Add Recruiter</a>
                            </div>

                            <table class="recruiter-table">
                                <thead>
                                    <tr>
                                        <th>No</th>
                                        <th>Job</th>
                                        <th>Company</th>
                                        <th>Department</th>
                                        <th>Bio</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="r" items="${list}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td> <!-- STT bắt đầu từ 1 -->

                                            <td>
                                                <div class="job-title">${r.jobTitle}</div>
                                            </td>

                                            <td>${r.companyName}</td>

                                            <td>
                                                <span class="badge dept">${r.departmentName}</span>
                                            </td>

                                            <td class="bio">
                                                ${r.bio}
                                            </td>

                                            <td>
                                                <span class="badge ${r.status == 'ACTIVE' ? 'active' : 'inactive'}">
                                                    ${r.status}
                                                </span>
                                            </td>

                                            <td class="actions">
                                                <c:if test="${r.status == 'ACTIVE'}">
                                                <a class="btn-edit" href="recruiters?action=edit&id=${r.recruiterId}">Edit</a>
                                                <a class="btn-delete" href="recruiters?action=delete&id=${r.recruiterId}"
                                                   onclick="return confirm('Delete this recruiter?')">Delete</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>


                </div>
            </div>
        </main>

        <script src="${pageContext.request.contextPath}/js/main.js"></script>
    </body>
</html>
