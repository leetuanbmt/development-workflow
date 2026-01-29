---
description: "Phân tích sâu nguyên nhân lỗi và xuất báo cáo điều tra. CHỈ report, KHÔNG sửa code."
trigger: /investigate
version: "3.1.0"
skills:
  - bug-investigator
constraints:
  max_iterations: 3
  timeout_minutes: 15
  exit_on: ["Report generated"]
  no_code_edit: true
---

# 🕵️ Bug Investigation Protocol

**Mục tiêu:** Tìm ra nguyên nhân gốc rễ (Root Cause) và đánh giá tác động. **KHÔNG tự động sửa code.**

## 🚀 Execution Steps

### 1. Context Gathering
- Đọc log lỗi (nếu có)
- Đọc code tại vị trí nghi ngờ
- Trace luồng dữ liệu: UI → BLoC → UseCase → Repository

### 2. Root Cause Analysis
- Tại sao lỗi xảy ra? (Logic sai, Null pointer, Race condition, API change?)
- Xác minh giả thuyết bằng bằng chứng trong code

### 3. Impact Analysis
- Lỗi ảnh hưởng đến file/feature nào?
- Mức độ nghiêm trọng (Blocker/Major/Minor)

### 4. Generate Report

## 📝 Report Template (BẮT BUỘC)

```markdown
**Tên Vấn đề**
[Mô tả ngắn gọn lỗi]

***Nguyên nhân***
[Giải thích kỹ thuật chi tiết với file:line reference]

***Phạm vi ảnh hưởng***
- File chính: `path/to/file.dart:line`
- Module liên quan: [list]
- Mức độ: [Blocker/Major/Minor]

***Cách xử lý***
1. [Bước cụ thể với code snippet]
2. [Bước tiếp theo]
```

## 💡 AI Guidelines
- **Fact-Check:** Nguyên nhân phải dựa trên bằng chứng, không đoán
- **NO CODE EDIT:** Chỉ đọc và report
- **Next Step:** Báo cho user dùng `/fix` nếu muốn sửa
