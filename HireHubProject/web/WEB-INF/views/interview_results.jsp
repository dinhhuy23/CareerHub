<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả ứng tuyển - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .results-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .result-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        
        .result-card:hover {
            transform: translateY(-5px);
        }
        
        /* Hiệu ứng nền cho thẻ Pass */
        .result-card.pass {
            border-left: 6px solid #10B981;
            background: linear-gradient(90deg, rgba(16, 185, 129, 0.05) 0%, var(--bg-secondary) 100%);
        }
        
        /* Hiệu ứng nền cho thẻ Fail */
        .result-card.fail {
            border-left: 6px solid #EF4444;
            background: linear-gradient(90deg, rgba(239, 68, 68, 0.05) 0%, var(--bg-secondary) 100%);
        }

        .company-info {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .company-logo {
            width: 70px;
            height: 70px;
            border-radius: 16px;
            background: var(--bg-tertiary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--primary);
            border: 1px solid var(--border-color);
        }

        .job-details h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 6px;
        }

        .company-name {
            font-size: 1rem;
            color: var(--primary);
            font-weight: 600;
            margin-bottom: 12px;
        }

        .result-badge {
            padding: 10px 24px;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .badge-pass {
            background: #10B981;
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .badge-fail {
            background: #374151;
            color: #9CA3AF;
            border: 1px solid #4B5563;
        }

        .badge-round2 {
            background: #6366F1;
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        .interview-info-card {
            background: rgba(99, 102, 241, 0.05);
            border: 1px solid rgba(99, 102, 241, 0.2);
            border-radius: 12px;
            padding: 16px;
            margin-top: 16px;
        }
        .info-row { display: flex; gap: 10px; margin-bottom: 8px; font-size: 0.95rem; }
        .info-label { font-weight: 700; color: #6366F1; min-width: 100px; }
        .info-value { color: var(--text-primary); }

        .result-meta {
            text-align: right;
        }

        .update-date {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-top: 10px;
        }

        .empty-state {
            text-align: center;
            padding: 100px 20px;
            background: var(--bg-secondary);
            border-radius: 24px;
            border: 1px dashed var(--border-color);
        }
        
        /* Ghi chú từ HR */
        .hr-feedback {
            margin-top: 15px;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 10px;
            font-size: 0.9rem;
            color: var(--text-secondary);
            font-style: italic;
            border-left: 3px solid var(--border-color);
        }

        /* Modal Offer Letter */
        .modal {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.8); backdrop-filter: blur(8px);
            display: none; align-items: center; justify-content: center; z-index: 9999;
        }
        .modal.active { display: flex; }
        .modal-content {
            background: white; color: #1f2937; width: 100%; max-width: 700px;
            padding: 50px; border-radius: 24px; position: relative;
            max-height: 90vh; overflow-y: auto; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
        }
        .offer-header { border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 30px; text-align: center; }
        .offer-body { line-height: 1.8; font-size: 1.05rem; }
        .offer-footer { margin-top: 40px; padding-top: 20px; border-top: 1px solid #f3f4f6; display: flex; justify-content: space-between; align-items: center; }

        /* Checklist */
        .checklist-container {
            margin-top: 20px; padding: 20px; background: rgba(16, 185, 129, 0.05);
            border: 1px dashed #10B981; border-radius: 12px;
        }
        .checklist-title { font-size: 0.9rem; font-weight: 700; color: #10B981; margin-bottom: 12px; text-transform: uppercase; }
        .checklist-item { display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 8px; }
        .checklist-item input { accent-color: #10B981; width: 16px; height: 16px; }

        .btn-view-offer {
            background: white; color: #10B981; border: 1.5px solid #10B981;
            padding: 8px 20px; border-radius: 10px; font-weight: 700; cursor: pointer;
            transition: all 0.2s; margin-top: 15px; display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-view-offer:hover { background: #10B981; color: white; }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp results-container">
            
            <div style="margin-bottom: 40px; text-align: center;">
                <h1 style="font-size: 2.5rem; font-weight: 800; color: var(--text-primary); margin-bottom: 12px;">Kết quả tuyển dụng</h1>
                <p style="color: var(--text-secondary); font-size: 1.1rem;">
                    Nơi lưu giữ những cột mốc quan trọng trong sự nghiệp của bạn.
                </p>
            </div>

            <c:choose>
                <c:when test="${empty results}">
                    <div class="empty-state">
                        <svg width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1">
                            <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                        </svg>
                        <h2 style="margin-top: 20px; color: var(--text-primary);">Chưa có kết quả chính thức</h2>
                        <p style="color: var(--text-secondary); margin-top: 10px;">Các đơn ứng tuyển của bạn đang trong quá trình xét duyệt.</p>
                        <a href="${pageContext.request.contextPath}/user/my-applications" class="btn btn-outline" style="margin-top: 30px;">Kiểm tra tiến độ</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="app" items="${results}">
                        <div class="result-card ${app.status == 'OFFERED' ? 'pass' : 'fail'}">
                            <div class="company-info">
                                <div class="company-logo">
                                    ${app.companyName != null ? app.companyName.substring(0,1).toUpperCase() : 'C'}
                                </div>
                                <div class="job-details" style="flex: 1;">
                                    <h3>${app.jobTitle}</h3>
                                    <div class="company-name">${app.companyName}</div>
                                    
                                    <%-- TRƯỜNG HỢP: PHỎNG VẤN VÒNG 2 (PASS VÒNG 1) --%>
                                    <c:if test="${app.status == 'INTERVIEW_ROUND_2'}">
                                        <c:set var="inter" value="${interviews[app.applicationId]}" />
                                        <div class="interview-info-card animate-fadeInUp">
                                            <div style="font-weight: 800; color: #6366F1; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                                LỊCH PHỎNG VẤN TRỰC TIẾP (VÒNG 2)
                                            </div>
                                            
                                            <div class="info-row">
                                                <div class="info-label">Thời gian:</div>
                                                <div class="info-value" style="font-weight: 700;">
                                                    <fmt:formatDate value="${inter.startAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                            </div>
                                            <div class="info-row">
                                                <div class="info-label">Địa điểm:</div>
                                                <div class="info-value">${inter.locationText}</div>
                                            </div>
                                            <c:if test="${not empty inter.note}">
                                                <div class="info-row" style="flex-direction: column; gap: 4px; margin-top: 8px; padding-top: 8px; border-top: 1px dashed rgba(99, 102, 241, 0.2);">
                                                    <div class="info-label">Yêu cầu chuẩn bị:</div>
                                                    <div class="info-value" style="background: white; padding: 10px; border-radius: 8px; font-style: italic;">
                                                        ${inter.note}
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:if>

                                    <c:if test="${app.status == 'OFFERED'}">
                                        <button class="btn-view-offer" 
                                                onclick="openOfferModal('${app.jobTitle}', '${app.companyName}', '${sessionScope.userFullName}')">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                                <polyline points="14 2 14 8 20 8"></polyline>
                                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                                <line x1="16" y1="17" x2="8" y2="17"></line>
                                            </svg>
                                            Xem thư mời làm việc
                                        </button>

                                        <%-- Onboarding Checklist --%>
                                        <div class="checklist-container">
                                            <div class="checklist-title">Các bước chuẩn bị nhận việc:</div>
                                            <div class="checklist-item"><input type="checkbox"> Gửi bản sao CCCD/Hộ chiếu</div>
                                            <div class="checklist-item"><input type="checkbox"> Cập nhật thông tin số tài khoản ngân hàng</div>
                                            <div class="checklist-item"><input type="checkbox"> Khám sức khỏe định kỳ (nếu yêu cầu)</div>
                                            <div class="checklist-item"><input type="checkbox"> Chuẩn bị hồ sơ giấy (vào ngày đầu đi làm)</div>
                                        </div>
                                    </c:if>

                                    <%-- Hiển thị ghi chú từ nhà tuyển dụng nếu có --%>
                                    <c:if test="${not empty app.hrNote}">
                                        <div class="hr-feedback">
                                            " ${app.hrNote} "
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="result-meta">
                                <c:choose>
                                    <c:when test="${app.status == 'OFFERED'}">
                                        <div class="result-badge badge-pass">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                                <polyline points="20 6 9 17 4 12"></polyline>
                                            </svg>
                                            TRÚNG TUYỂN (PASS)
                                        </div>
                                    </c:when>
                                    <c:when test="${app.status == 'INTERVIEW_ROUND_2'}">
                                        <div class="result-badge badge-round2">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                                <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline>
                                            </svg>
                                            PASS VÒNG 1
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="result-badge badge-fail">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                                <line x1="6" y1="6" x2="18" y2="18"></line>
                                            </svg>
                                            KHÔNG PHÙ HỢP (FAIL)
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="update-date">
                                    Ngày cập nhật: <fmt:formatDate value="${app.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <%-- Component Phân trang --%>
                    <jsp:include page="/WEB-INF/views/components/pagination.jsp">
                        <jsp:param name="currentPage" value="${currentPage}" />
                        <jsp:param name="totalPages" value="${totalPages}" />
                        <jsp:param name="actionUrl" value="${pageContext.request.contextPath}/user/interview-results" />
                    </jsp:include>
                </c:otherwise>
            </c:choose>

        </div>
    </main>

    <!-- Modal Xem Thư Mời -->
    <div id="offerModal" class="modal">
        <div class="modal-content animate-fadeInUp">
            <button onclick="closeOfferModal()" style="position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
            <div class="offer-header">
                <h2 style="color: #10B981; font-weight: 800; font-size: 1.8rem;">JOB OFFER LETTER</h2>
                <p id="modalCompanyName" style="font-weight: 600; color: #4B5563;"></p>
            </div>
            <div class="offer-body">
                <p>Thân chào <strong><span id="modalCandidateName"></span></strong>,</p>
                <p>Chúng tôi rất vui mừng thông báo rằng bạn đã vượt qua các vòng phỏng vấn và chính thức nhận được lời mời làm việc cho vị trí <strong><span id="modalJobTitle"></span></strong> tại công ty chúng tôi.</p>
                <p>Chúng tôi đánh giá cao kỹ năng và kinh nghiệm của bạn và tin rằng bạn sẽ là một mảnh ghép tuyệt vời cho đội ngũ của chúng tôi. Dưới đây là tóm tắt các thông tin sơ bộ:</p>
                <ul style="margin-left: 20px; margin-top: 15px;">
                    <li><strong>Vị trí:</strong> <span id="modalJobTitleDetail"></span></li>
                    <li><strong>Mức lương dự kiến:</strong> Thỏa thuận theo chính sách công ty (sẽ chi tiết trong hợp đồng)</li>
                    <li><strong>Ngày bắt đầu:</strong> Trong vòng 2 tuần kể từ ngày xác nhận</li>
                    <li><strong>Địa điểm:</strong> Văn phòng chính của công ty</li>
                </ul>
                <p style="margin-top: 20px;">Vui lòng xác nhận sự đồng ý của bạn bằng cách phản hồi lại hệ thống hoặc liên hệ trực tiếp với bộ phận nhân sự.</p>
            </div>
            <div class="offer-footer">
                <div>
                    <p style="font-weight: 700;">HireHub Recruitment Team</p>
                    <p style="font-size: 0.8rem; color: #9CA3AF;">Document ID: #OFFER-${System.currentTimeMillis()}</p>
                </div>
                <button onclick="window.print()" class="btn btn-outline" style="padding: 8px 16px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 5px;"><path d="M6 9V2h12v7"></path><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                    In thư mời
                </button>
            </div>
        </div>
    </div>

    <script>
        function openOfferModal(job, company, candidate) {
            document.getElementById('modalJobTitle').innerText = job;
            document.getElementById('modalJobTitleDetail').innerText = job;
            document.getElementById('modalCompanyName').innerText = company;
            document.getElementById('modalCandidateName').innerText = candidate;
            document.getElementById('offerModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeOfferModal() {
            document.getElementById('offerModal').classList.remove('active');
            document.body.style.overflow = 'auto';
        }

        // Đóng modal khi click ra ngoài
        window.onclick = function(event) {
            const modal = document.getElementById('offerModal');
            if (event.target == modal) {
                closeOfferModal();
            }
        }
    </script>
</body>
</html>
