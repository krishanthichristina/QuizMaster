package com.example.adaptivelearning.controller;

import com.example.adaptivelearning.model.AppUser;
import com.example.adaptivelearning.repository.UserRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    private final UserRepository repo;

    public UserController(UserRepository repo) {
        this.repo = repo;
    }

    @GetMapping("/students")
    public List<AppUser> getAllStudents() {
    return repo.findByRoleIgnoreCase("student");
}
}