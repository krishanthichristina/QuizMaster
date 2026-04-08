package com.example.adaptivelearning.repository;
import com.example.adaptivelearning.model.Question; import java.util.List; import org.springframework.data.jpa.repository.JpaRepository;
public interface QuestionRepository extends JpaRepository<Question, Long> { List<Question> findByDifficultyIgnoreCase(String difficulty); }
