package com.example.adaptivelearning.controller;

import com.example.adaptivelearning.dto.CreateSessionRequest;
import com.example.adaptivelearning.model.QuizSession;
import com.example.adaptivelearning.service.QuizSessionService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin("*")
public class QuizSessionController {

    private final QuizSessionService service;

    public QuizSessionController(QuizSessionService service) {
        this.service = service;
    }

    @PostMapping("/session")
public QuizSession create(@RequestBody CreateSessionRequest request) {
    return service.createSession(
            request.getSessionId(),
            request.getDifficulty()
    );
}

    @GetMapping("/session/{id}")
public ResponseEntity<?> get(@PathVariable String id, @RequestHeader(value = "User-Agent", required = false) String userAgent) {
    return service.getSession(id)
            .map(session -> {
                // If accessed via a browser (not the app), we can provide a friendly message or redirect
                // For now, let's keep it returning the session object but ensure it's JSON
                return ResponseEntity.ok(session);
            })
            .orElse(ResponseEntity.notFound().build());
}

@GetMapping("/sessions/active")
public List<QuizSession> getActiveSessions() {
    return service.getActiveSessions();
}

@PutMapping("/session/{id}/start")
public ResponseEntity<QuizSession> startSession(@PathVariable String id) {
    return service.activateSession(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
}

@PutMapping("/session/{id}/stop")
public ResponseEntity<QuizSession> stopSession(@PathVariable String id) {
    return service.deactivateSession(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
}
}