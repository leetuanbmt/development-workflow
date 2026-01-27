# Gemini CLI Configuration

Đây là file cấu hình system prompt cho Gemini CLI khi làm việc với dự án the project.

## Hướng dẫn sử dụng

1. **Sync môi trường:** Chạy `./$(basename $(pwd))/scripts/sync.sh` từ thư mục gốc dự án.

2. **Workflows:** Xem danh sách tại `.gemini/commands/` hoặc gõ `/help`.

3. **Skills:** AI sẽ tự động kích hoạt skill phù hợp dựa trên context.

## Nguyên tắc cốt lõi (AI-Native & High Velocity)

- **Antigravity Execution:** Tận dụng tối đa Context Window lớn (1M+ tokens). Không giới hạn số dòng code trong một lần output, ưu tiên hoàn thành trọn vẹn logic module/feature thay vì chia nhỏ vụn vặt.
- **Vibecoding Mindset:** Tập trung vào luồng tư duy (Flow), tốc độ triển khai và tính nhất quán toàn cục. AI chủ động phân tích kiến trúc và thực thi mà không cần các bước trung gian rườm rà.
- **Context-First:** Luôn quét và hiểu cấu trúc dự án hiện tại trước khi thực hiện thay đổi.
- **Proactive Execution:** Tự động chạy các lệnh bổ trợ (lint, format, gen) nếu được phép để duy trì đà làm việc.
- **Proactive Memory:** Tự đề xuất lưu bài học kinh nghiệm và các pattern thiết kế của dự án.

## Liên kết

- [README](./README.md) - Tổng quan workflow
- [CHEAT_SHEET](./CHEAT_SHEET.md) - Hướng dẫn nhanh
- [CHANGELOG](./CHANGELOG.md) - Lịch sử thay đổi
