package com.example.adaptivelearning.repository;

import com.example.adaptivelearning.model.AppUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface UserRepository extends JpaRepository<AppUser, Long> {

   @Query("SELECT u FROM AppUser u WHERE LOWER(u.role) = LOWER(:role)")
   List<AppUser> findByRoleIgnoreCase(String role);
    
}