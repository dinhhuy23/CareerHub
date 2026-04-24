<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%-- 
    ========================================================
    COMPONENT PHÂN TRANG CHUNG (SHARED PAGINATION COMPONENT)
    ========================================================
    Cách sử dụng (Include vào trang cần dùng):
    
    <jsp:include page="/WEB-INF/views/components/pagination.jsp">
        <jsp:param name="currentPage" value="${currentPage}" />
        <jsp:param name="totalPages" value="${totalPages}" />
        <jsp:param name="actionUrl" value="${pageContext.request.contextPath}/du-duong-dan?search=abc&status=1" />
    </jsp:include>
--%>

<c:set var="currentPage" value="${empty param.currentPage ? 1 : param.currentPage}" />
<c:set var="totalPages" value="${empty param.totalPages ? 1 : param.totalPages}" />
<c:set var="actionUrl" value="${param.actionUrl}" />

<%-- Xử lý URL: Nếu URL đã có tham số (?) thì thêm '&', nếu chưa có thì dùng '?' --%>
<c:set var="separator" value="${actionUrl.contains('?') ? '&' : '?'}" />

<c:if test="${totalPages > 1}">
    <div class="pagination-container" style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 32px; flex-wrap: wrap;">
        
        <%-- Nút Previous --%>
        <c:if test="${currentPage > 1}">
            <a href="${actionUrl}${separator}page=${currentPage - 1}" class="page-link page-nav" title="Trang trước" style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 10px; background: var(--bg-secondary); border: 1px solid var(--border-color); color: var(--text-primary); text-decoration: none; transition: all 0.2s;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"></polyline></svg>
            </a>
        </c:if>

        <%-- Các trang số --%>
        <c:forEach begin="1" end="${totalPages}" var="i">
            <%-- Logic hiển thị rút gọn (Ellipsis) nếu số lượng trang quá nhiều (>7) --%>
            <c:choose>
                <c:when test="${totalPages <= 7}">
                    <%-- Hiển thị tất cả nếu <= 7 trang --%>
                    <a href="${actionUrl}${separator}page=${i}" class="page-link ${i == currentPage ? 'active' : ''}" style="display: flex; align-items: center; justify-content: center; min-width: 40px; height: 40px; padding: 0 10px; border-radius: 10px; font-weight: 600; font-size: 0.95rem; text-decoration: none; transition: all 0.2s; ${i == currentPage ? 'background: var(--primary); color: white; border: none; box-shadow: 0 4px 12px rgba(99,102,241,0.3);' : 'background: var(--bg-secondary); border: 1px solid var(--border-color); color: var(--text-primary);'}">
                        ${i}
                    </a>
                </c:when>
                <c:otherwise>
                    <%-- Hiển thị rút gọn: Chỉ hiện trang 1, trang cuối, và các trang xung quanh trang hiện tại --%>
                    <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)}">
                        <a href="${actionUrl}${separator}page=${i}" class="page-link ${i == currentPage ? 'active' : ''}" style="display: flex; align-items: center; justify-content: center; min-width: 40px; height: 40px; padding: 0 10px; border-radius: 10px; font-weight: 600; font-size: 0.95rem; text-decoration: none; transition: all 0.2s; ${i == currentPage ? 'background: var(--primary); color: white; border: none; box-shadow: 0 4px 12px rgba(99,102,241,0.3);' : 'background: var(--bg-secondary); border: 1px solid var(--border-color); color: var(--text-primary);'}">
                            ${i}
                        </a>
                    </c:if>
                    <%-- In dấu 3 chấm --%>
                    <c:if test="${(i == 2 && currentPage > 3) || (i == totalPages - 1 && currentPage < totalPages - 2)}">
                        <span style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; color: var(--text-muted); font-weight: 600;">...</span>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <%-- Nút Next --%>
        <c:if test="${currentPage < totalPages}">
            <a href="${actionUrl}${separator}page=${currentPage + 1}" class="page-link page-nav" title="Trang sau" style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 10px; background: var(--bg-secondary); border: 1px solid var(--border-color); color: var(--text-primary); text-decoration: none; transition: all 0.2s;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
            </a>
        </c:if>
        
    </div>

    <style>
        .page-link:not(.active):hover {
            border-color: var(--primary) !important;
            color: var(--primary) !important;
            transform: translateY(-2px);
        }
    </style>
</c:if>
