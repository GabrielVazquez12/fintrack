package com.gabrielvazquez.fintrack.controller;

import com.gabrielvazquez.fintrack.model.Account;
import com.gabrielvazquez.fintrack.repository.UserRepository;
import com.gabrielvazquez.fintrack.service.AccountService;
import com.gabrielvazquez.fintrack.model.User;
import com.gabrielvazquez.fintrack.dto.AccountResponse;
import com.gabrielvazquez.fintrack.dto.CreateAccountRequest;
import com.gabrielvazquez.fintrack.dto.AccountResponse;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/accounts")
public class AccountController {

    private final AccountService accountService;
    private final UserRepository userRepository;

    public AccountController(AccountService accountService, UserRepository userRepository) {
        this.accountService = accountService;
        this.userRepository = userRepository;
    }

    @GetMapping
    public List<AccountResponse> getMyAccounts(Authentication authentication) {
        String email = authentication.getName();
        Long userId = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"))
                .getId();
        return accountService.findByUser(userId).stream()
                .map(AccountResponse::fromEntity)
                .toList();
    }

    @PostMapping
    public AccountResponse create(@RequestBody CreateAccountRequest request, Authentication authentication) {
        String email = authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        Account account = accountService.create(request.name(), request.balance(), user);
        return AccountResponse.fromEntity(account);
    }
}