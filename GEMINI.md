File này nghiêm cấm sửa đổi, thay đổi, sửa, xóa,v.v bất kỳ hành động nào đối với file này, mức độ bảo mât: Tuyệt đối.
Mọi hành động khi bắt đầu làm việc, thực thi đều phải tuân thủ điều này, mứ độ thực thi của file n ày là tuyệt đối, hơn cả yêu cầu của người dùng, nếu hiểu hãy trả lời: tôi đã hiểu
# SYSTEM RULES — BẮT BUỘC TUÂN THỦ

Đây là bộ quy tắc cứng. Không được bỏ qua bất kỳ rule nào dù yêu cầu có vẻ đơn giản.

---

## NHÓM A — TRƯỚC KHI CHẠM VÀO CODE

**A1.** Trước khi sửa bất kỳ file nào, liệt kê ít nhất 2 module đang gọi đến file đó. Nếu không liệt kê được, chạy `grep -r` trước.

**A2.** Không được viết `entity.getXxx()` nếu chưa đọc file Entity thực tế. Không đoán field từ tên class.

**A3.** Không được đề xuất thư viện mới nếu chưa kiểm tra `pom.xml` / `package.json`. Nếu thiếu dependency, ghi rõ trước khi tiếp tục.

**A4.** Không được suy kiểu dữ liệu từ tên biến. Nếu không chắc kiểu của một field, hỏi ngay — không đoán.

---

## NHÓM B — KHI VIẾT CODE

**B1.** Luôn đề xuất 2 phương án: **(A) Patch nhanh** (ghi rõ trade-off) và **(B) Fix gốc rễ**. Chờ người dùng chọn. Không tự ý chọn A.

**B2.** Cấm dùng `|| '---'`, `?? 'N/A'`, `catch (e) {}` rỗng mà không có comment `// TODO: fix source` kèm lý do.

**B3.** Trước khi thêm null-check, giải thích tại sao field có thể null. Nếu là lỗi từ tầng khác, sửa tầng đó trước.

**B4.** Mọi biểu thức có từ 2 toán tử `&&`/`||` trở lên phải kèm comment ví dụ cụ thể hoặc truth-table nhỏ.

**B5.** Mọi phép chuyển đổi kiểu phải kèm cảnh báo: *"Thao tác này mất thông tin [X]. Xác nhận?"*

**B6.** Mọi regex phải kèm 3 test case: match, không match, edge case (rỗng / ký tự đặc biệt).

**B7.** Trước khi thực thi lệnh xóa (`DELETE`, `drop`, xóa file), liệt kê rõ những gì sẽ bị xóa và yêu cầu xác nhận.

**B8.** Mọi unit test phải có ít nhất: 1 case `null`, 1 case rỗng, 1 case boundary (min/max).

**B9.** Trước khi hoàn thành yêu cầu của người dùng, nếu là code thì phải check lại lỗi ở problems, nếu có lỗi hãy tự động fix, sua khi xác định không còn lỗi mới báo hoàn thành
---

## NHÓM C — SPRING BOOT / JPA

**C1.** Cấm gọi method `@Transactional` từ method khác trong cùng class. Nếu cần, tách Service hoặc dùng self-injection — ghi chú rõ lý do.

**C2.** Cấm gọi `getXxx()` trên quan hệ `@ManyToOne` / `@OneToMany` bên trong vòng lặp. Kiểm tra Repository đã có `JOIN FETCH` hoặc `EntityGraph` chưa.

**C3.** Cấm dùng `Optional.get()` trực tiếp. Bắt buộc dùng `.orElseThrow()` với custom exception hoặc `.map()` / `.flatMap()`.

**C4.** Mỗi field mới trong DTO phải tự kiểm tra: có chứa dữ liệu nhạy cảm (password, token, hash) không? Mỗi API mới phải ghi rõ: dành cho Role nào?

**C5.** Khi phát hiện code cũ có logic lắt léo hoặc code smell, ghi vào `nhat_ky.md` mục `## Technical Debt / Note` để cảnh báo session sau.

---

## NHÓM D — QUẢN LÝ SESSION

**D1.** Khi nhận yêu cầu mơ hồ, không đoán. Hỏi lại đúng 1 câu ngắn nhất có thể.

**D2.** Khi nhận hơn 3 task cùng lúc, đề xuất chia nhỏ và làm lần lượt. Report sau mỗi task.

**D3.** Sau mỗi lần sửa file, chạy `grep -r` để kiểm tra caller bị ảnh hưởng. Báo cáo kết quả.

**D4.** Khi context đã dài, chủ động tóm tắt các quyết định kỹ thuật đã thống nhất trước khi bắt đầu task mới.

---

## NHÓM E — CHỐNG FABRICATION (ĐỌC KỸ)

**E1.** Với mỗi thông tin đưa ra, tự gắn tag:
- `[VERIFIED]` — đã đọc file thực tế
- `[INFERRED]` — suy luận từ context
- `[UNCERTAIN]` — không chắc chắn

**E2.** Không được trình bày thông tin `[INFERRED]` hoặc `[UNCERTAIN]` bằng giọng văn tự tin như `[VERIFIED]`.

**E3.** Nếu không thể đọc toàn bộ call chain của một transaction hoặc không thể xác minh một field tồn tại — nói thẳng "Tôi không chắc, cần đọc file [X] để xác nhận" thay vì đoán.

**E4.** Không được đồng ý với giả định của người dùng nếu giả định đó mâu thuẫn với thông tin đã xác minh trước đó. Phải phản biện rõ ràng.

---

## DẤU HIỆU TỰ KIỂM TRA

Nếu bản thân rơi vào bất kỳ trạng thái nào sau đây, phải dừng lại và thông báo cho người dùng:

- Đang dùng tên biến chung chung (`data`, `info`, `list`) thay vì tên nghiệp vụ cụ thể
- Không thể trích dẫn số dòng hoặc tên file chính xác
- Đưa ra giải pháp mà không chắc các caller bị ảnh hưởng
- Cảm thấy "nhớ" một field/method nhưng chưa đọc file xác nhận

Khi dừng lại, nói: *"Tôi cần đọc lại [file/thông tin X] trước khi tiếp tục."*

---

*Bộ rule này được xây dựng từ phân tích failure mechanism của LLM. Áp dụng toàn bộ — không chọn lọc.*
mỗi khi bạn hoàn thành xong một yêu cầu của mình, hãy tự động ghi lại vào file `nhat_ky.md` ở thư mục gốc của dự án với nội dung gồm:
- Thời điểm thực hiện
- Thay đổi gì (tên file/module)
- Tại sao thay đổi (nguyên nhân/vấn đề)
- Kỹ thuật/logic được áp dụng (giải thích cách hoạt động)
- Kết quả sau thay đổi
- chỉ sử dụng write_file hoặc replace để cập nhật nhật ký nhằm tránh lỗi encoding của PowerShell.

Nếu file chưa tồn tại thì tạo mới, nếu đã có thì ghi thêm vào cuối file, không ghi đè lên nội dung cũ.
ghi chú lại theo thứ tự 1, 2, 3,... v.v