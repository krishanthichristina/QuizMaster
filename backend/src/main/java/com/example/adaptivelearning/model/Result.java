package com.example.adaptivelearning.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "results")
public class Result {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  private Long userId;
  private String difficulty;
  private Integer score;
  private Integer totalQuestions;
  private Integer correctAnswers;
  private Integer timeSpentSeconds;
  private LocalDateTime createdAt = LocalDateTime.now();
  private String type; // MCQ, TF, DRAG_DROP

  public Result() {
  }

  public Result(Long userId, String difficulty, String type, Integer score,
              Integer totalQuestions, Integer correctAnswers,
              Integer timeSpentSeconds) {
    this.userId = userId;
    this.difficulty = difficulty;
    this.type = type;
    this.score = score;
    this.totalQuestions = totalQuestions;
    this.correctAnswers = correctAnswers;
    this.timeSpentSeconds = timeSpentSeconds;
}

  public Long getId() {
    return id;
  }

  public Long getUserId() {
    return userId;
  }

  public String getDifficulty() {
    return difficulty;
  }

  public Integer getScore() {
    return score;
  }

  public Integer getTotalQuestions() {
    return totalQuestions;
  }

  public Integer getCorrectAnswers() {
    return correctAnswers;
  }

  public Integer getTimeSpentSeconds() {
    return timeSpentSeconds;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public String getType() {
    return type;
}
}
