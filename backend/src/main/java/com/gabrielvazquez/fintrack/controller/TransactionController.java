package com.gabrielvazquez.fintrack.controller;

import com.gabrielvazquez.fintrack.dto.TransactionRequest;
import com.gabrielvazquez.fintrack.dto.TransactionResponse;
import com.gabrielvazquez.fintrack.model.Account;
import com.gabrielvazquez.fintrack.model.Category;
import com.gabrielvazquez.fintrack.model.Transaction;
import com.gabrielvazquez.fintrack.repository.AccountRepository;
import com.gabrielvazquez.fintrack.repository.CategoryRepository;
import com.gabrielvazquez.fintrack.repository.UserRepository;
import com.gabrielvazquez.fintrack.service.TransactionService;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {

    private final TransactionService transactionService;
    private final UserRepository userRepository;
    private final AccountRepository accountRepository;
    private final CategoryRepository categoryRepository;

    public TransactionController(TransactionService transactionService,
                                  UserRepository userRepository,
                                  AccountRepository accountRepository,
                                  CategoryRepository categoryRepository) {
        this.transactionService = transactionService;
        this.userRepository = userRepository;
        this.accountRepository = accountRepository;
        this.categoryRepository = categoryRepository;
    }

    @GetMapping
    public List<TransactionResponse> getMyTransactions(Authentication authentication) {
        Long userId = currentUserId(authentication);
        return transactionService.findByUser(userId).stream()
                .map(TransactionResponse::fromEntity)
                .toList();
    }

    @PostMapping
    public TransactionResponse create(@Valid @RequestBody TransactionRequest request,
                                       Authentication authentication) {
        currentUserId(authentication); // ensures the user exists / is authenticated

        Account account = accountRepository.findById(request.accountId())
                .orElseThrow(() -> new IllegalArgumentException("Account not found"));
        Category category = categoryRepository.findByCode(request.categoryCode())
                .orElseThrow(() -> new IllegalArgumentException("Category not found"));

        LocalDateTime date = request.date() != null ? request.date() : LocalDateTime.now();

        Transaction transaction = transactionService.create(
                request.title(), request.amount(), request.type(), date, account, category);

        return TransactionResponse.fromEntity(transaction);
    }

    private Long currentUserId(Authentication authentication) {
        return userRepository.findByEmail(authentication.getName())
                .orElseThrow(() -> new IllegalArgumentException("User not found"))
                .getId();
    }
}