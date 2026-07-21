package com.gabrielvazquez.fintrack.controller;

import com.gabrielvazquez.fintrack.config.JwtService;
import com.gabrielvazquez.fintrack.dto.AuthResponse;
import com.gabrielvazquez.fintrack.dto.LoginRequest;
import com.gabrielvazquez.fintrack.dto.RegisterRequest;
import com.gabrielvazquez.fintrack.model.User;
import com.gabrielvazquez.fintrack.service.UserService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;
    private final JwtService jwtService;

    public AuthController(UserService userService, JwtService jwtService) {
        this.userService = userService;
        this.jwtService = jwtService;
    }

    @PostMapping("/register")
    public AuthResponse register(@Valid @RequestBody RegisterRequest request) {
        User user = userService.register(request.email(), request.password(), request.name());
        String token = jwtService.generateToken(user.getEmail());
        return new AuthResponse(token, user.getEmail(), user.getName());
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest request) {
        User user = userService.login(request.email(), request.password());
        String token = jwtService.generateToken(user.getEmail());
        return new AuthResponse(token, user.getEmail(), user.getName());
    }
}