package com.example.adaptivelearning.service;

import com.example.adaptivelearning.model.QuizSession;
import com.example.adaptivelearning.repository.QuizSessionRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class QuizSessionService {

    private final QuizSessionRepository repository;

    public QuizSessionService(QuizSessionRepository repository) {
        this.repository = repository;
    }

   public QuizSession createSession(String sessionId, String difficulty) {
    QuizSession session = new QuizSession();
    session.setSessionId(sessionId);
    session.setDifficulty(difficulty);
    session.setIsActive(false); //  IMPORTANT

    return repository.save(session);
}

    public Optional<QuizSession> getSession(String sessionId) {
        return repository.findById(sessionId);
    }

    public List<QuizSession> getActiveSessions() {
        return repository.findByIsActiveTrue();
    }

    public Optional<QuizSession> activateSession(String id) {
    Optional<QuizSession> optional = repository.findById(id);

    optional.ifPresent(session -> {
        session.setIsActive(true);
        repository.save(session);
    });

    return optional;
}

public Optional<QuizSession> deactivateSession(String id) {
    Optional<QuizSession> optional = repository.findById(id);

    optional.ifPresent(session -> {
        session.setIsActive(false);
        repository.save(session);
    });

    return optional;
}
}