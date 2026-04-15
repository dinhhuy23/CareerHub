const companies = [
    {
        id: 1,
        name: "FPT Software",
        industry: "Information Technology",
        size: "1000+ employees",
        location: "Ha Noi",
        website: "https://fptsoftware.com",
        status: "Hiring",
        logo: "FPT.png",
        description: "A leading technology company specializing in software development, digital transformation, and global IT services."
    },
    {
        id: 2,
        name: "VNG Corporation",
        industry: "Technology & Digital Services",
        size: "500+ employees",
        location: "Ho Chi Minh City",
        website: "https://vng.com.vn",
        status: "Hiring",
        logo: "vng.png",
        description: "A well-known digital technology company focusing on online platforms, cloud solutions, gaming, and digital transformation."
    },
    {
        id: 3,
        name: "Vietcombank",
        industry: "Finance & Banking",
        size: "1000+ employees",
        location: "Ha Noi",
        website: "https://vietcombank.com.vn",
        status: "Hiring",
        logo: "Vietcombank.png",
        description: "One of the largest commercial banks in Vietnam, providing diverse banking, financial, and digital payment services."
    },
    {
        id: 4,
        name: "Rikkeisoft",
        industry: "Software Outsourcing",
        size: "201-500 employees",
        location: "Da Nang",
        website: "https://rikkeisoft.com",
        status: "Hiring",
        logo: "rikkeisoft.png",
        description: "A software outsourcing company delivering web, mobile, AI, and enterprise system development services."
    },
    {
        id: 5,
        name: "Vinmec",
        industry: "Healthcare",
        size: "500+ employees",
        location: "Ha Noi",
        website: "https://vinmec.com",
        status: "Hiring",
        logo: "vinmec.png",
        description: "A leading healthcare system in Vietnam, delivering medical services, hospital operations, and advanced healthcare solutions."
    },
    {
        id: 6,
        name: "TopCV Vietnam",
        industry: "Human Resources Technology",
        size: "51-200 employees",
        location: "Ha Noi",
        website: "https://topcv.vn",
        status: "Hiring",
        logo: "topcv.png",
        description: "A recruitment technology platform offering hiring solutions, CV building tools, and job matching services."
    }
];

function renderCompanies(companyList) {
    const container = document.getElementById("companyList");
    if (!container) return;

    container.innerHTML = "";

    if (companyList.length === 0) {
        container.innerHTML = `
            <div class="detail-card">
                <p class="empty-text">No companies match your search criteria.</p>
            </div>
        `;
        return;
    }

    companyList.forEach(company => {
        const card = document.createElement("div");
        card.className = "company-card";

        card.innerHTML = `
            <div class="company-card-header">
                <img src="${contextPath}/images/company/${company.logo}" alt="${company.name} Logo" class="company-card-logo">
                <div class="company-card-info">
                    <h2>${company.name}</h2>
                    <p>${company.industry}</p>
                    <span class="status-badge status-active">${company.status}</span>
                </div>
            </div>

            <div class="company-card-body">
                <p><strong>Size:</strong> ${company.size}</p>
                <p><strong>Location:</strong> ${company.location}</p>
                <p><strong>Website:</strong> ${company.website}</p>
                <p class="company-short-desc">${company.description}</p>
            </div>

            <div class="company-card-footer">
                <a href="${contextPath}/company/detail?id=${company.id}" class="btn btn-primary">View Detail</a>
            </div>
        `;

        container.appendChild(card);
    });
}

function filterCompanies() {
    const searchValue = document.getElementById("searchInput").value.trim().toLowerCase();
    const industryValue = document.getElementById("industryFilter").value;
    const locationValue = document.getElementById("locationFilter").value;

    const filtered = companies.filter(company => {
        const matchName = company.name.toLowerCase().includes(searchValue);
        const matchIndustry = industryValue === "All" || company.industry === industryValue;
        const matchLocation = locationValue === "All" || company.location === locationValue;

        return matchName && matchIndustry && matchLocation;
    });

    renderCompanies(filtered);
}

window.onload = function () {
    renderCompanies(companies);

    const searchInput = document.getElementById("searchInput");
    const industryFilter = document.getElementById("industryFilter");
    const locationFilter = document.getElementById("locationFilter");

    if (searchInput) {
        searchInput.addEventListener("input", filterCompanies);
    }

    if (industryFilter) {
        industryFilter.addEventListener("change", filterCompanies);
    }

    if (locationFilter) {
        locationFilter.addEventListener("change", filterCompanies);
    }
};