package controller;

import com.cloudinary.Cloudinary;
import dal.CompanyDAO;
import dal.LocationDAO;
import java.io.IOException;
import java.time.Year;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import model.Company;
import model.Location;
import utils.CloudinaryConfig;

@MultipartConfig(
        maxFileSize    = 1024 * 1024 * 10,  // 10 MB
        maxRequestSize = 1024 * 1024 * 50
)
@WebServlet(name = "CompanyCreateServlet", urlPatterns = {"/company/create"})
public class CompanyCreateServlet extends HttpServlet {

    // ── Field length limits ────────────────────────────────────────────────────
    private static final int MAX_COMPANY_NAME = 200;
    private static final int MAX_TAX_CODE     = 50;
    private static final int MAX_WEBSITE      = 255;
    private static final int MAX_EMAIL        = 255;
    private static final int MAX_PHONE        = 20;
    private static final int MAX_INDUSTRY     = 100;
    private static final int MAX_ADDRESS      = 300;
    private static final int MAX_DESCRIPTION  = 3000;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LocationDAO locationDAO = new LocationDAO();
        request.setAttribute("locations", locationDAO.getAllActive());
        request.setAttribute("mode", "create");
        request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String companyName    = trim(request.getParameter("companyName"));
        String taxCode        = trim(request.getParameter("taxCode"));
        String websiteUrl     = trim(request.getParameter("websiteUrl"));
        String email          = trim(request.getParameter("email"));
        String phoneNumber    = trim(request.getParameter("phoneNumber"));
        String description    = trim(request.getParameter("description"));
        String foundedYearRaw = trim(request.getParameter("foundedYear"));
        String companySize    = trim(request.getParameter("companySize"));
        String industry       = trim(request.getParameter("industry"));
        String addressLine    = trim(request.getParameter("addressLine"));
        String locationIdRaw  = trim(request.getParameter("locationId"));
        String status         = trim(request.getParameter("status"));

        // ── Validation ─────────────────────────────────────────────────────────
        Map<String, String> errors = new LinkedHashMap<>();

        if (companyName.isEmpty()) {
            errors.put("companyName", "Tên công ty không được để trống.");
        } else if (companyName.length() > MAX_COMPANY_NAME) {
            errors.put("companyName", "Tên công ty không được vượt quá " + MAX_COMPANY_NAME + " ký tự.");
        }

        if (!taxCode.isEmpty() && taxCode.length() > MAX_TAX_CODE) {
            errors.put("taxCode", "Mã số thuế không được vượt quá " + MAX_TAX_CODE + " ký tự.");
        }

        if (!websiteUrl.isEmpty() && websiteUrl.length() > MAX_WEBSITE) {
            errors.put("websiteUrl", "Website URL không được vượt quá " + MAX_WEBSITE + " ký tự.");
        }

        if (!email.isEmpty()) {
            if (!email.matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$")) {
                errors.put("email", "Email liên hệ không đúng định dạng.");
            } else if (email.length() > MAX_EMAIL) {
                errors.put("email", "Email không được vượt quá " + MAX_EMAIL + " ký tự.");
            }
        }

        if (!phoneNumber.isEmpty() && phoneNumber.length() > MAX_PHONE) {
            errors.put("phoneNumber", "Số điện thoại không được vượt quá " + MAX_PHONE + " ký tự.");
        }

        if (!industry.isEmpty() && industry.length() > MAX_INDUSTRY) {
            errors.put("industry", "Ngành nghề không được vượt quá " + MAX_INDUSTRY + " ký tự.");
        }

        if (!addressLine.isEmpty() && addressLine.length() > MAX_ADDRESS) {
            errors.put("addressLine", "Địa chỉ không được vượt quá " + MAX_ADDRESS + " ký tự.");
        }

        if (!description.isEmpty() && description.length() > MAX_DESCRIPTION) {
            errors.put("description", "Mô tả không được vượt quá " + MAX_DESCRIPTION + " ký tự.");
        }

