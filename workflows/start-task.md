---
description: "Master Workflow hỗ trợ đa chế độ (Hotfix/Standard/Prototype) và điều hướng thông minh."
trigger: /start-task
---

# 🚦 Start Task (Phase 3 - Humanized)

**Mục tiêu:** Phân tích yêu cầu và chọn chế độ vận hành (Mode) phù hợp để cân bằng giữa tốc độ và chất lượng.

## ⚙️ Chế độ Vận hành (Operational Modes)

AI sẽ tự động xác định hoặc hỏi người dùng chọn một trong các chế độ sau:

| Chế độ (Mode) | Đặc điểm | Quy trình (Gates) |
| :--- | :--- | :--- |
| **🚀 Hotfix** | Sửa lỗi gấp, Typo, thay đổi cực nhỏ. | **Skip DoR/DoD gắt.** Chỉ cần Lint pass và verify lỗi biến mất. |
| **⚖️ Standard** | Phát triển Feature mới, Refactor lớn. | **Full DoR/DoD.** Bắt buộc Spec, Design, Unit Test. |
| **🧪 Prototype**| Làm nhanh bản thử nghiệm, POC. | **Linh hoạt.** AI tự giả định Spec/Design, tập trung vào UI/UX Flow. |

## 🧠 Quy trình 3 bước (BA -> Lead -> QA)

**BẮT BUỘC:** AI phải in ra nội dung thảo luận giả lập giữa 3 vai trò sau đây trong phản hồi để người dùng theo dõi:

1.  **BA Role:** Phân tích giá trị User, các luồng nghiệp vụ chính.
2.  **Architect Role:** Đề xuất giải pháp kỹ thuật, thư viện, cấu trúc code.
3.  **QA Lead Role:** Cảnh báo các Edge cases, rủi ro bảo mật và trải nghiệm.

## 📝 Mẫu phản hồi yêu cầu
AI phải phản hồi theo cấu trúc:
1. **Phân tích yêu cầu & Mode lựa chọn.**
2. **## 🗣️ Cuộc họp nội bộ (Internal Simulation)**: Nội dung thảo luận của 3 vai trò.
3. **Kết luận & Đề xuất hành động tiếp theo.**

> `/start-task [yêu cầu] --mode [hotfix|standard|prototype]`

*(Nếu không có --mode, AI sẽ tự đề xuất mode phù hợp dựa trên độ phức tạp)*