package com.gabrielvazquez.fintrack.service;

import com.gabrielvazquez.fintrack.model.Account;
import com.gabrielvazquez.fintrack.model.User;
import com.gabrielvazquez.fintrack.repository.AccountRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class AccountService {

    private final AccountRepository accountRepository;

    public AccountService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    public List<Account> findByUser(Long userId) {
        return accountRepository.findByUserId(userId);
    }

    public Account create(String name, BigDecimal balance, User user) {
        Account account = new Account(name, balance, user);
        return accountRepository.save(account);
    }
}