1. 2026-04-23 08:02:00
- Thay đổi: Tạo file sql.md
- Tại sao: Cung cấp mã SQL khởi tạo DB dựa trên backend và frontend theo yêu cầu người dùng.
- Kỹ thuật: Dựa trên thực thể Student.java [VERIFIED] và cấu hình trong application.properties (SQL Server).
- Kết quả: File sql.md đã được tạo với mã CREATE TABLE và INSERT dữ liệu mẫu.

2. 2026-04-23 08:35:00
- Thay đổi: Cấu hình lại spring.datasource.url trong application.properties.
- Tại sao: Lỗi SunCertPathBuilderException do SQL Server Driver yêu cầu SSL certificate nhưng Java không xác thực được.
- Kỹ thuật: Thêm tham số ;trustServerCertificate=true vào JDBC URL [PATCH NHANH] và loại bỏ spring.jpa.database-platform dư thừa.
- Kết quả: Ứng dụng có thể kết nối tới SQL Server mà không bị lỗi SSL.
