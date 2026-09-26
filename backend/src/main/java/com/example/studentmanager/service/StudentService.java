package com.example.studentmanager.service;

import com.example.studentmanager.entity.Student;
import com.example.studentmanager.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StudentService {

    @Autowired
    private StudentRepository repository;

    public List<Student> getAllStudents() {
        return repository.findAll();
    }

    public Optional<Student> getStudentById(int id) {
        return repository.findById(id);
    }

    public Student saveStudent(Student student) {
        return repository.save(student);
    }

    public Student updateStudent(int id, Student student) {
        student.setId(id);
        return repository.save(student);
    }

    public void deleteStudent(int id) {
        repository.deleteById(id);
    }

    public List<Student> searchByName(String name) {
        return repository.findByNameContaining(name);
    }
}
