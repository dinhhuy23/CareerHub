<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Location"%>
<%@page import="model.Company"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Company Form</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/header.jsp" />
        <%
            Company company = (Company) request.getAttribute("company");
            List<Location> locations = (List<Location>) request.getAttribute("locations");
            String mode = (String) request.getAttribute("mode");
            String error = (String) request.getAttribute("error");

            boolean isEdit = "edit".equalsIgnoreCase(mode);

            String actionUrl = isEdit
                    ? request.getContextPath() + "/company/edit"
                    : request.getContextPath() + "/company/create";
        %>

        <div class="page-container">
            <div class="page-header">
                <h1 class="page-title"><%= isEdit ? "Edit Company" : "Create Company" %></h1>
                <p class="page-subtitle">
                    <%= isEdit ? "Update the company information below" : "Fill in the company information below" %>
                </p>
            </div>

            <div class="form-card">
                <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
                <% } %>

                <form action="<%= actionUrl %>" method="post" enctype="multipart/form-data">
                    <% if (isEdit && company != null) { %>
                    <input type="hidden" name="companyId" value="<%= company.getCompanyId() %>">
                    <% } %>

                    <div class="section-title">Basic Information</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Company Name *</label>
                            <input type="text" name="companyName" class="form-control"
                                   value="<%= company != null && company.getCompanyName() != null ? company.getCompanyName() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Tax Code</label>
                            <input type="text" name="taxCode" class="form-control"
                                   value="<%= company != null && company.getTaxCode() != null ? company.getTaxCode() : "" %>">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Founded Year</label>
                            <input type="number" name="foundedYear" class="form-control"
                                   value="<%= company != null && company.getFoundedYear() != null ? company.getFoundedYear() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Company Size</label>
                            <select name="companySize" class="form-control">
                                <option value="">-- Select Company Size --</option>
                                <option value="1-10 employees" <%= company != null && "1-10 employees".equals(company.getCompanySize()) ? "selected" : "" %>>1-10 employees</option>
                                <option value="11-50 employees" <%= company != null && "11-50 employees".equals(company.getCompanySize()) ? "selected" : "" %>>11-50 employees</option>
                                <option value="51-200 employees" <%= company != null && "51-200 employees".equals(company.getCompanySize()) ? "selected" : "" %>>51-200 employees</option>
                                <option value="201-500 employees" <%= company != null && "201-500 employees".equals(company.getCompanySize()) ? "selected" : "" %>>201-500 employees</option>
                                <option value="500+ employees" <%= company != null && "500+ employees".equals(company.getCompanySize()) ? "selected" : "" %>>500+ employees</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Industry</label>
                            <input type="text" name="industry" class="form-control"
                                   value="<%= company != null && company.getIndustry() != null ? company.getIndustry() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Status</label>
                            <select name="status" class="form-control">
                                <option value="ACTIVE" <%= company != null && "ACTIVE".equalsIgnoreCase(company.getStatus()) ? "selected" : "" %>>ACTIVE</option>
                                <option value="INACTIVE" <%= company != null && "INACTIVE".equalsIgnoreCase(company.getStatus()) ? "selected" : "" %>>INACTIVE</option>
                            </select>
                        </div>
                    </div>

                    <div class="section-title">Contact Information</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Website</label>
                            <input type="text" name="websiteUrl" class="form-control"
                                   value="<%= company != null && company.getWebsiteUrl() != null ? company.getWebsiteUrl() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Contact Email</label>
                            <input type="text" name="email" class="form-control"
                                   value="<%= company != null && company.getEmail() != null ? company.getEmail() : "" %>">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phoneNumber" class="form-control"
                                   value="<%= company != null && company.getPhoneNumber() != null ? company.getPhoneNumber() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Logo URL</label>
                            <input type="file" name="image" class="form-control" id="logoFile">
                            <input type="hidden" name="imageOrigin" value="<%= company != null ? company.getLogoUrl() : "" %>" class="form-control">
                            <!-- preview -->
                            <img id="previewImg" src="<%= company != null ? company.getLogoUrl() : "" %>" 
                                 style="max-width:200px; margin-top:10px"/>
                        </div>
                    </div>

                    <div class="section-title">Address Information</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Location</label>
                            <select name="locationId" class="form-control">
                                <option value="">-- Select Location --</option>
                                <%
                                    if (locations != null) {
                                        for (Location location : locations) {
                                            boolean selected = company != null
                                                    && company.getLocationId() != null
                                                    && company.getLocationId().longValue() == location.getLocationId();
                                %>
                                <option value="<%= location.getLocationId() %>" <%= selected ? "selected" : "" %>>
                                    <%= location.getLocationName() %>
                                </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Address Line</label>
                            <input type="text" name="addressLine" class="form-control"
                                   value="<%= company != null && company.getAddressLine() != null ? company.getAddressLine() : "" %>">
                        </div>
                    </div>

                    <div class="section-title">Branding & Description</div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea style="color: #fff" name="description" class="form-textarea" rows="6"><%= company != null && company.getDescription() != null ? company.getDescription() : "" %></textarea>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <%= isEdit ? "Update Company" : "Save Company" %>
                        </button>

                        <% if (isEdit && company != null) { %>
                        <a href="${pageContext.request.contextPath}/company/detail?id=<%= company.getCompanyId() %>" class="btn btn-light">Cancel</a>
                        <% } else { %>
                        <a href="${pageContext.request.contextPath}/company/company-list.jsp" class="btn btn-light">Cancel</a>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>
        <script>
            document.getElementById("logoFile").addEventListener("change", function (e) {
                const file = e.target.files[0];
                if (file) {
                    const preview = document.getElementById("previewImg");
                    preview.src = URL.createObjectURL(file);
                }
            });
        </script>
    </body>
</html>