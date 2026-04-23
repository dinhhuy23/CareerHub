/**
 * company.js - Filter/search logic for company-list page.
 * The company cards are rendered server-side via JSTL (${companies}).
 * This script only handles client-side filtering on the existing DOM cards.
 */

function filterCompanies() {
    const searchValue = (document.getElementById("searchInput")?.value || "").trim().toLowerCase();
    const industryValue = document.getElementById("industryFilter")?.value || "All";
    const locationValue = document.getElementById("locationFilter")?.value || "All";

    const container = document.getElementById("companyList");
    if (!container) return;

    const cards = container.querySelectorAll(".company-card");
    let visibleCount = 0;

    cards.forEach(card => {
        const name = (card.querySelector(".company-card-info h2")?.textContent || "").toLowerCase();
        const industry = (card.querySelector(".company-card-info p")?.textContent || "");
        const location = (card.querySelector(".company-card-body p:nth-child(2)")?.textContent || "");

        const matchName = name.includes(searchValue);
        const matchIndustry = industryValue === "All" || industry.includes(industryValue);
        const matchLocation = locationValue === "All" || location.includes(locationValue);

        if (matchName && matchIndustry && matchLocation) {
            card.style.display = "";
            visibleCount++;
        } else {
            card.style.display = "none";
        }
    });

    // Show empty state if no results
    let emptyMsg = container.querySelector(".empty-filter-msg");
    if (visibleCount === 0) {
        if (!emptyMsg) {
            emptyMsg = document.createElement("p");
            emptyMsg.className = "empty-filter-msg empty-text";
            emptyMsg.style.cssText = "text-align:center; padding:24px; color:var(--text-muted); width:100%;";
            emptyMsg.textContent = "Không tìm thấy công ty phù hợp.";
            container.appendChild(emptyMsg);
        }
    } else if (emptyMsg) {
        emptyMsg.remove();
    }
}

window.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("searchInput");
    const industryFilter = document.getElementById("industryFilter");
    const locationFilter = document.getElementById("locationFilter");

    if (searchInput) searchInput.addEventListener("input", filterCompanies);
    if (industryFilter) industryFilter.addEventListener("change", filterCompanies);
    if (locationFilter) locationFilter.addEventListener("change", filterCompanies);
});
