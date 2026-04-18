package com.example.adaptivelearning.service;

import com.example.adaptivelearning.dto.ResultRequest;
import com.example.adaptivelearning.model.Result;
import com.example.adaptivelearning.repository.ResultRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@Service
public class ResultService {

    private final ResultRepository repository;

    public ResultService(ResultRepository repository) {
        this.repository = repository;
    }

    // SAVE RESULT
    public Result save(ResultRequest request) {
        Result result = new Result(
                request.getUserId(),
                request.getDifficulty(),
                request.getType(),
                request.getScore(),
                request.getTotalQuestions(),
                request.getCorrectAnswers(),
                request.getTimeSpentSeconds()
        );
        return repository.save(result);
    }

    // GET USER HISTORY
    public List<Result> history(Long userId) {
        return repository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    // ANALYTICS (FIXED & PROPERLY PLACED)
    public Map<String, Object> analytics(Long userId) {

        List<Result> results = repository.findByUserIdOrderByCreatedAtDesc(userId);

        Map<String, Object> data = new HashMap<>();

        if (results.isEmpty()) {
            data.put("totalQuizzes", 0);
            data.put("averageAccuracy", 0);
            data.put("recentAccuracy", 0);
            data.put("latestDifficulty", "easy");
            return data;
        }

        int totalQuizzes = results.size();

        // ⚠️ Safe accuracy calculation
        double avgAccuracy = results.stream()
                .mapToDouble(r -> r.getTotalQuestions() == 0 ? 0 :
                        (r.getCorrectAnswers() * 100.0) / r.getTotalQuestions())
                .average()
                .orElse(0);

        String latestDifficulty = results.get(0).getDifficulty();

        // Java 8 compatible (instead of toList())
        List<Result> recent = results.stream()
                .limit(5)
                .collect(Collectors.toList());

        double recentAccuracy = recent.stream()
                .mapToDouble(r -> r.getTotalQuestions() == 0 ? 0 :
                        (r.getCorrectAnswers() * 100.0) / r.getTotalQuestions())
                .average()
                .orElse(0);

        double bestScore = results.stream()
        .mapToDouble(Result::getScore)
        .max()
        .orElse(0);


        data.put("totalQuizzes", totalQuizzes);
        data.put("averageAccuracy", avgAccuracy);
        data.put("recentAccuracy", recentAccuracy);
        data.put("bestScore", bestScore);
        data.put("latestDifficulty", latestDifficulty);

        return data;
    }

    // ADAPTIVE DIFFICULTY
    public String getNextDifficulty(Long userId) {

        List<Result> results = repository.findByUserIdOrderByCreatedAtDesc(userId);

        if (results.isEmpty()) return "easy";

        List<Result> recent = results.stream()
                .limit(5)
                .collect(Collectors.toList());

        double avgAccuracy = recent.stream()
                .mapToDouble(r -> r.getTotalQuestions() == 0 ? 0 :
                        (r.getCorrectAnswers() * 100.0) / r.getTotalQuestions())
                .average()
                .orElse(0);

        String current = results.get(0).getDifficulty();

        if (avgAccuracy >= 80) return increase(current);
        if (avgAccuracy < 50) return decrease(current);

        return current;
    }

    private String increase(String d) {
        return switch (d.toLowerCase()) {
            case "easy" -> "medium";
            case "medium" -> "hard";
            default -> "hard";
        };
    }

    private String decrease(String d) {
        return switch (d.toLowerCase()) {
            case "hard" -> "medium";
            case "medium" -> "easy";
            default -> "easy";
        };
    }
}