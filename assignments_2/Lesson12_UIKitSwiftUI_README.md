# 📘 Lesson 13 — UIKit + SwiftUI Integration

## 🎯 Цель
Познакомиться с UIKit и научиться интегрировать UIKit и SwiftUI.

Темы урока:

- `UIViewController`
- создание UI через код
- AutoLayout
- `UIHostingController`
- `UIViewControllerRepresentable`

---

# 📱 Задание — UIKit Profile Screen

Создайте экран профиля пользователя на UIKit.

Экран должен быть реализован **через код** и использовать **AutoLayout**.

---

## 📌 Требования

Создать:

```
ProfileViewController
```

UI должен содержать:

- `UIImageView` — аватар
- `UILabel` — имя
- `UILabel` — email
- `UIButton` — Follow

---

## 📌 AutoLayout

Использовать:

- `NSLayoutConstraint`
- anchors

Пример:

```swift
view.addSubview(nameLabel)
nameLabel.translatesAutoresizingMaskIntoConstraints = false
```

---

## 📌 Интеграция со SwiftUI

Создать wrapper:

```swift
struct ProfileControllerWrapper: UIViewControllerRepresentable
```

и использовать его внутри SwiftUI.

---

## 💻 Уровни выполнения

### Base

- создан UIKit экран
- используется AutoLayout
- экран встроен в SwiftUI

### Plus

- добавлена обработка кнопки Follow
- добавлена кастомная карточка пользователя

### Pro

- экран получает данные из SwiftUI ViewModel
- поддерживается Dark Mode

---

## ✅ Критерии приёмки

- экран создан через код
- используется AutoLayout
- UIKit экран работает внутри SwiftUI
- приложение запускается без ошибок