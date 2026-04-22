package com.example.adaptivelearning.service;

import com.example.adaptivelearning.dto.ResultRequest;
import com.example.adaptivelearning.model.Result;
import com.example.adaptivelearning.repository.ResultRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ResultService {

    private final ResultRepository repository;

    public ResultService(ResultRepository repository) {
        this.repository = repository;
    }

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

    public List<Result> history(Long userId) {
        return repository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public String getNextDifficulty(Long userId) {

        List<Result> results = repository.findByUserIdOrderByCreatedAtDesc(userId);

        if (results.isEmpty()) return "easy";

        List<Result> recent = results.stream().limit(5).toList();

        double avgAccuracy = recent.stream()
                .mapToDouble(r -> (r.getCorrectAnswers() * 100.0) / r.getTotalQuestions())
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