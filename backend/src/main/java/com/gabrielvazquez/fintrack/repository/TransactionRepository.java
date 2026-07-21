package com.gabrielvazquez.fintrack.repository;

import com.gabrielvazquez.fintrack.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    List<Transaction> findByAccountUserIdOrderByDateDesc(Long userId);
}