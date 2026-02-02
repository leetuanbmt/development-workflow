# 📋 TASK: Upgrade Development Workflow with Vibecode DNA

> **Mục tiêu:** Biến Development Workflow từ một "Senior Coder" thành một "Product Architect & Builder" toàn diện.
> **Nguồn:** `@vibecode-kit` (v4.0) -> `@development-workflow` (v5.1.0)

## Phase 1: Skill Injection (Nạp kỹ năng Product & Design)
Tạo các skill mới trong `core/skills/` dựa trên tài liệu chất lượng cao của Vibecode.

- [x] **Create Skill: `frontend-architect`**
    - *Nguồn:* `vibecode-kit/skills/ui/` (aesthetics, typography, motion).
    - *Nhiệm vụ:* Chuyên gia về Tailwind, Design System, Animation. Đảm bảo UI không bị "generic AI slop".
    - *File:* `core/skills/frontend-architect/SKILL.md`

- [x] **Create Skill: `copywriter`**
    - *Nguồn:* `vibecode-kit/skills/copy/` (headlines, cta).
    - *Nhiệm vụ:* Viết nội dung Landing page, Microcopy, Error messages thân thiện.
    - *File:* `core/skills/copywriter/SKILL.md`

- [x] **Create Skill: `product-manager`**
    - *Nguồn:* `vibecode-kit/VIBECODE-MASTER-v4.txt` (phần Vision & Context).
    - *Nhiệm vụ:* Phân tích yêu cầu, xác định loại sản phẩm (SaaS/Landing/Blog), đề xuất Vision.
    - *File:* `core/skills/product-manager/SKILL.md`

## Phase 2: Workflow Enhancement (Nâng cấp Quy trình)
Cải tiến các workflow hiện có để áp dụng tư duy "Blueprint trước, Code sau".

- [x] **Update Workflow: `/start-task` (hoặc tạo `/design-product`)**
    - *Thay đổi:* Tích hợp quy trình 3 bước của Vibecode: `Vision (Đề xuất) -> Context (Tinh chỉnh) -> Blueprint (Chốt)`.
    - *Logic:* Nếu user muốn làm "Landing Page", tự động load template Landing Page chuẩn thay vì hỏi bắt đầu từ đâu.
    - *File:* `core/workflows/core/start-task.md`

- [x] **Update Workflow: `/review`**
    - *Thay đổi:* Thêm checklist kiểm tra UI/UX từ Vibecode (Contrast, Mobile responsive, Typography hierarchy).
    - *File:* `core/workflows/core/review.md`

## Phase 3: Template Migration (Nhập khẩu Tài nguyên)
Mang các template sản phẩm đã được kiểm chứng của Vibecode vào kho tàng của Development Workflow.

- [x] **Migrate Product Templates**
    - Chuyển đổi các file `.txt` của Vibecode thành Markdown template có placeholder `{{...}}`.
    - `templates/products/landing-page.template.md`
    - `templates/products/saas-app.template.md`
    - `templates/products/dashboard.template.md`

## Phase 4: Philosophy Adjustment (Thay đổi Tư duy)
Cập nhật "Luật" của Agent để chủ động hơn.

- [x] **Update Rule: `00-core-behavior.md`**
    - Chuyển từ mindset "Chờ lệnh" (Reactive) sang "Đối tác" (Partnership).
    - Quy tắc mới: "Đề xuất Vision trước khi hỏi chi tiết kỹ thuật" (Rule #1 của Vibecode v4).

## 🚀 Execution Plan

### Bước 1: Khởi tạo Structure
1. Tạo thư mục `core/skills/frontend-architect`
2. Tạo thư mục `core/skills/product-manager`
3. Tạo thư mục `templates/products`

### Bước 2: Porting Content
1. Tổng hợp `frontend-aesthetics.md`, `typography-guide.md`, `motion-patterns.md` thành `frontend-architect/SKILL.md`.
2. Tổng hợp logic "Vision/Context/Blueprint" vào `product-manager/SKILL.md`.

### Bước 3: Wiring
- [x] Cập nhật `ORCHESTRATOR.md` để route các từ khóa "design", "ui", "landing", "app" vào các skill mới.
- [x] Cập nhật `sync.sh` để đảm bảo các skill mới được link sang `.agent`.

---
**Trạng thái:** ✅ Completed
**Priority:** High
