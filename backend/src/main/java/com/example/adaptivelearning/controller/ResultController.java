package com.example.adaptivelearning.controller;

import com.example.adaptivelearning.dto.ResultRequest;
import com.example.adaptivelearning.model.Result;
import com.example.adaptivelearning.service.ResultService;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ResultController {
  private final ResultService service;

  public ResultController(ResultService service) {
    this.service = service;
  }

  @PostMapping("/results")
  public Result save(@RequestBody ResultRequest request) {
    return service.save(request);
  }

  @GetMapping("/results/user/{userId}")
  public List<Result> history(@PathVariable Long userId) {
    return service.history(userId);
  }

  @GetMapping("/analytics/user/{userId}")
  public Map<String, Object> analytics(@PathVariable Long userId) {
    return service.analytics(userId);
  }

  @GetMapping("/next-difficulty/{userId}")
public String nextDifficulty(@PathVariable Long userId) {
    return service.getNextDifficulty(userId);
}
}
