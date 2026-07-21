package com.gabrielvazquez.fintrack.repository;

import com.gabrielvazquez.fintrack.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findByCode(String code);
}