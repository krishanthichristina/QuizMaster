package com.example.adaptivelearning.service;
import com.example.adaptivelearning.dto.ResultRequest; import com.example.adaptivelearning.model.Result; import com.example.adaptivelearning.repository.ResultRepository; import java.util.HashMap; import java.util.List; import java.util.Map; import org.springframework.stereotype.Service;
@Service
public class ResultService {
  private final ResultRepository repository; public ResultService(ResultRepository repository) { this.repository = repository; }
  public Result save(ResultRequest request) { return repository.save(new Result(request.getUserId(), request.getDifficulty(), request.getScore(), request.getTotalQuestions(), request.getCorrectAnswers(), request.getTimeSpentSeconds())); }
  public List<Result> history(Long userId) { return repository.findByUserIdOrderByCreatedAtDesc(userId); }
  public Map<String, Object> analytics(Long userId) {
    List<Result> results = repository.findByUserIdOrderByCreatedAtDesc(userId); Map<String, Object> data = new HashMap<>();
    data.put("totalQuizzes", results.size()); data.put("averageScore", results.stream().mapToInt(Result::getScore).average().orElse(0)); data.put("bestScore", results.stream().mapToInt(Result::getScore).max().orElse(0));
    return data;
  }
}
