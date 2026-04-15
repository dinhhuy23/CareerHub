<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Company"%>
<%@page import="model.Recruiter"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Company Detail</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company.css">
    </head>
    <body>
        <%
            Company company = (Company) request.getAttribute("company");
            List<Recruiter> recruiters = (List<Recruiter>) request.getAttribute("recruiters");
            String locationName = (String) request.getAttribute("locationName");
        %>

        <div class="page-container">
            <div class="detail-card">

                <div class="company-header">
                    <div class="company-logo-box">
                        <div class="company-logo-box">
                            <% if (company != null && company.getLogoUrl() != null && !company.getLogoUrl().trim().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}<%= company.getLogoUrl() %>" alt="Company Logo" class="company-logo">
                            <% } else { %>
                            <div class="company-logo-placeholder">No Logo</div>
                            <% } %>
                        </div>
                    </div>

                    <div class="company-summary">
                        <h1 class="company-name"><%= company != null ? company.getCompanyName() : "Company Detail" %></h1>
                        <p><strong>Industry:</strong> <%= company != null && company.getIndustry() != null ? company.getIndustry() : "N/A" %></p>
                        <p><strong>Company Size:</strong> <%= company != null && company.getCompanySize() != null ? company.getCompanySize() : "N/A" %></p>
                        <p><strong>Founded Year:</strong> <%= company != null && company.getFoundedYear() != null ? company.getFoundedYear() : "N/A" %></p>
                        <p>
                            <strong>Status:</strong>
                            <span class="status-badge <%= company != null && "ACTIVE".equalsIgnoreCase(company.getStatus()) ? "status-active" : "status-inactive" %>">
                                <%= company != null && company.getStatus() != null ? company.getStatus() : "N/A" %>
                            </span>
                        </p>
                    </div>
                </div>

                <div class="section-block">
                    <h2 class="section-title">About Company</h2>
                    <p class="description-text">
                        <%= company != null && company.getDescription() != null && !company.getDescription().trim().isEmpty()
                                ? company.getDescription()
                                : "No description available." %>
                    </p>
                </div>

                <div class="section-block">
                    <h2 class="section-title">Contact Information</h2>
                    <div class="info-grid">
                        <div class="info-item">
                            <strong>Website:</strong>
                            <%= company != null && company.getWebsiteUrl() != null ? company.getWebsiteUrl() : "N/A" %>
                        </div>

                        <div class="info-item">
                            <strong>Email:</strong>
                            <%= company != null && company.getEmail() != null ? company.getEmail() : "N/A" %>
                        </div>

                        <div class="info-item">
                            <strong>Phone Number:</strong>
                            <%= company != null && company.getPhoneNumber() != null ? company.getPhoneNumber() : "N/A" %>
                        </div>

                        <div class="info-item">
                            <strong>Location:</strong>
                            <%= locationName != null && !locationName.isEmpty() ? locationName : "N/A" %>
                        </div>

                        <div class="info-item full-width">
                            <strong>Address:</strong>
                            <%= company != null && company.getAddressLine() != null ? company.getAddressLine() : "N/A" %>
                        </div>
                    </div>
                </div>

                <div class="section-block">
                    <h2 class="section-title">Recruiter Team</h2>

                    <div class="table-wrapper">
                        <table class="recruiter-table">
                            <thead>
                                <tr>
                                    <th>Full Name</th>
                                    <th>Job Title</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recruiters != null && !recruiters.isEmpty()) { %>
                                <% for (Recruiter recruiter : recruiters) { %>
                                <tr>
                                    <td><%= recruiter.getFullName() %></td>
                                    <td><%= recruiter.getJobTitle() != null ? recruiter.getJobTitle() : "N/A" %></td>
                                    <td><%= recruiter.getEmail() != null ? recruiter.getEmail() : "N/A" %></td>
                                    <td><%= recruiter.getPhoneNumber() != null ? recruiter.getPhoneNumber() : "N/A" %></td>
                                    <td>
                                        <span class="status-badge <%= "ACTIVE".equalsIgnoreCase(recruiter.getStatus()) ? "status-active" : "status-inactive" %>">
                                            <%= recruiter.getStatus() %>
                                        </span>
                                    </td>
                                </tr>
                                <% } %>
                                <% } else { %>
                                <tr>
                                    <td colspan="6" class="empty-text">No recruiters found for this company.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="button-group">
                    <a href="${pageContext.request.contextPath}/company/company-list.jsp" class="btn btn-light">Back to Company List</a>

                    <% if (company != null) { %>
                    <a href="${pageContext.request.contextPath}/company/edit?id=<%= company.getCompanyId() %>" class="btn btn-primary">Edit Company</a>
                    <% } %>
                </div>

            </div>
        </div>
    </body>
</html>