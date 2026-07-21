package com.gabrielvazquez.fintrack.dto;

public record AuthResponse(
        String token,
        String email,
        String name
) {}