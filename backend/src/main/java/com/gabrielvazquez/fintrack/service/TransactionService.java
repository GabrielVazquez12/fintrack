package com.gabrielvazquez.fintrack.service;

import com.gabrielvazquez.fintrack.model.Account;
import com.gabrielvazquez.fintrack.model.Category;
import com.gabrielvazquez.fintrack.model.Transaction;
import com.gabrielvazquez.fintrack.model.TransactionType;
import com.gabrielvazquez.fintrack.repository.TransactionRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class TransactionService {

    private final TransactionRepository transactionRepository;

    public TransactionService(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    public List<Transaction> findByUser(Long userId) {
        return transactionRepository.findByAccountUserIdOrderByDateDesc(userId);
    }

    public Transaction create(String title, BigDecimal amount, TransactionType type,
                               LocalDateTime date, Account account, Category category) {
        Transaction transaction = new Transaction(title, amount, type, date, account, category);
        return transactionRepository.save(transaction);
    }
}