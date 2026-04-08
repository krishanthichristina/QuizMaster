package com.example.adaptivelearning.model;
import jakarta.persistence.*;
@Entity @Table(name = "questions")
public class Question {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
  private String difficulty; private String title; private String type; // MCQ, TF, DRAG_DROP
  @Column(name = "option_a") private String optionA;
  @Column(name = "option_b") private String optionB;
  @Column(name = "option_c") private String optionC;
  @Column(name = "option_d") private String optionD;
  private Integer correctIndex;
  public Question() {}
  public Long getId() { return id; } public String getDifficulty() { return difficulty; } public String getTitle() { return title; } public String getOptionA() { return optionA; } public String getOptionB() { return optionB; } public String getOptionC() { return optionC; } public String getOptionD() { return optionD; } public Integer getCorrectIndex() { return correctIndex; }
  public String getType() { return type; }
  public void setType(String type) { this.type = type; }
  public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
  public void setTitle(String title) { this.title = title; }
  public void setOptionA(String optionA) { this.optionA = optionA; }
  public void setOptionB(String optionB) { this.optionB = optionB; }
  public void setOptionC(String optionC) { this.optionC = optionC; }
  public void setOptionD(String optionD) { this.optionD = optionD; }
  public void setCorrectIndex(Integer correctIndex) { this.correctIndex = correctIndex; }
}
