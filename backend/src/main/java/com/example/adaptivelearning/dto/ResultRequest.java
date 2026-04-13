package com.example.adaptivelearning.dto;

public class ResultRequest {
  private Long userId;
  private String difficulty;
  private Integer score;
  private String type;
  private Integer totalQuestions;
  private Integer correctAnswers;
  private Integer timeSpentSeconds;

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getDifficulty() {
    return difficulty;
  }

  public void setDifficulty(String difficulty) {
    this.difficulty = difficulty;
  }

  public Integer getScore() {
    return score;
  }

  public void setScore(Integer score) {
    this.score = score;
  }

   public String getType() { return type; }

  public void setType(String type) {
    this.type = type;
  }

  public Integer getTotalQuestions() {
    return totalQuestions;
  }

  public void setTotalQuestions(Integer totalQuestions) {
    this.totalQuestions = totalQuestions;
  }

  public Integer getCorrectAnswers() {
    return correctAnswers;
  }

  public void setCorrectAnswers(Integer correctAnswers) {
    this.correctAnswers = correctAnswers;
  }

  public Integer getTimeSpentSeconds() {
    return timeSpentSeconds;
  }

  public void setTimeSpentSeconds(Integer timeSpentSeconds) {
    this.timeSpentSeconds = timeSpentSeconds;
  }
}
