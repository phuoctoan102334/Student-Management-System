package com.example.studentmanager.controller;

import com.example.studentmanager.entity.Student;
import com.example.studentmanager.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class StudentController {
    @Autowired
    private StudentService studentService;

    @GetMapping("/students")
    public String listStudents(Model model) {

        List<Student> students = studentService.getAllStudents();
        model.addAttribute("students", students);
        return "students"; // students.html
    }
}
