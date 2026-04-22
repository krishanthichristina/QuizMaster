package com.example.adaptivelearning.repository;

import com.example.adaptivelearning.model.QuizSession;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuizSessionRepository extends JpaRepository<QuizSession, String> {
}