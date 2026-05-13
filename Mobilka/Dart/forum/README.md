# ФОРУМ — модульное CLI-приложение на Dart

Консольное приложение для управления форумом: пользователи, роли, темы и сообщения с хранением в SQLite.

## Выбранная предметная область

**Форум** — система с 4 сущностями:
- **Роли** (Role) — определяют права пользователей (admin, user)
- **Пользователи** (User) — логин, email, привязка к роли
- **Темы** (Topic) — заголовок, автор, дата создания
- **Сообщения** (Message) — текст, привязка к теме и автору

## Структура папок

```
forum/
├── pubspec.yaml
├── test.dart
├── bin/
│   └── main.dart                    # Только запуск
├── lib/
│   ├── forum.dart                   # Экспорт всех публичных частей
│   └── src/
│       ├── domain/
│       │   ├── models/              # Сущности (Role, User, Topic, Message, Identity)
│       │   └── validators/          # Валидаторы (text_validator.dart, number_validator.dart)
│       ├── data/
│       │   ├── database.dart        # Открытие SQLite, создание таблиц
│       │   └── repositories/        # CRUD-классы (role_repository, user_repository, topic_repository, message_repository)
│       └── cli/
│           ├── menu.dart            # Главное меню и команды
│           └── input_helper.dart    # Повторный ввод с валидацией
```

## Что вынесено в каждый слой и почему

| Слой | Содержание | Почему |
|------|------------|--------|
| **domain/models** | Классы-сущности с toMap/fromMap | Никакой SQL и консоли, только данные |
| **domain/validators** | Чистые функции (isNotEmptyString, isPositiveNumber) | Можно тестировать без БД и UI |
| **data/database** | Открытие SQLite, создание таблиц | Изоляция работы с БД |
| **data/repositories** | CRUD-операции (RoleRepository, UserRepository, TopicRepository, MessageRepository) | Каждая сущность — отдельный репозиторий |
| **cli/menu** | Главное меню, switch-case, вызов репозиториев | Только взаимодействие с пользователем |
| **cli/input_helper** | askString, askPositiveInt, askPositiveDouble с повторным запросом и валидацией | Переиспользование ввода с валидацией |
| **bin/main** | Точка входа, создание экземпляра ForumDatabase и вызов runMenu() | Минимум кода, только запуск и закрытие ресурсов |

## Валидация (2 типа)

`isNotEmptyString(String? value)` — строка не пустая после trim()

`bool isValidDateTime(String value)` — дата/время корректно парсится в DateTime


## Перечень тестов

| Файл | Что тестирует |
|------|---------------|
| `test.dart` | Тестирование производительности CRUD операций |

## Запуск

```shell
# Установка зависимостей
dart pub get

# Запуск приложения
dart run bin\main.dart

# Запуск тестов
dart run test.dart
```