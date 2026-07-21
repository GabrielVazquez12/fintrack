package com.gabrielvazquez.fintrack.dto;

import java.math.BigDecimal;

public record CreateAccountRequest(String name, BigDecimal balance) {}