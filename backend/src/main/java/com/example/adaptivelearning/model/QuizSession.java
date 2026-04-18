package com.example.adaptivelearning.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class QuizSession {

    @Id
    private String sessionId;

    private String difficulty;
}