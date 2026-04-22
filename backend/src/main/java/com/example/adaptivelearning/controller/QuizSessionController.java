package com.example.adaptivelearning.controller;

import com.example.adaptivelearning.model.QuizSession;
import com.example.adaptivelearning.service.QuizSessionService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin("*")
public class QuizSessionController {

    private final QuizSessionService service;

    public QuizSessionController(QuizSessionService service) {
        this.service = service;
    }

    @PostMapping("/session")
    public QuizSession create(@RequestBody Map<String, String> body) {
        return service.createSession(
                body.get("sessionId"),
                body.get("difficulty")
        );
    }

    @GetMapping("/session/{id}")
public ResponseEntity<QuizSession> get(@PathVariable String id) {
    return service.getSession(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
}
}