package com.example.adaptivelearning.controller;
import java.util.Map; import org.springframework.http.ResponseEntity; import org.springframework.web.bind.annotation.ExceptionHandler; import org.springframework.web.bind.annotation.RestControllerAdvice;
@RestControllerAdvice
public class GlobalExceptionHandler {
  @ExceptionHandler(RuntimeException.class)
  public ResponseEntity<Map<String, String>> handle(RuntimeException ex) { return ResponseEntity.badRequest().body(Map.of("message", ex.getMessage())); }
}
