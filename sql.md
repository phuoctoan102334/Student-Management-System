# Database Schema for Student Manager

Dưới đây là mã SQL để tạo bảng và dữ liệu mẫu cho ứng dụng, tương ứng với thực thể `Student` trong backend.

```sql
-- Bước 1: Tạo database (nếu chưa có)
-- CREATE DATABASE school;
-- USE school;

-- Bước 2: Tạo bảng sinh viên (SQL Server)
CREATE TABLE students (
    id INT PRIMARY KEY,
    name NVARCHAR(100),
    age INT,
    email NVARCHAR(100)
);

-- Bước 3: Thêm dữ liệu mẫu
INSERT INTO students (id, name, age, email) VALUES
(1, N'Nguyễn Văn A', 20, 'a@gmail.com'),
(2, N'Trần Thị B', 21, 'b@gmail.com'),
(3, N'Lê Văn C', 19, 'c@gmail.com');
```

**Thông tin kỹ thuật [VERIFIED]:**
- **Hệ quản trị:** SQL Server
- **Bảng:** `students`
- **Các cột:** `id` (PK), `name` (NVARCHAR), `age` (INT), `email` (NVARCHAR)
