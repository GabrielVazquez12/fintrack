package com.gabrielvazquez.fintrack.config;

import com.gabrielvazquez.fintrack.model.Category;
import com.gabrielvazquez.fintrack.model.TransactionType;
import com.gabrielvazquez.fintrack.repository.CategoryRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class CategorySeeder implements CommandLineRunner {

    private final CategoryRepository categoryRepository;

    public CategorySeeder(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    public void run(String... args) {
        if (categoryRepository.count() > 0) return;

        seed("food", "Comida", TransactionType.EXPENSE);
        seed("transport", "Transporte", TransactionType.EXPENSE);
        seed("housing", "Vivienda", TransactionType.EXPENSE);
        seed("entertainment", "Entretenimiento", TransactionType.EXPENSE);
        seed("health", "Salud", TransactionType.EXPENSE);
        seed("other", "Otros", TransactionType.EXPENSE);

        seed("salary", "Salario", TransactionType.INCOME);
        seed("freelance", "Freelance", TransactionType.INCOME);
        seed("gift", "Regalo", TransactionType.INCOME);
        seed("other_income", "Otros", TransactionType.INCOME);
    }

    private void seed(String code, String name, TransactionType type) {
        categoryRepository.save(new Category(code, name, type));
    }
}