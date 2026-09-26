-- Buoc 1: Tao bang sinh vien trong SQL Server
CREATE TABLE students (
    id INT PRIMARY KEY,
    name NVARCHAR(100),
    age INT,
    email NVARCHAR(100)
);

-- Them du lieu mau
INSERT INTO students VALUES
(1, N'Nguyễn Văn A', 20, 'a@gmail.com'),
(2, N'Trần Thị B', 21, 'b@gmail.com'),
(3, N'Lê Văn C', 19, 'c@gmail.com');
