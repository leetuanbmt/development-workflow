---
description: "Thực thi sửa lỗi dựa trên báo cáo từ /investigate. Triển khai giải pháp có kiểm soát."
trigger: /fix
version: "2.4.0"
skills:
  - bug-investigator
  - flutter-expert
---

# 🔧 Fix Bug (Controlled Execution)

**Mục tiêu:** Triển khai sửa lỗi dựa trên báo cáo điều tra từ `/investigate`. Đảm bảo fix có kiểm soát và không gây side-effect.

## ⚠️ Điều kiện Tiên quyết (Prerequisites)

> [!IMPORTANT]
> Workflow này **BẮT BUỘC** phải chạy sau `/investigate`. Không được fix lỗi mà chưa có báo cáo điều tra.

**Kiểm tra trước khi bắt đầu:**
1. Có báo cáo điều tra với Root Cause rõ ràng không?
2. Có code snippet gợi ý từ `/investigate` không?
3. Phạm vi ảnh hưởng đã được xác định chưa?

*Nếu thiếu bất kỳ mục nào → Quay lại chạy `/investigate` trước.*

## 🚀 Các bước thực hiện (Execution Steps)

### 1. Review Báo cáo Điều tra
*   Đọc lại báo cáo từ `/investigate`.
*   Xác nhận Root Cause và giải pháp đề xuất.
*   Liệt kê các file cần sửa.

### 2. Chọn Mode Sửa lỗi
| Mode | Khi nào dùng | Quy trình |
|:--|:--|:--|
| **🚀 Quick Fix** | Lỗi đơn giản, 1 file, < 20 dòng | Sửa trực tiếp, chạy lint |
| **⚖️ Standard Fix** | Lỗi phức tạp, nhiều file | Atomic Execution, test từng phần |
| **🛡️ Critical Fix** | Lỗi ảnh hưởng data/security | Full review, backup trước khi sửa |

### 3. Thực thi Sửa lỗi (Atomic Execution)
*   **Quy tắc 150 dòng:** Không sửa quá 150 dòng trong một lần.
*   **Checkpoint:** Sau mỗi file, dừng lại xác nhận với user.
*   **Code Gen:** Nếu sửa Entity/Model → Dừng lại yêu cầu `make gen`.

### 4. Verification (Xác minh)
*   **Lint Check:** `make lint` phải pass.
*   **Reproduce Test:** Thử lại các bước gây lỗi ban đầu → Lỗi phải biến mất.
*   **Regression Check:** Chạy `make test` để đảm bảo không break tính năng cũ.

### 5. Documentation
*   Cập nhật comment nếu logic phức tạp.
*   Ghi chú trong commit message: `fix: [Bug ID] - [Mô tả ngắn]`.

## 📊 Mẫu Báo cáo Fix (Standard Format)

```markdown
## 🔧 Fix Report

### 1. Bug Reference
- **Root Cause:** [Từ /investigate]
- **Affected Files:** [Danh sách]

### 2. Changes Made
| File | Thay đổi | Dòng |
|:--|:--|:--:|
| `file_a.dart` | Thêm null check | L45 |
| `file_b.dart` | Fix logic condition | L120-125 |

### 3. Verification
- [ ] Lint passed
- [ ] Bug không còn tái hiện
- [ ] Regression test passed

### 4. Commit
`fix: [BUG-123] Sửa lỗi null pointer khi load data`
```

## 💡 Hướng dẫn cho AI
*   Luôn tham chiếu lại báo cáo `/investigate` trước khi sửa.
*   Không tự ý sửa thêm các vấn đề khác ngoài phạm vi bug.
*   Nếu phát hiện vấn đề mới trong quá trình fix → Ghi nhận và báo cáo riêng.
*   Ưu tiên fix minimal impact, không refactor lớn.
