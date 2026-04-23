package com.example.studentmanager.controller;

import com.example.studentmanager.entity.Student;
import com.example.studentmanager.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/students")
public class StudentRestController {

    @Autowired
    private StudentService studentService;

    // Yeu cau 5: Lay danh sach sinh vien - Get All
    @GetMapping
    public List<Student> getAll() {
        return studentService.getAllStudents();
    }

    // Yeu cau 4: Lay sinh vien theo ID
    @GetMapping("/{id}")
    public Student getById(@PathVariable int id) {
        return studentService.getStudentById(id).orElse(null);
    }

    // Yeu cau 3: Tim kiem sinh vien theo ten
    @GetMapping("/search")
    public List<Student> search(@RequestParam String name) {
        if (name == null || name.trim().isEmpty()) {
            return studentService.getAllStudents();
        }
        return studentService.searchByName(name.trim());
    }

    // Yeu cau 1: Them sinh vien
    @PostMapping
    public Student add(@RequestBody Student student) {
        return studentService.saveStudent(student);
    }

    // Yeu cau 6: Cap nhat sinh vien
    @PostMapping("/update/{id}")
    public Student update(@PathVariable int id, @RequestBody Student student) {
        // Đảm bảo ID đồng bộ với PathVariable
        student.setId(id);
        return studentService.saveStudent(student);
    }

    // Yeu cau 2: Xoa sinh vien
    @PostMapping("/delete/{id}")
    public String delete(@PathVariable int id) {
        if (studentService.getStudentById(id).isPresent()) {
            studentService.deleteStudent(id);
            return "Deleted student " + id;
        }
        return "Student not found with ID " + id;
    }
}
