package com.gabrielvazquez.fintrack.dto;

import com.gabrielvazquez.fintrack.model.Transaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record TransactionResponse(
        Long id,
        String title,
        BigDecimal amount,
        String type,
        String categoryCode,
        Long accountId,
        LocalDateTime date
) {
    public static TransactionResponse fromEntity(Transaction t) {
        return new TransactionResponse(
                t.getId(),
                t.getTitle(),
                t.getAmount(),
                t.getType().name(),
                t.getCategory().getCode(),
                t.getAccount().getId(),
                t.getDate()
        );
    }
}