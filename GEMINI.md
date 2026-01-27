# Gemini CLI Configuration

Đây là file cấu hình system prompt cho Gemini CLI khi làm việc với dự án the project.

## Hướng dẫn sử dụng

1. **Sync môi trường:** Chạy `./$(basename $(pwd))/scripts/sync.sh` từ thư mục gốc dự án.

2. **Workflows:** Xem danh sách tại `.gemini/commands/` hoặc gõ `/help`.

3. **Skills:** AI sẽ tự động kích hoạt skill phù hợp dựa trên context.

## Nguyên tắc cốt lõi

- **Atomic Execution:** Chia nhỏ task, không code quá 150 dòng/lần.
- **Code Gen Checkpoint:** AI dừng lại khi cần chạy `make gen`.
- **Proactive Memory:** Tự đề xuất lưu bài học kinh nghiệm.

## Liên kết

- [README](./README.md) - Tổng quan workflow
- [CHEAT_SHEET](./CHEAT_SHEET.md) - Hướng dẫn nhanh
- [CHANGELOG](./CHANGELOG.md) - Lịch sử thay đổi
