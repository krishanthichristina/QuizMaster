package com.example.adaptivelearning.controller;

import com.example.adaptivelearning.service.QuestionService;
import com.example.adaptivelearning.model.Question;

import java.util.List;
import java.util.Map;
// import java.util.stream.Collectors;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/questions")
@CrossOrigin(origins = "*")
public class QuestionController {

    private final QuestionService service;

    public QuestionController(QuestionService service) {
        this.service = service;
    }

    // ✅ Get questions by difficulty
   

    // ✅ Create a question and return updated list
    @PostMapping
    public List<Map<String, Object>> create(@RequestBody Question question) {
        // Save the new question
        service.save(question);

        // Return the full updated list of questions
        return service.getQuestionsByDifficulty(question.getDifficulty());
    }

    @GetMapping
public List<Map<String, Object>> getQuestions(
        @RequestParam(defaultValue = "easy") String difficulty) {
    return service.getQuestionsByDifficulty(difficulty);
}
@PostMapping("/bulk")
public List<Question> saveAll(@RequestBody List<Question> questions) {
    return service.saveAll(questions);
}
}