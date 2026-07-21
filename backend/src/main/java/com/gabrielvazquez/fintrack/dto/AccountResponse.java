package com.gabrielvazquez.fintrack.dto;

import com.gabrielvazquez.fintrack.model.Account;
import java.math.BigDecimal;

public record AccountResponse(Long id, String name, BigDecimal balance) {
    public static AccountResponse fromEntity(Account a) {
        return new AccountResponse(a.getId(), a.getName(), a.getBalance());
    }
}