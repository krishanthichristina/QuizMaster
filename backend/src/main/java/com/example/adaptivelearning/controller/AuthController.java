package com.example.adaptivelearning.controller;
import com.example.adaptivelearning.dto.AuthRequest;
 import com.example.adaptivelearning.model.AppUser; 
 import com.example.adaptivelearning.service.AuthService;
  import jakarta.validation.Valid; 
  import java.util.Map; 
  import org.springframework.web.bind.annotation.*;
@RestController 
@RequestMapping("/api/auth")
 @CrossOrigin(origins = "*")
public class AuthController {
  private final AuthService service;
   public AuthController(AuthService service) { this.service = service; }
  @PostMapping("/register") 
  public Map<String, Object> register(@Valid @RequestBody AuthRequest request) { AppUser user = service.register(request); return Map.of("id", user.getId(), "name", user.getName(), "email", user.getEmail(), "role", user.getRole()); }

  @PostMapping("/login")
public Map<String, Object> login(@Valid @RequestBody AuthRequest request) {

    AppUser user = service.login(request);

    if (user == null) {
        return Map.of("error", "Invalid credentials");
    }

    Map<String, Object> response = new java.util.HashMap<>();
    response.put("id", user.getId());
    response.put("name", user.getName());
    response.put("email", user.getEmail());
    response.put("role", user.getRole());

    return response;
}

}
