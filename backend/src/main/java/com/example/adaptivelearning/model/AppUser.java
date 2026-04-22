package com.example.adaptivelearning.model;
import jakarta.persistence.*;
@Entity @Table(name = "users")
public class AppUser {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
  private String name;
  @Column(unique = true) private String email;
  private String password;
  private String role; // STUDENT or LECTURER
  public AppUser() {}
  public AppUser(String name, String email, String password, String role) { this.name = name; this.email = email; this.password = password; this.role = role; }
  public Long getId() { return id; } public String getName() { return name; } public String getEmail() { return email; } public String getPassword() { return password; }
  public String getRole() { return role; }
}
