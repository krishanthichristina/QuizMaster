package com.example.adaptivelearning.repository;

import com.example.adaptivelearning.model.QuizSession;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuizSessionRepository extends JpaRepository<QuizSession, String> {
    List<QuizSession> findByIsActiveTrue();
}