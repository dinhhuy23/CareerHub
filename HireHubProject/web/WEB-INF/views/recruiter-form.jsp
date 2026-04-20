<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Recruiter Form - HireHub</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .form-card {
                padding: 28px;
                border-radius: 16px;
            }

            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group.full {
                grid-column: span 2;
            }

            .form-group label {
                margin-bottom: 6px;
                font-size: 14px;
                opacity: 0.7;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                padding: 10px 12px;
                border-radius: 8px;
                border: none;
                background: var(--bg-input);
                color: white;
            }

            .form-group input:disabled {
                opacity: 0.6;
            }

            .form-actions {
                margin-top: 24px;
                display: flex;
                gap: 12px;
            }

            .btn-submit {
                background: linear-gradient(135deg, #6c63ff, #4f46e5);
                color: white;
                padding: 10px 18px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
            }

            .btn-cancel {
                padding: 10px 18px;
                border-radius: 8px;
                text-decoration: none;
                background: rgba(255,255,255,0.1);
                color: white;
            }

            .btn-back {
                text-decoration: none;
                color: #a5b4fc;
            }
        </style>
    </head>

    <body class="app-page">

        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container" style="margin-top: 30px;">

                <div class="glass-card form-card">

                    <!-- HEADER -->
                    <div class="card-header">
                        <h2>
                            <c:choose>
                                <c:when test="${recruiter != null}">
                                    Sửa Nhà Tuyển Dụng
                                </c:when>
                                <c:otherwise>
                                    Thêm Nhà Tuyển Dụng
                                </c:otherwise>
                            </c:choose>
                        </h2>
                    </div>

                    <c:if test="${not empty error}">
                        <div style="color:red; margin-bottom:10px;">
                            ${error}
                        </div>
                    </c:if>

                    <!-- FORM -->
                    <form action="${pageContext.request.contextPath}/admin/recruiters" method="post">

                        <input type="hidden" name="id" value="${recruiter.recruiterId}" />

                        <div class="form-grid">

                            <c:choose>

                                <c:when test="${recruiter == null}">

                                    <div class="form-group">
                                        <label>Email</label>
                                        <input type="email" name="email" maxlength="255" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Full Name</label>
                                        <input type="text" name="fullName" max="150" required>
                                    </div>

                                </c:when>

                            </c:choose>

                            <!-- Job Title -->
                            <div class="form-group full">
                                <label>Job Title</label>
                                <input type="text" name="jobTitle"
                                       value="${recruiter.jobTitle}"
                                       placeholder="Enter job title..." maxlength="150" required>
                            </div>

                            <!-- ===== COMPANY DROPDOWN ===== -->
                            <div class="form-group">
                                <label>Company</label>
                                <select name="companyId" required id="companySelect">
                                    <c:forEach var="c" items="${companies}">
                                        <option value="${c.companyId}"
                                                ${c.companyId == recruiter.companyId ? 'selected' : ''}>
                                            ${c.companyName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- ===== DEPARTMENT DROPDOWN ===== -->
                            <div class="form-group">
                                <label>Department</label>
                                <select name="departmentId" id="departmentSelect">
                                    <option value="">-- Select Department --</option>

                                </select>
                            </div>

                            <!-- Bio -->
                            <div class="form-group full">
                                <label>Bio</label>
                                <textarea name="bio" rows="4"
                                          placeholder="Enter description..." maxlength="1000">${recruiter.bio}</textarea>
                            </div>

                        </div>

                        <!-- ACTION -->
                        <div class="form-actions">
                            <button type="submit" class="btn-submit">
                                Save
                            </button>

                            <a href="${pageContext.request.contextPath}/admin/recruiters"
                               class="btn-cancel">
                                Cancel
                            </a>
                        </div>

                    </form>
                </div>

            </div>
        </main>
        <script>
            const selectedDepartmentId = "${recruiter.departmentId}";
            document.getElementById("companySelect").addEventListener("change", function () {
                const companyId = this.value;

                fetch("/HireHubProject/getDepartmentsByCompany?companyId=" + companyId)
                        .then(res => res.json())
                        .then(data => {
                            const deptSelect = document.getElementById("departmentSelect");
                            deptSelect.innerHTML = '<option value="">-- Select Department --</option>';

                            data.forEach(d => {
                                const option = document.createElement("option");
                                option.value = d.departmentId;
                                option.textContent = d.departmentName;

                                // set selected nếu trùng
                                if (d.departmentId == selectedDepartmentId) {
                                    option.selected = true;
                                }

                                deptSelect.appendChild(option);
                            });
                        });
            });
            window.onload = function () {
                const companyId = document.getElementById("companySelect").value;
                if (companyId) {
                    document.getElementById("companySelect").dispatchEvent(new Event("change"));
                }
            }
        </script>
    </body>
</html>