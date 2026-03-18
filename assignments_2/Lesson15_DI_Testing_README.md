# 📘 Lesson 15 — Dependency Injection + Testing

## 🎯 Цель
Научиться внедрять зависимости и писать unit тесты для ViewModel.

Темы урока:

- Dependency Injection
- `Environment`
- mock сервисы
- unit tests
- async tests

---

# 📱 Задание — Testable Architecture

Реализовать сервис загрузки пользователей и внедрить его через dependency injection.

---

## 📌 Требования

Создать протокол:

```swift
protocol UsersService
```

Создать реализации:

```swift
RealUsersService
MockUsersService
```

Использовать сервис во ViewModel через DI.

---

# 🧪 Тестирование

Создать тесты:

```
UsersViewModelTests
```

Проверить:

- успешную загрузку
- обработку ошибок
- пустое состояние

---

## 💻 Уровни выполнения

### Base

- сервис внедряется через DI
- написан минимум один unit test

### Plus

- тестируется успешная загрузка
- тестируется ошибка

### Pro

- тестируется пустое состояние
- используются async tests

---

## ✅ Критерии приёмки

- используется dependency injection
- ViewModel тестируется
- тесты проходят успешно