        Integer foundedYear = null;
        if (!foundedYearRaw.isEmpty()) {
            try {
                foundedYear = Integer.parseInt(foundedYearRaw);
                int currentYear = Year.now().getValue();
                if (foundedYear < 1800 || foundedYear > currentYear) {
                    errors.put("foundedYear", "Năm thành lập phải từ 1800 đến " + currentYear + ".");
                }
            } catch (NumberFormatException e) {
                errors.put("foundedYear", "Năm thành lập phải là số nguyên.");
            }
        }

        Long locationId = null;
        if (!locationIdRaw.isEmpty()) {
            try {
                locationId = Long.parseLong(locationIdRaw);
            } catch (NumberFormatException e) {
                errors.put("locationId", "Địa điểm không hợp lệ.");
            }
        }

        // ── Nếu có lỗi → trả form ngay, KHÔNG chạm DB ────────────────────────
        if (!errors.isEmpty()) {
            Company c = buildCompanyBean(0, companyName, taxCode, websiteUrl, email,
                    phoneNumber, description, foundedYear, companySize, industry,
                    addressLine, locationId, status, null);

            request.setAttribute("company",    c);
            request.setAttribute("errors",     errors);
            request.setAttribute("error",      "Vui lòng kiểm tra lại thông tin đã nhập.");
            request.setAttribute("mode",       "create");
            request.setAttribute("locations",  new LocationDAO().getAllActive());
            request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
            return;
        }

        // ── Không có lỗi → xử lý ảnh + DB ────────────────────────────────────
        try {
            String logoUrl = null;
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                byte[] bytes = filePart.getInputStream().readAllBytes();
                Cloudinary cloudinary = CloudinaryConfig.getCloudinary();
                Map result = cloudinary.uploader().upload(bytes, new HashMap());
                logoUrl = (String) result.get("secure_url");
            }

            Company company = buildCompanyBean(0, companyName, taxCode, websiteUrl, email,
                    phoneNumber, description, foundedYear, companySize, industry,
                    addressLine, locationId, status, logoUrl);
            company.setCreatedByUserId(1L); // TODO: lấy từ session user thực tế

            CompanyDAO companyDAO = new CompanyDAO();
            long newId = companyDAO.insertCompanyAndReturnId(company);

            if (newId > 0) {
                setToast(request, "success", "Thêm công ty thành công!");
                response.sendRedirect(request.getContextPath() + "/company/detail?id=" + newId);
            } else {
                setToast(request, "error", "Thêm công ty thất bại. Vui lòng thử lại.");
                request.setAttribute("company",   company);
                request.setAttribute("mode",      "create");
                request.setAttribute("locations", new LocationDAO().getAllActive());
                request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            setToast(request, "error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại.");
            request.setAttribute("mode",      "create");
            request.setAttribute("locations", new LocationDAO().getAllActive());
            request.getRequestDispatcher("/company/company-form.jsp").forward(request, response);
        }
    }

    // ── Helpers ────────────────────────────────────────────────────────────────
    private static String trim(String s) { return s == null ? "" : s.trim(); }

    private static void setToast(HttpServletRequest request, String type, String msg) {
        HttpSession sess = request.getSession(true);
        sess.setAttribute("toastType", type);
        sess.setAttribute("toastMsg",  msg);
    }

    private static Company buildCompanyBean(long id, String name, String taxCode,
            String websiteUrl, String email, String phone, String description,
            Integer foundedYear, String companySize, String industry,
            String addressLine, Long locationId, String status, String logoUrl) {
        Company c = new Company();
        if (id > 0) c.setCompanyId(id);
        c.setCompanyName(name);
        c.setTaxCode(taxCode.isEmpty()     ? null : taxCode);
        c.setWebsiteUrl(websiteUrl.isEmpty()  ? null : websiteUrl);
        c.setEmail(email.isEmpty()         ? null : email);
        c.setPhoneNumber(phone.isEmpty()   ? null : phone);
        c.setDescription(description.isEmpty() ? null : description);
        c.setFoundedYear(foundedYear);
        c.setCompanySize(companySize.isEmpty() ? null : companySize);
        c.setIndustry(industry.isEmpty()   ? null : industry);
        c.setAddressLine(addressLine.isEmpty() ? null : addressLine);
        c.setLocationId(locationId);
        c.setStatus(status == null || status.isEmpty() ? "ACTIVE" : status);
        c.setLogoUrl(logoUrl);
        return c;
    }
}
