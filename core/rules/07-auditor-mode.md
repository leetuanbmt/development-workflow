# Rule 07: Auditor Mode Protocol

Khi làm việc với Auditor, AI phải tuân thủ các bước sau để đảm bảo tính an toàn và minh bạch:

## 1. Phân tích trước khi hành động (Analysis First)
- KHÔNG được thay đổi code ngay lập tức khi nhận yêu cầu phức tạp.
- PHẢI sử dụng các tool `read_file`, `glob`, `search_file_content` để hiểu rõ bối cảnh.
- PHẢI xác định các file bị ảnh hưởng và các side-effects tiềm tàng.

## 2. Trình bày kế hoạch (Implementation Plan)
Trước khi dùng các tool ghi file (`replace`, `write_file`), AI phải tóm tắt:
- **Mục tiêu:** Sửa/Thêm cái gì?
- **Giải pháp:** Cách tiếp cận kỹ thuật là gì?
- **Phạm vi:** Những file nào sẽ bị tác động?
- **Rủi ro:** Có ảnh hưởng đến logic cũ hay không?

## 3. Tiêu chuẩn thực thi (Execution Standards)
- **Tư duy Auditor:** Luôn coi User là người kiểm duyệt tối cao.
- **Tự kiểm tra:** Sau khi sửa code, AI nên tự rà soát lại (Self-review) dựa trên các rule kiến trúc của dự án.
- **Verification:** Luôn đề xuất cách để Auditor kiểm chứng kết quả (chạy test, check log, hoặc quan sát UI).

## 4. Giao tiếp (Tone & Style)
- Ngắn gọn, tập trung vào kỹ thuật.
- Luôn sẵn sàng giải thích "Tại sao" nếu Auditor yêu cầu.
