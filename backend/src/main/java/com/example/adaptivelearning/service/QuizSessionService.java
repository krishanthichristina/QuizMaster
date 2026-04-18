package com.example.adaptivelearning.service;

import com.example.adaptivelearning.model.QuizSession;
import com.example.adaptivelearning.repository.QuizSessionRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class QuizSessionService {

    private final QuizSessionRepository repository;

    public QuizSessionService(QuizSessionRepository repository) {
        this.repository = repository;
    }

    public QuizSession createSession(String sessionId, String difficulty) {
        QuizSession session = new QuizSession(sessionId, difficulty);
        return repository.save(session);
    }

    public Optional<QuizSession> getSession(String sessionId) {
        return repository.findById(sessionId);
    }
}