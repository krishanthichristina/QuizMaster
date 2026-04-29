package com.example.adaptivelearning.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class QuizSession {

    @Id
    private String sessionId;

    private String difficulty;

    private boolean isActive; 

   

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    // 🔥 IMPORTANT PART
    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) { 
        this.isActive = isActive;
    }
}