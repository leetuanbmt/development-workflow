# ⚡ AI-Native Development Workflow

> **Vibecoding Edition:** Powered by Google Antigravity & Large Context Models.

Chào mừng đến với môi trường phát triển tốc độ cao. Workflow này được thiết kế lại hoàn toàn để tận dụng **Context Window khổng lồ** (1M+ tokens) của các mô hình AI thế hệ mới (Gemini 1.5 Pro, Flash).

Chúng tôi đã loại bỏ tư duy "Atomic" (chia nhỏ task vụn vặt) để chuyển sang **"Antigravity Execution"**: Code trọn vẹn, hiểu toàn cục và giảm thiểu ma sát.

## 🚀 Triết lý Cốt lõi

1.  **Antigravity Execution:** Không còn giới hạn "150 dòng/lần". AI đọc toàn bộ dự án, hiểu kiến trúc và triển khai trọn vẹn tính năng (Full Feature Implementation) trong một lượt.
2.  **Context-First:** AI tự động quét codebase (`tree`, `grep`, `read`) để học phong cách code (Style) và Framework của bạn trước khi hành động.
3.  **Vibecoding:** Tập trung vào dòng chảy (Flow). Giảm thiểu các câu hỏi thừa, các bước role-play giả lập. Input -> Output chất lượng cao.

## 🛠️ Command Center

Hệ thống đã được hợp nhất từ hàng chục lệnh nhỏ thành 5 lệnh quyền năng:

### 🌟 The "God Mode"
| Command | Chức năng | Mô tả |
| :--- | :--- | :--- |
| **/vibe** | **Build & Refactor** | **Lệnh quan trọng nhất.** Tự động: Phân tích -> Thiết kế -> Code -> Verify. Dùng cho mọi việc từ tạo feature mới đến refactor lớn. |

### 🛡️ Quality & Operations
| Command | Chức năng | Mô tả |
| :--- | :--- | :--- |
| **/fix** | **Debug & Repair** | Hợp nhất điều tra (`/investigate`) và sửa lỗi. Tìm root cause và fix ngay lập tức. |
| **/review** | **Audit & PR** | Review đa chiều: Logic, Kiến trúc, Clean Code và Git Diff trong một bước. |
| **/document**| **Docs & Specs** | Viết tài liệu từ cấp độ Code (DartDoc/JSDoc) đến cấp độ Feature (Sequence Diagram). |
| **/security**| **SecOps** | Rà quét lỗ hổng bảo mật, hardcoded keys và mô phỏng tấn công (Pentest). |

## 🧠 The Brain: `vibecoder`

Hệ thống được vận hành bởi siêu Agent **`vibecoder`** (thay thế cho việc gọi lẻ tẻ `flutter-expert`, `tech-lead`...):
- **Polyglot:** Thích ứng tự động với Flutter, React, Python, Go, v.v.
- **Full-Stack Mindset:** Có thể code từ Database Layer lên UI Layer cùng lúc.
- **Self-Correcting:** Tự nhận biết lỗi và sửa chữa trong quá trình generate.

## 📂 Cấu trúc Mới

```text
.gemini/
├── GEMINI.md           # Core System Prompt (High Velocity Mode)
├── workflows/
│   ├── vibecode.md     # The Fast Track (Main)
│   ├── fix.md          # Unified Fix
│   ├── review.md       # Unified Review
│   └── legacy/         # Các workflow cũ (đã lưu trữ)
└── skills/
    ├── vibecoder/      # The Antigravity Agent
    └── ...             # Các skill chuyên môn khác (Plugin)
```

## ⚡ Hướng dẫn Nhanh

1.  **Đồng bộ hóa:**
    ```bash
    ./scripts/sync.sh
    ```
2.  **Bắt đầu "Bay" (Vibing):**
    ```text
    /vibe Tạo màn hình Dashboard hiển thị biểu đồ Crypto dùng Clean Arch.
    ```
    ```text
    /fix Lỗi crash khi user logout nhanh quá.
    ```

---
*Lưu ý: Các workflow cũ (`implement-feature`, `analyze`...) đã được chuyển vào thư mục `workflows/legacy/` để tham khảo.*