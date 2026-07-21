package com.gabrielvazquez.fintrack.dto;

import com.gabrielvazquez.fintrack.model.TransactionType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record TransactionRequest(
        @NotBlank String title,
        @NotNull @Positive BigDecimal amount,
        @NotNull TransactionType type,
        @NotBlank String categoryCode,
        @NotNull Long accountId,
        LocalDateTime date
) {}