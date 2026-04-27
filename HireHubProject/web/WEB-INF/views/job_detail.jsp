<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${job.title} - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .job-detail-layout {
            display: grid;
            grid-template-columns: minmax(0, 2fr) minmax(320px, 1fr);
            gap: var(--space-xl);
            align-items: start;
        }

        .job-content-wrap,
        .job-sidebar {
            min-width: 0;
        }

        .job-sidebar {
            position: relative;
        }

        .job-sidebar-card {
            position: relative;
            z-index: 1;
            overflow: hidden;
        }

        @media (max-width: 992px) {
            .job-detail-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">

            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline" style="margin-bottom: var(--space-xl); padding: 8px 16px; display: inline-flex; border-radius: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 6px;">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Quay lại
            </a>

            <c:if test="${param.success == 'applied'}">
                <div class="alert alert-success animate-fadeInUp">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    Bạn đã nộp đơn ứng tuyển thành công! Nhà tuyển dụng sẽ xem xét và phản hồi sớm.
                </div>
            </c:if>

            <c:if test="${param.error == 'already_applied'}">
                <div class="alert alert-error animate-fadeInUp">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    Bạn đã nộp đơn cho công việc này trước đó rồi.
                </div>
            </c:if>

            <c:if test="${param.success == 'reported'}">
                <div class="alert alert-success animate-fadeInUp">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    Bạn đã gửi báo cáo thành công! Chúng tôi sẽ xem xét sớm.
                </div>
            </c:if>

            <!-- Job Header -->
            <div class="glass-card animate-fadeInUp" style="padding: var(--space-2xl); margin-bottom: var(--space-xl); position: relative; overflow: hidden; display: flex; gap: 32px; align-items: center; flex-wrap: wrap;">
                <div style="position: absolute; right: -50px; top: -50px; width: 200px; height: 200px; background: var(--primary); filter: blur(60px); opacity: 0.15; border-radius: 50%;"></div>

                <div style="width: 120px; height: 120px; background: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: 20px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; box-shadow: 0 4px 12px rgba(0,0,0,0.3);">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="1.5">
                        <rect x="4" y="4" width="16" height="16" rx="2" ry="2"></rect>
                        <rect x="9" y="9" width="6" height="6"></rect>
                        <line x1="9" y1="1" x2="9" y2="4"></line>
                        <line x1="15" y1="1" x2="15" y2="4"></line>
                        <line x1="9" y1="20" x2="9" y2="23"></line>
                        <line x1="15" y1="20" x2="15" y2="23"></line>
                        <line x1="20" y1="9" x2="23" y2="9"></line>
                        <line x1="20" y1="14" x2="23" y2="14"></line>
                        <line x1="1" y1="9" x2="4" y2="9"></line>
                        <line x1="1" y1="14" x2="4" y2="14"></line>
                    </svg>
                </div>

                <div class="job-header-info" style="flex: 1; min-width: 300px;">
                    <h1 style="font-size: 2.2rem; font-weight: 800; margin-bottom: 8px; color: var(--text-primary);">${job.title}</h1>

                    <div style="font-size: 1.25rem; font-weight: 600; color: var(--primary); margin-bottom: 20px;">
                        <c:if test="${job.companyId != null}">
                            <a href="${pageContext.request.contextPath}/jobs" style="text-decoration: none; color: inherit; display: inline-flex; align-items: center; gap: 8px;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                </svg>
                                ${job.companyName != null ? job.companyName : job.employerName}
                            </a>
                        </c:if>
                        <c:if test="${job.companyId == null}">
                            ${job.companyName != null ? job.companyName : job.employerName}
                        </c:if>
                    </div>

                    <div style="display: flex; align-items: center; gap: 24px; flex-wrap: wrap;">
                        <span class="text-secondary" style="display: flex; align-items: center; gap: 6px; font-weight: 500;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            Hạn nộp: <span class="text-primary"><fmt:formatDate value="${job.deadlineAt}" pattern="dd/MM/yyyy"/></span>
                        </span>

                        <span class="text-secondary" style="display: flex; align-items: center; gap: 6px; font-weight: 500;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                            ${job.viewCount} lượt xem
                        </span>

                        <c:if test="${job.status == 'CLOSED'}">
                            <span class="badge" style="background: rgba(239, 68, 68, 0.15); color: var(--error); padding: 6px 12px; border-radius: 6px;">
                                Tin đã đóng
                            </span>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- 2-Column Layout -->
            <div class="job-detail-layout">

                <!-- Main Job Content -->
                <div class="job-content-wrap glass-card animate-fadeInUp" style="animation-delay: 0.1s; padding: var(--space-2xl);">
                    <div style="margin-bottom: var(--space-2xl);">
                        <h3 style="font-size: 1.35rem; font-weight: 700; color: var(--text-primary); margin-bottom: 16px; display: flex; align-items: center; border-bottom: 2px solid var(--bg-primary); padding-bottom: 10px;">
                            <div style="width: 4px; height: 20px; background: var(--primary); margin-right: 12px; border-radius: 4px;"></div>
                            Mô tả công việc
                        </h3>
                        <div class="rich-text" style="color: var(--text-secondary); line-height: 1.8; font-size: 1.05rem; white-space: pre-wrap;">${job.description}</div>
                    </div>

                    <div style="margin-bottom: var(--space-2xl);">
                        <h3 style="font-size: 1.35rem; font-weight: 700; color: var(--text-primary); margin-bottom: 16px; display: flex; align-items: center; border-bottom: 2px solid var(--bg-primary); padding-bottom: 10px;">
                            <div style="width: 4px; height: 20px; background: var(--warning); margin-right: 12px; border-radius: 4px;"></div>
                            Yêu cầu ứng viên
                        </h3>
                        <div class="rich-text" style="color: var(--text-secondary); line-height: 1.8; font-size: 1.05rem; white-space: pre-wrap;">${job.requirements}</div>
                    </div>

                    <c:if test="${not empty job.responsibilities}">
                        <div style="margin-bottom: var(--space-md);">
                            <h3 style="font-size: 1.35rem; font-weight: 700; color: var(--text-primary); margin-bottom: 16px; display: flex; align-items: center; border-bottom: 2px solid var(--bg-primary); padding-bottom: 10px;">
                                <div style="width: 4px; height: 20px; background: var(--success); margin-right: 12px; border-radius: 4px;"></div>
                                Quyền lợi được hưởng
                            </h3>
                            <div class="rich-text" style="color: var(--text-secondary); line-height: 1.8; font-size: 1.05rem; white-space: pre-wrap;">${job.responsibilities}</div>
                        </div>
                    </c:if>
                </div>

                <!-- Right Sidebar -->
                <div class="job-sidebar animate-fadeInUp" style="animation-delay: 0.2s;">

                    <!-- Apply/Salary Box -->
                    <div class="glass-card job-sidebar-card" style="padding: var(--space-xl); margin-bottom: var(--space-xl);">
                        <div style="text-align: center; margin-bottom: var(--space-xl); padding-bottom: var(--space-lg); border-bottom: 1px dashed var(--border-color);">
                            <div style="font-size: 0.95rem; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 1px; font-weight: 600;">
                                Thu nhập hấp dẫn
                            </div>

                            <c:choose>
                                <c:when test="${job.salaryMax != null}">
                                    <div class="text-success" style="font-size: 1.8rem; font-weight: 800; line-height: 1.2;">
                                        <fmt:formatNumber value="${job.salaryMin}" maxFractionDigits="0" /> -
                                        <fmt:formatNumber value="${job.salaryMax}" maxFractionDigits="0" />
                                        <div style="font-size: 1rem; color: var(--text-secondary); font-weight: 500;">
                                            ${job.currencyCode} / tháng
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-success" style="font-size: 1.8rem; font-weight: 800;">Thỏa thuận</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${sessionScope.userRole == 'CANDIDATE'}">
                            <button id="btnOpenApply" onclick="openApplyModal()" class="btn btn-full" style="background: linear-gradient(135deg, var(--success), #059669); color: white; border: none; font-size: 1.1rem; padding: 16px; margin-bottom: 12px; box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;">
                                Ứng tuyển ngay
                            </button>

                            <button id="btnSaveJob" onclick="toggleSaveJob(${job.jobId})" class="btn ${isSaved ? 'btn-outline' : 'btn-primary'} btn-full" style="padding: 14px; font-weight: 600;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="${isSaved ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="2" style="margin-right: 8px; vertical-align: -4px;">
                                    <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                </svg>
                                <span id="saveJobText">${isSaved ? 'Đã lưu việc làm' : 'Lưu việc làm này'}</span>
                            </button>

                            <button onclick="openReportModal()" 
                                    class="btn btn-outline btn-full" 
                                    style="padding: 12px; margin-top: 12px; font-weight: 600; color: #ff6b6b;">
                                🚨 Báo cáo tin này
                            </button>
                        </c:if>

                        <c:if test="${empty sessionScope.userRole}">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-full" style="padding: 14px; font-weight: 600;">
                                Đăng nhập để ứng tuyển
                            </a>
                        </c:if>

                        <c:if test="${sessionScope.userRole == 'RECRUITER' && sessionScope.userId == job.postedByRecruiterId}">
                            <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-outline btn-full" style="padding: 14px;">
                                Quản lý tin đăng
                            </a>
                        </c:if>
                    </div>

                    <!-- Overview Box -->
                    <div class="glass-card job-sidebar-card" style="padding: var(--space-xl);">
                        <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: var(--space-lg); border-bottom: 1px solid var(--border-color); padding-bottom: 12px;">
                            Tổng quan
                        </h3>

                        <div style="display: flex; flex-direction: column; gap: 20px;">

                            <div style="display: flex; align-items: flex-start; gap: 16px;">
                                <div style="background: rgba(148, 163, 184, 0.1); padding: 10px; border-radius: 50%; color: var(--primary-light);">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                </div>
                                <div>
                                    <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 2px;">Địa điểm làm việc</div>
                                    <div style="font-weight: 600; color: var(--text-primary); line-height: 1.4;">
                                        ${job.locationName} <c:if test="${not empty job.addressDetail}">- ${job.addressDetail}</c:if>
                                    </div>
                                </div>
                            </div>

                            <div style="display: flex; align-items: flex-start; gap: 16px;">
                                <div style="background: rgba(148, 163, 184, 0.1); padding: 10px; border-radius: 50%; color: var(--info);">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                                        <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                                        <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
                                    </svg>
                                </div>
                                <div>
                                    <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 2px;">Ngành nghề</div>
                                    <div style="font-weight: 600; color: var(--text-primary);">${job.categoryName != null ? job.categoryName : 'Khác'}</div>
                                </div>
                            </div>

                            <div style="display: flex; align-items: flex-start; gap: 16px;">
                                <div style="background: rgba(148, 163, 184, 0.1); padding: 10px; border-radius: 50%; color: var(--warning);">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 2px;">Kinh nghiệm</div>
                                    <div style="font-weight: 600; color: var(--text-primary);">${job.experienceLevelName}</div>
                                </div>
                            </div>

                            <div style="display: flex; align-items: flex-start; gap: 16px;">
                                <div style="background: rgba(148, 163, 184, 0.1); padding: 10px; border-radius: 50%; color: var(--success);">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                                        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                                    </svg>
                                </div>
                                <div>
                                    <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 2px;">Hình thức</div>
                                    <div style="font-weight: 600; color: var(--text-primary);">${job.employmentTypeName}</div>
                                </div>
                            </div>

                            <c:if test="${job.vacancyCount != null && job.vacancyCount > 0}">
                                <div style="display: flex; align-items: flex-start; gap: 16px;">
                                    <div style="background: rgba(148, 163, 184, 0.1); padding: 10px; border-radius: 50%; color: var(--secondary);">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 2px;">Số lượng tuyển</div>
                                        <div style="font-weight: 600; color: var(--text-primary);">${job.vacancyCount} người</div>
                                    </div>
                                </div>
                            </c:if>

                        </div>
                    </div>

                </div>
            </div>

        </div>
    </main>

    <!-- Apply Modal -->
    <div id="applyModal" class="modal-backdrop" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
        <div class="glass-card animate-fadeInUp" style="width: 100%; max-width: 500px; padding: var(--space-2xl); position: relative;">
            <button onclick="closeApplyModal()" style="position: absolute; top: 20px; right: 20px; background: none; border: none; cursor: pointer; color: var(--text-muted);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>

            <h2 style="font-size: 1.5rem; font-weight: 800; margin-bottom: var(--space-lg); color: var(--text-primary);">Ứng tuyển công việc</h2>
            <p style="color: var(--text-secondary); margin-bottom: var(--space-xl); font-size: 0.95rem;">
                Chào <strong>${sessionScope.userFullName}</strong>, hãy gửi thông tin để nhà tuyển dụng xem xét nhé.
            </p>

            <form action="${pageContext.request.contextPath}/job/apply" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="jobId" value="${job.jobId}">

                <div class="form-group" style="margin-bottom: var(--space-xl);">
                    <label style="font-weight: 600; margin-bottom: 8px; display: block;">
                        Tải lên CV (PDF) <span style="color:var(--error)">*</span>
                    </label>
                    <input type="file" name="cvFile" accept=".pdf,application/pdf" required class="form-control" style="width: 100%; border: 2px dashed var(--border-color); padding: 20px 10px; text-align: center; background: rgba(59, 130, 246, 0.05); cursor: pointer;">
                    <small style="color: var(--text-muted); margin-top: 8px; display: block;">Định dạng hỗ trợ: PDF (Tối đa 10MB)</small>
                </div>

                <div class="form-group" style="margin-bottom: var(--space-xl);">
                    <label style="font-weight: 600; margin-bottom: 8px; display: block;">Thư giới thiệu (Cover Letter)</label>
                    <textarea name="coverLetter" rows="4" placeholder="Giới thiệu ngắn về bản thân và tại sao bạn phù hợp..." class="form-control" style="width: 100%; resize: none;"></textarea>
                </div>

                <div style="display: flex; gap: 12px;">
                    <button type="button" onclick="closeApplyModal()" class="btn btn-outline" style="flex: 1;">Hủy</button>
                    <button type="submit" class="btn btn-primary" style="flex: 1;">Gửi đơn ứng tuyển</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Report Modal -->
    <div id="reportModal" class="modal-backdrop" style="display:none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
        <div class="glass-card" style="width:100%; max-width:500px; padding:20px; position:relative;">
            <button onclick="closeReportModal()" 
                    style="position:absolute; top:15px; right:15px; background:none; border:none; cursor: pointer; color: var(--text-muted);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
            <h2 style="font-size: 1.5rem; font-weight: 800; margin-bottom: var(--space-lg); color: var(--text-primary);">Báo cáo công việc</h2>
            <form action="${pageContext.request.contextPath}/report" method="post">
                <input type="hidden" name="action" value="create"/>
                <input type="hidden" name="targetType" value="JOB"/>
                <input type="hidden" name="targetId" value="${job.jobId}"/>
                
                <div class="form-group" style="margin-bottom: var(--space-xl);">
                    <label style="font-weight: 600; margin-bottom: 8px; display: block;">Lý do báo cáo</label>
                    <select name="reportTypeId" required class="form-control" style="width:100%;">
                        <c:forEach var="rt" items="${reportTypes}">
                            <option value="${rt.reportTypeId}">${rt.reportName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group" style="margin-bottom: var(--space-xl);">
                    <label style="font-weight: 600; margin-bottom: 8px; display: block;">Nội dung chi tiết</label>
                    <textarea name="content" rows="4" class="form-control" style="width:100%; resize: none;"></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary btn-full" style="padding: 14px;">Gửi báo cáo</button>
            </form>
        </div>
    </div>

    <script>
        function openReportModal() {
            document.getElementById('reportModal').style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }

        function closeReportModal() {
            document.getElementById('reportModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function openApplyModal() {
            document.getElementById('applyModal').style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }

        function closeApplyModal() {
            document.getElementById('applyModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function toggleSaveJob(jobId) {
            const btn = document.getElementById('btnSaveJob');
            const isSaved = btn.classList.contains('btn-outline');
            const action = isSaved ? 'unsave' : 'save';

            btn.style.opacity = '0.7';
            btn.style.pointerEvents = 'none';

            fetch('${pageContext.request.contextPath}/user/save-job', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'jobId=' + jobId + '&action=' + action
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    if (action === 'save') {
                        btn.classList.remove('btn-primary');
                        btn.classList.add('btn-outline');
                        btn.querySelector('svg').setAttribute('fill', 'currentColor');
                        document.getElementById('saveJobText').innerText = 'Đã lưu việc làm';
                    } else {
                        btn.classList.remove('btn-outline');
                        btn.classList.add('btn-primary');
                        btn.querySelector('svg').setAttribute('fill', 'none');
                        document.getElementById('saveJobText').innerText = 'Lưu việc làm';
                    }
                } else {
                    alert('Có lỗi xảy ra: ' + data.message);
                }
            })
            .catch(error => console.error('Error:', error))
            .finally(() => {
                btn.style.opacity = '1';
                btn.style.pointerEvents = 'auto';
            });
        }
    </script>
</body>
</html>