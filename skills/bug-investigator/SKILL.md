---
name: bug-investigator
description: Chuyên gia điều tra và xử lý lỗi. Giúp tìm nguyên nhân gốc rễ và đề xuất giải pháp fix bug bền vững.
---

# Bug Investigator Skill (Kansuke Edition)

Sử dụng Skill này khi hệ thống gặp lỗi (crash, logic sai, UI không hiển thị đúng) và cần tìm nguyên nhân gốc rễ (Root Cause Analysis). Kích hoạt khi phát hiện: "lỗi", "bug", "crash", "không chạy đúng", "stacktrace", "error log".

## 🚀 When to use
- Khi người dùng báo cáo một hành vi sai lệch so với Spec.
- Khi có Error Log hoặc Stacktrace từ hệ thống.
- Khi một tính năng cũ bỗng dưng chạy sai sau khi cập nhật code mới.
- Khi cần phân tích luồng dữ liệu phức tạp để tìm điểm "gãy".

## 🛑 When NOT to use
- Không dùng để review code mới (dùng `code-reviewer`).
- Không dùng để thiết kế tính năng mới (dùng `feature-architect`).
- Không dùng để tối ưu performance (dùng `flutter-expert`).

## 💡 Example Triggers
- "Tại sao màn hình Kotei lại bị trắng xóa khi mất mạng?"
- "Điều tra giúp mình lỗi 'Null check operator used on a null value' ở file này."
- "App bị crash khi mình bấm nút Save, đây là log lỗi..."
- "Tìm nguyên nhân tại sao dữ liệu không được lưu vào Local DB."

## 🕵️ Phương pháp Điều tra
... (giữ nguyên phần Phương pháp)- Đặt câu hỏi "Nếu... thì sao?": Nếu API trả về null? Nếu mạng chậm?
- Kiểm tra các file test hiện có để xem có case nào bị bỏ sót không.

## 📋 Cấu trúc Báo cáo Điều tra

Kết quả điều tra cần được trình bày rõ ràng theo 3 phần chính:

### 1. Nguyên nhân
- **Root Cause:** Chỉ đích danh đoạn code, logic hoặc cấu hình gây ra lỗi.
- **Tại sao:** Giải thích cơ chế gây lỗi (ví dụ: race condition, null reference, sai logic nghiệp vụ).

### 2. Phạm vi ảnh hưởng
- **Tính năng:** Những tính năng/màn hình nào bị tác động?
- **Mức độ:** Nghiêm trọng (Crash/Blocker) hay Nhẹ (UI Glitch)?
- **Lan truyền:** Việc sửa lỗi có nguy cơ gây regression ở đâu không?

### 3. Cách xử lý
- **Giải pháp:** Đề xuất code fix sạch sẽ, tuân thủ Clean Architecture.
- **Code Change:** Snippet mô tả thay đổi (Gợi ý).
- **Phòng ngừa:** Gợi ý test case hoặc refactor để tránh lặp lại.

## 💡 Chỉ dẫn cho AI (QUAN TRỌNG)
- **NO CODE EDITING:** Bạn KHÔNG ĐƯỢC PHÉP chỉnh sửa file code trong quá trình điều tra.
- **READ ONLY:** Chỉ sử dụng các tool đọc (`read_file`, `search_file_content`, `glob`) để thu thập thông tin.
- **REPORT ONLY:** Nhiệm vụ của bạn kết thúc khi đưa ra báo cáo. Việc sửa lỗi thuộc về bước tiếp theo hoặc lệnh khác.
- Luôn kiểm tra logs trước khi đưa ra giả thuyết.
- Khi fix bug trong BLoC, hãy chú ý đến các `Stream` và `Subscription`.
- Đảm bảo fix bug không phá vỡ các tính năng hiện có (Regression checking).

## 🔌 Interface Definition

### Inputs
- **stacktrace** (text): Error log hoặc Stacktrace
- **behavior** (text): Mô tả hành vi lỗi của user

### Outputs
- **root_cause** (markdown): Phân tích nguyên nhân gốc rễ
- **fix_plan** (markdown): Kế hoạch sửa lỗi
