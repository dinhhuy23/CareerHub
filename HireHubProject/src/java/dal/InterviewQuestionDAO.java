package dal;

import model.InterviewQuestion;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class InterviewQuestionDAO {

    private static final List<InterviewQuestion> ALL = new ArrayList<>();

    static {
        // ===== IT / LẬP TRÌNH =====
        add(1, "IT", "💻 Lập trình / IT", "JUNIOR", "Junior",
            "OOP là gì? Hãy giải thích 4 tính chất của lập trình hướng đối tượng.",
            "OOP (Object-Oriented Programming) gồm 4 tính chất:\n• Encapsulation (Đóng gói): ẩn dữ liệu nội bộ, chỉ cung cấp public interface.\n• Inheritance (Kế thừa): class con kế thừa thuộc tính và phương thức từ class cha.\n• Polymorphism (Đa hình): cùng một phương thức có thể có hành vi khác nhau tùy đối tượng.\n• Abstraction (Trừu tượng): ẩn đi chi tiết cài đặt, chỉ hiển thị những gì cần thiết.",
            Arrays.asList("Java", "OOP", "Core"));

        add(2, "IT", "💻 Lập trình / IT", "JUNIOR", "Junior",
            "Sự khác biệt giữa ArrayList và LinkedList trong Java là gì?",
            "ArrayList lưu trữ bằng mảng động — truy cập phần tử O(1) nhưng thêm/xóa giữa danh sách O(n).\nLinkedList lưu bằng danh sách liên kết — thêm/xóa O(1) nhưng truy cập O(n).\nDùng ArrayList khi cần đọc nhiều, LinkedList khi cần thêm/xóa nhiều ở đầu/giữa.",
            Arrays.asList("Java", "Collections", "Data Structures"));

        add(3, "IT", "💻 Lập trình / IT", "MID", "Mid-level",
            "Design Pattern là gì? Hãy trình bày Singleton Pattern và khi nào nên dùng.",
            "Design Pattern là các giải pháp tái sử dụng cho các bài toán thiết kế phần mềm phổ biến.\nSingleton đảm bảo một class chỉ có duy nhất một instance trong toàn bộ ứng dụng.\nDùng khi: quản lý connection pool, config, logger...\nImplementation: private constructor + static getInstance() + double-checked locking (thread-safe).",
            Arrays.asList("Java", "Design Patterns", "Singleton"));

        add(4, "IT", "💻 Lập trình / IT", "MID", "Mid-level",
            "RESTful API là gì? Các HTTP methods (GET, POST, PUT, PATCH, DELETE) dùng như thế nào?",
            "REST (Representational State Transfer) là kiến trúc API theo nguyên tắc stateless.\n• GET: Lấy dữ liệu (không có side effect)\n• POST: Tạo mới tài nguyên\n• PUT: Cập nhật toàn bộ tài nguyên\n• PATCH: Cập nhật một phần tài nguyên\n• DELETE: Xóa tài nguyên\nHTTP status codes quan trọng: 200 OK, 201 Created, 400 Bad Request, 401 Unauthorized, 404 Not Found, 500 Internal Server Error.",
            Arrays.asList("API", "REST", "HTTP", "Backend"));

        add(5, "IT", "💻 Lập trình / IT", "SENIOR", "Senior",
            "Bạn sẽ thiết kế hệ thống cache như thế nào để tăng hiệu năng ứng dụng?",
            "Chiến lược caching hiệu quả:\n1. Cache-Aside (Lazy Loading): App kiểm tra cache trước, nếu miss thì query DB và lưu vào cache.\n2. Write-Through: Ghi vào cache và DB đồng thời.\n3. Write-Behind: Ghi vào cache trước, sync DB sau (async).\nTools: Redis, Memcached.\nCần cân nhắc: TTL (Time-to-Live), Cache eviction policy (LRU, LFU), Cache invalidation khi data thay đổi, Cache stampede protection.",
            Arrays.asList("Redis", "Cache", "System Design", "Performance"));

        add(6, "IT", "💻 Lập trình / IT", "JUNIOR", "Junior",
            "Git branching strategy phổ biến là gì? Giải thích Git Flow.",
            "Git Flow chia branch thành:\n• main: code production, luôn stable\n• develop: tích hợp các feature mới\n• feature/*: phát triển tính năng mới từ develop\n• release/*: chuẩn bị release, fix bug nhỏ\n• hotfix/*: fix bug khẩn cấp trên production\nQuy trình: feature → develop → release → main, hotfix → main & develop.",
            Arrays.asList("Git", "DevOps", "Version Control"));

        add(7, "IT", "💻 Lập trình / IT", "MID", "Mid-level",
            "SQL Index là gì? Khi nào nên và không nên tạo Index?",
            "Index là cấu trúc dữ liệu tăng tốc truy vấn, hoạt động như mục lục sách.\nNên dùng: cột thường dùng trong WHERE, JOIN, ORDER BY với bảng lớn.\nKhông nên dùng: bảng nhỏ, cột thường xuyên UPDATE/INSERT, cột có ít giá trị distinct (ví dụ: gender).\nLoại Index: B-Tree (phổ biến), Hash, Composite Index (nhiều cột), Covering Index.",
            Arrays.asList("SQL", "Database", "Performance", "Index"));

        add(8, "IT", "💻 Lập trình / IT", "SENIOR", "Senior",
            "Microservices vs Monolithic — ưu nhược điểm và khi nào chọn kiến trúc nào?",
            "Monolithic: toàn bộ app trong một codebase.\n✅ Đơn giản, dễ debug, phù hợp team nhỏ / startup.\n❌ Khó scale từng phần, deploy cả app khi sửa nhỏ.\n\nMicroservices: tách thành nhiều service độc lập.\n✅ Scale từng service, team độc lập, fault isolation.\n❌ Phức tạp hơn (networking, distributed transactions, service discovery).\n\nChọn Monolithic khi: team < 10 người, MVP, domain chưa rõ.\nChọn Microservices khi: scale lớn, team nhiều, domain rõ ràng.",
            Arrays.asList("Architecture", "Microservices", "System Design", "Senior"));

        // ===== MARKETING =====
        add(9, "MARKETING", "📊 Marketing", "JUNIOR", "Junior",
            "Digital Marketing là gì? Hãy liệt kê các kênh Digital Marketing chính.",
            "Digital Marketing là tiếp thị sử dụng kênh kỹ thuật số để tiếp cận khách hàng.\nCác kênh chính:\n• SEO (Search Engine Optimization)\n• SEM/PPC (Google Ads, Facebook Ads)\n• Social Media Marketing (Facebook, Instagram, TikTok)\n• Email Marketing\n• Content Marketing (Blog, Video, Podcast)\n• Affiliate Marketing\n• Influencer Marketing\nMỗi kênh phù hợp với mục tiêu và ngân sách khác nhau.",
            Arrays.asList("Digital Marketing", "SEO", "SEM"));

        add(10, "MARKETING", "📊 Marketing", "MID", "Mid-level",
            "Bạn sẽ đo lường hiệu quả chiến dịch Marketing như thế nào? KPIs quan trọng là gì?",
            "KPIs Marketing theo mục tiêu:\n• Awareness: Reach, Impressions, Brand Search Volume\n• Traffic: Sessions, Unique Visitors, Bounce Rate\n• Engagement: CTR, Time on Page, Social Shares, Comments\n• Conversion: CVR (Conversion Rate), CPL (Cost per Lead), CPA (Cost per Acquisition)\n• Revenue: ROAS (Return on Ad Spend), LTV (Lifetime Value), ROI\nCông cụ đo lường: Google Analytics 4, Google Search Console, Facebook Insights.",
            Arrays.asList("KPIs", "Analytics", "ROI", "Campaign"));

        add(11, "MARKETING", "📊 Marketing", "MID", "Mid-level",
            "SEO On-page và Off-page khác nhau như thế nào? Bạn sẽ tối ưu như thế nào?",
            "On-page SEO (tối ưu trực tiếp trên website):\n• Title tag, Meta description chứa từ khóa mục tiêu\n• Heading structure (H1, H2, H3)\n• URL thân thiện, tốc độ tải trang (Core Web Vitals)\n• Internal linking, Image alt text\n• Content chất lượng, E-E-A-T\n\nOff-page SEO (yếu tố bên ngoài):\n• Backlink từ website uy tín (Guest posting, PR)\n• Brand mentions, Social signals\n• Google Business Profile (Local SEO)",
            Arrays.asList("SEO", "On-page", "Off-page", "Content"));

        add(12, "MARKETING", "📊 Marketing", "SENIOR", "Senior",
            "Hãy trình bày cách xây dựng Marketing Funnel và chiến lược cho từng giai đoạn.",
            "Marketing Funnel (AIDA model):\n• Awareness (Nhận biết): Content Marketing, Social Ads, PR — KPI: Reach, Brand Recall\n• Interest (Quan tâm): Blog, Webinar, Email Newsletter — KPI: CTR, Time on Site\n• Desire (Mong muốn): Case Study, Testimonials, Demo — KPI: Lead Quality Score\n• Action (Hành động): Ưu đãi, CTA mạnh, Remarketing — KPI: CVR, CPA\nPost-funnel: Retention (Email nurturing, Loyalty program) & Advocacy (Review, Referral).",
            Arrays.asList("Funnel", "AIDA", "Strategy", "Senior"));

        // ===== KINH DOANH / SALES =====
        add(13, "SALES", "💼 Kinh doanh / Sales", "JUNIOR", "Junior",
            "Quy trình bán hàng (Sales Process) cơ bản gồm những bước nào?",
            "Quy trình bán hàng 7 bước:\n1. Prospecting: Tìm kiếm khách hàng tiềm năng\n2. Preparation: Nghiên cứu khách hàng trước khi tiếp cận\n3. Approach: Tiếp cận, tạo ấn tượng đầu tiên\n4. Presentation: Trình bày giải pháp phù hợp nhu cầu\n5. Handling Objections: Xử lý phản đối, lo ngại của khách hàng\n6. Closing: Chốt sale — kỹ thuật: Assumptive, Urgency, Trial Close\n7. Follow-up: Chăm sóc sau bán, upsell/cross-sell",
            Arrays.asList("Sales", "Sales Process", "Closing"));

        add(14, "SALES", "💼 Kinh doanh / Sales", "MID", "Mid-level",
            "Làm thế nào để xử lý khi khách hàng nói 'giá quá đắt'?",
            "Kỹ thuật xử lý objection về giá:\n1. Không giảm giá ngay — hỏi lại: 'So với điều gì thì đắt?'\n2. Nhấn mạnh giá trị: ROI, tiết kiệm chi phí dài hạn, rủi ro nếu không mua\n3. So sánh chi phí: chia nhỏ giá thành chi phí hàng tháng/ngày\n4. Gói linh hoạt: đề xuất gói phù hợp hơn với ngân sách\n5. Social proof: khách hàng tương tự đã đạt kết quả gì\n6. Nếu thực sự không phù hợp: biết lúc nào nên dừng lại",
            Arrays.asList("Sales", "Negotiation", "Objection Handling"));

        add(15, "SALES", "💼 Kinh doanh / Sales", "SENIOR", "Senior",
            "Bạn sẽ xây dựng chiến lược phát triển thị trường mới như thế nào?",
            "Chiến lược GTM (Go-to-Market) cho thị trường mới:\n1. Market Research: Phân tích TAM/SAM/SOM, đối thủ, regulatory\n2. ICP Definition: Xác định Ideal Customer Profile\n3. Value Proposition: Thông điệp phù hợp local market\n4. Channel Strategy: Direct sales, Partner/Reseller, Digital\n5. Pilot: Test ở quy mô nhỏ, đo KPIs, iterate\n6. Scale: Tuyển dụng local team, đầu tư marketing, mở rộng\nKPIs: Pipeline Value, Win Rate, CAC, Payback Period",
            Arrays.asList("Sales", "Strategy", "Market Development", "GTM"));

        // ===== NHÂN SỰ / HR =====
        add(16, "HR", "👥 Nhân sự (HR)", "JUNIOR", "Junior",
            "Quy trình tuyển dụng (Recruitment Process) gồm những bước nào?",
            "Quy trình tuyển dụng:\n1. Job Analysis: Phân tích công việc, xác định yêu cầu\n2. Job Posting: Đăng tin trên JobStreet, LinkedIn, TopCV...\n3. Sourcing: Tìm kiếm ứng viên chủ động (headhunting)\n4. Screening CV: Lọc hồ sơ theo tiêu chí\n5. Phone/Online Interview: Sàng lọc sơ bộ\n6. Interview: Phỏng vấn chuyên sâu (technical + culture fit)\n7. Assessment: Bài test kỹ năng (nếu cần)\n8. Offer: Đề xuất offer, thương lượng\n9. Onboarding: Hội nhập nhân viên mới",
            Arrays.asList("HR", "Recruitment", "Hiring"));

        add(17, "HR", "👥 Nhân sự (HR)", "MID", "Mid-level",
            "Làm thế nào để đánh giá văn hóa doanh nghiệp (Culture Fit) của ứng viên?",
            "Đánh giá Culture Fit:\n• Behavioral Questions (STAR method): 'Kể về lần bạn làm việc với người khó tính nhất'\n• Values Assessment: hỏi về điều ứng viên coi trọng trong môi trường làm việc\n• Work Style: độc lập vs teamwork, structure vs flexibility\n• Situational Questions: đặt tình huống phù hợp với culture công ty\n• Reference Check: hỏi người tham chiếu về cách làm việc\nLưu ý: tránh unconscious bias, tập trung Add-Culture thay vì Culture-Fit (đa dạng là lợi thế).",
            Arrays.asList("HR", "Culture Fit", "Interview", "Behavioral"));

        add(18, "HR", "👥 Nhân sự (HR)", "SENIOR", "Senior",
            "Bạn sẽ thiết kế hệ thống đánh giá hiệu suất (Performance Review) như thế nào?",
            "Framework Performance Management hiệu quả:\n1. Goal Setting: OKR hoặc SMART Goals (đầu kỳ, cascade từ company → team → cá nhân)\n2. Continuous Feedback: 1-on-1 định kỳ, feedback real-time\n3. Mid-year Review: điều chỉnh mục tiêu nếu cần\n4. Year-end Review: 360-degree feedback (self, peer, manager)\n5. Calibration: HR đảm bảo tính nhất quán giữa các team\n6. Action Plan: PIP cho underperformers, Development Plan cho high performers\nKPIs: Employee Engagement Score, Turnover Rate, Internal Promotion Rate",
            Arrays.asList("HR", "Performance", "OKR", "Management"));

        // ===== TÀI CHÍNH =====
        add(19, "FINANCE", "💰 Tài chính / Kế toán", "JUNIOR", "Junior",
            "Báo cáo tài chính gồm những loại nào? Giải thích mục đích của từng loại.",
            "3 báo cáo tài chính chính:\n1. Báo cáo Kết quả Kinh doanh (P&L / Income Statement): Doanh thu, Chi phí, Lợi nhuận trong một kỳ\n2. Bảng Cân đối Kế toán (Balance Sheet): Tài sản = Nợ phải trả + Vốn chủ sở hữu (tại một thời điểm)\n3. Báo cáo Lưu chuyển Tiền tệ (Cash Flow Statement): Dòng tiền từ hoạt động kinh doanh, đầu tư, tài chính\nBáo cáo bổ sung: Thuyết minh BCTC, Báo cáo thay đổi vốn chủ sở hữu",
            Arrays.asList("Finance", "Accounting", "Financial Statements"));

        add(20, "FINANCE", "💰 Tài chính / Kế toán", "MID", "Mid-level",
            "ROI, ROE, ROA là gì? Hãy giải thích và cho biết cách tính.",
            "Các chỉ số sinh lời quan trọng:\n• ROI (Return on Investment): Lợi nhuận / Vốn đầu tư × 100%. Đo hiệu quả đầu tư tổng quát.\n• ROE (Return on Equity): Lợi nhuận sau thuế / Vốn chủ sở hữu × 100%. Đo hiệu quả sử dụng vốn cổ đông.\n• ROA (Return on Assets): Lợi nhuận sau thuế / Tổng tài sản × 100%. Đo hiệu quả sử dụng tài sản.\nROE cao hơn ROA chứng tỏ có sử dụng đòn bẩy tài chính (financial leverage).",
            Arrays.asList("Finance", "ROI", "ROE", "Financial Analysis"));

        // ===== KỸ NĂNG MỀM =====
        add(21, "SOFT_SKILLS", "🧠 Kỹ năng mềm", "ALL", "Tất cả cấp độ",
            "Hãy kể về một lần bạn xử lý xung đột với đồng nghiệp. Bạn đã làm gì?",
            "Sử dụng phương pháp STAR:\n• Situation: Mô tả bối cảnh xung đột (không chỉ trích cá nhân)\n• Task: Vai trò của bạn trong tình huống đó\n• Action: Bạn đã chủ động lắng nghe, tìm hiểu quan điểm đối phương, đề xuất giải pháp win-win như thế nào\n• Result: Kết quả tích cực — mối quan hệ được cải thiện, dự án hoàn thành\nLưu ý: nhà tuyển dụng muốn thấy bạn proactive, empathetic và solution-oriented.",
            Arrays.asList("Soft Skills", "Conflict Resolution", "Teamwork", "STAR"));

        add(22, "SOFT_SKILLS", "🧠 Kỹ năng mềm", "ALL", "Tất cả cấp độ",
            "Điểm mạnh và điểm yếu của bạn là gì?",
            "Cách trả lời hiệu quả:\nĐiểm mạnh: Chọn 2-3 điểm thực sự liên quan đến công việc, có ví dụ cụ thể.\n→ VD: 'Tôi có khả năng phân tích dữ liệu tốt — tại công ty cũ tôi đã tối ưu quy trình giảm 30% thời gian báo cáo'\n\nĐiểm yếu: Chọn điểm yếu THẬT nhưng KHÔNG致命, kèm theo hành động cải thiện.\n→ VD: 'Tôi có xu hướng perfectionist, đôi khi mất thời gian vào chi tiết nhỏ. Tôi đang học cách ưu tiên theo impact và set time-box cho từng task'\nTránh: trả lời điểm yếu là 'làm việc quá chăm chỉ' — quá sáo rỗng.",
            Arrays.asList("Soft Skills", "Self-awareness", "Interview Tips"));

        add(23, "SOFT_SKILLS", "🧠 Kỹ năng mềm", "ALL", "Tất cả cấp độ",
            "Tại sao bạn muốn làm việc tại công ty chúng tôi?",
            "Cấu trúc câu trả lời tốt:\n1. Nghiên cứu kỹ về công ty (sản phẩm, văn hóa, thị trường, thành tích gần đây)\n2. Kết nối với mục tiêu cá nhân: 'Công ty đang mở rộng mảng X, đúng với hướng tôi muốn phát triển'\n3. Văn hóa: 'Tôi ấn tượng với cách công ty đề cao learning culture / remote-first culture...'\n4. Tránh: chỉ nói về lương, vị trí địa lý, hoặc câu chung chung không có research\nNhà tuyển dụng muốn thấy bạn thực sự quan tâm và đã tìm hiểu về họ.",
            Arrays.asList("Soft Skills", "Motivation", "Interview Tips"));

        add(24, "SOFT_SKILLS", "🧠 Kỹ năng mềm", "ALL", "Tất cả cấp độ",
            "Bạn có thể kể về một dự án bạn tự hào nhất không?",
            "Áp dụng STAR method:\n• Situation: Bối cảnh dự án (team size, timeline, challenges)\n• Task: Vai trò và trách nhiệm của bạn cụ thể\n• Action: Những quyết định, sáng kiến bạn đã thực hiện\n• Result: Kết quả đo lường được (%, $, thời gian tiết kiệm)\nTips: Chọn dự án liên quan đến vị trí ứng tuyển. Nhấn mạnh cả kỹ năng kỹ thuật lẫn kỹ năng mềm (leadership, problem-solving). Chuẩn bị 2-3 dự án để linh hoạt.",
            Arrays.asList("Soft Skills", "Project", "STAR", "Achievement"));

        add(25, "SOFT_SKILLS", "🧠 Kỹ năng mềm", "ALL", "Tất cả cấp độ",
            "5 năm nữa bạn muốn ở đâu trong sự nghiệp?",
            "Cách trả lời balance giữa tham vọng và thực tế:\n1. Cho thấy bạn có tầm nhìn và mục tiêu rõ ràng\n2. Liên kết với lộ trình phát triển tại công ty này\n3. Nhấn mạnh bạn muốn đóng góp và phát triển cùng công ty\nVD: 'Trong 2-3 năm tôi muốn trở thành chuyên gia vững chắc trong [lĩnh vực]. Sau đó tôi muốn đảm nhận thêm trách nhiệm [team lead / senior]. Tôi tin môi trường tại đây sẽ giúp tôi đạt được điều đó.'\nTránh: nói muốn tự khởi nghiệp hoặc vị trí chưa liên quan.",
            Arrays.asList("Soft Skills", "Career", "Planning"));
    }

    private static void add(int id, String cat, String catLabel, String lvl, String lvlLabel,
                             String question, String answer, List<String> tags) {
        ALL.add(new InterviewQuestion(id, cat, catLabel, lvl, lvlLabel, question, answer, tags));
    }

    public List<InterviewQuestion> getAll() {
        return new ArrayList<>(ALL);
    }

    public List<InterviewQuestion> search(String keyword, String category, String level) {
        String kw = (keyword != null) ? keyword.toLowerCase().trim() : "";
        String cat = (category != null && !category.isEmpty()) ? category.toUpperCase() : "";
        String lvl = (level != null && !level.isEmpty()) ? level.toUpperCase() : "";

        return ALL.stream().filter(q -> {
            boolean matchKw = kw.isEmpty()
                || q.getQuestion().toLowerCase().contains(kw)
                || q.getAnswer().toLowerCase().contains(kw)
                || q.getTags().stream().anyMatch(t -> t.toLowerCase().contains(kw));
            boolean matchCat = cat.isEmpty() || q.getCategory().equals(cat);
            boolean matchLvl = lvl.isEmpty() || q.getLevel().equals(lvl) || q.getLevel().equals("ALL");
            return matchKw && matchCat && matchLvl;
        }).collect(Collectors.toList());
    }

    public List<String> getCategories() {
        return Arrays.asList("IT", "MARKETING", "SALES", "HR", "FINANCE", "SOFT_SKILLS");
    }
}
