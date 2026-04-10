package com.example.adaptivelearning.service;
import com.example.adaptivelearning.model.Question; import com.example.adaptivelearning.repository.QuestionRepository; import java.util.List; import java.util.Map; import java.util.stream.Collectors; import org.springframework.stereotype.Service;
@Service
public class QuestionService {
  private final QuestionRepository repository; public QuestionService(QuestionRepository repository) { this.repository = repository; }
  public Question save(Question question) { return repository.save(question); }
  public List<Map<String, Object>> getQuestionsByDifficulty(String difficulty) {
    return repository.findByDifficultyIgnoreCase(difficulty).stream().map(this::toMap).collect(Collectors.toList());
  }
  private Map<String, Object> toMap(Question q) { return Map.of("id", q.getId(), "difficulty", q.getDifficulty(), "title", q.getTitle(), "type", q.getType() != null ? q.getType() : "MCQ", "marks", q.getMarks() != null ? q.getMarks() : 1, "timeLimit", q.getTimeLimit() != null ? q.getTimeLimit() : 60, "options", List.of(q.getOptionA() != null ? q.getOptionA() : "", q.getOptionB() != null ? q.getOptionB() : "", q.getOptionC() != null ? q.getOptionC() : "", q.getOptionD() != null ? q.getOptionD() : ""), "correctIndex", q.getCorrectIndex()); }
}

