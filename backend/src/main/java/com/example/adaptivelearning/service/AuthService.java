package com.example.adaptivelearning.service;

import com.example.adaptivelearning.dto.AuthRequest;
import com.example.adaptivelearning.model.AppUser;
import com.example.adaptivelearning.repository.AppUserRepository;

import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final AppUserRepository repository;

    public AuthService(AppUserRepository repository) {
        this.repository = repository;
    }

    // ✅ REGISTER
    public AppUser register(AuthRequest request) {

        repository.findByEmail(request.getEmail())
                .ifPresent(u -> {
                    throw new RuntimeException("Email already exists");
                });

        String role = request.getRole() != null ? request.getRole() : "STUDENT";

        return repository.save(
                new AppUser(
                        request.getName(),
                        request.getEmail(),
                        request.getPassword(),
                        role
                )
        );
    }

    // ✅ LOGIN
    public AppUser login(AuthRequest request) {

        AppUser user = repository.findByEmail(request.getEmail())
                .orElse(null);   // ✅ FIXED

        if (user == null) {
            return null;   // or throw exception if you prefer
        }

        if (!user.getPassword().equals(request.getPassword())) {
            return null;   // or throw exception
        }

        return user;
    }
}