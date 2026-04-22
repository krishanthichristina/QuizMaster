package com.example.adaptivelearning.repository;
import com.example.adaptivelearning.model.Result; 
import java.util.List; 
import org.springframework.data.jpa.repository.JpaRepository;
public interface ResultRepository extends JpaRepository<Result, Long> { List<Result> findByUserIdOrderByCreatedAtDesc(Long userId); }
