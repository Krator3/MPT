# Форум: Управление пользователями

Консольное приложение на Dart для управления пользователями форума.

## 1. Описание предметной области и сущности

**Предметная область:** форум.

**Сущность:** `ForumUser` — пользователь форума.

| Поле | Тип | Назначение |
|------|-----|------------|
| id | int | Уникальный идентификатор (автоинкремент) |
| name | String | Имя пользователя |
| isActive | bool | Флаг активности |
| role | enum (Role) | Роль на форуме (user, moderator, admin) |
| bio | String? | Биография (nullable) |

**Перечисления:**
- `Role` — роль пользователя: `user`, `moderator`, `admin`
- `SortField` — поле для сортировки: `name`, `role`

## 2. Побайтовая спецификация формата data.bin

Файл `data.bin` хранит сериализованную коллекцию в бинарном формате.
Все целые числа записываются в **big-endian** порядке.

### Структура файла

| Смещение | Поле | Тип | Размер |
|----------|------|-----|--------|
| 0 | count | int32 | 4 байта |
| 4 | next_id | int32 | 4 байта |
| 8 | record_1 | Record | переменный |
| ... | ... | ... | ... |

### Структура записи (Record)

| Смещение | Поле | Тип | Размер |
|----------|------|-----|--------|
| 0 | record_data_size | int32 | 4 байта |
| 4 | id | int32 | 4 байта |
| 8 | name_length | int32 | 4 байта |
| 12 | name | UTF-8 string | name_length |
| 12 + name_length | isActive | bool (0x00/0x01) | 1 байт |
| 13 + name_length | role | enum (ordinal) | 1 байт |
| 14 + name_length | bio_flag | uint8 (0x00=null, 0x01=present) | 1 байт |
| 15 + name_length | bio_length (если present) | int32 | 4 байта |
| 19 + name_length | bio (если present) | UTF-8 string | bio_length |

**Типы:**
- `int32`: 4 байта, big-endian (IEEE 754)
- `bool`: 1 байт (0x00 = false, 0x01 = true)
- `enum`: 1 байт (ordinal index значения enum)
- `String`: 4 байта длина (int32) + N байт UTF-8
- `nullable`: 1 байт флаг (0x00=null, 0x01=present) + данные при наличии

## 3. Структура проекта

```
full_work/
├── bin/
│   └── main.dart               # Точка входа
├── lib/
│   ├── entities/
│   │   ├── binary_utils.dart   # readInt32, writeInt32, readString, writeString
│   │   ├── enums.dart          # Role, SortField
│   │   ├── identifiable.dart   # Абстрактный класс Identifiable
│   │   └── user.dart           # ForumUser (модель данных)
│   ├── services/
│   │   ├── logger_service.dart # LoggerService (асинхронное логирование через изолят)
│   │   └── user_service.dart   # UserService (бизнес-логика)
│   ├── storage/
│   │   ├── binary_storage.dart # BinaryStorage (бинарная сериализация)
│   │   └── repository.dart     # Repository (CRUD действия)
│   └── ui/
│   │   └── menu.dart           # Menu (CLI, цикл обработки команд)
│   └── exceptions.dart         # ValidationException, NotFoundException, StorageException, LogFileException
├── data.bin                    # Бинарный файл данных (создаётся при первом запуске)
├── logs.txt                    # Текстовый файл логов (создаётся при первом запуске)
├── pubspec.yaml                # Конфигурация Dart-пакета
└── README.md                   # Документация
```

## 4. Инструкция по сборке и запуску

**Требования:** Dart SDK 3.0.0+

### Запуск из исходников

```bash
dart run bin/main.dart
```

### Компиляция в исполняемый файл

```bash
dart compile exe bin/main.dart -o app.exe
./app.exe
```

### Первый запуск

При первом запуске файл `data.bin` отсутствует. Приложение автоматически создаёт пустой файл и начинает работу с пустой коллекцией. В лог записывается событие `[START] Файл data.bin не найден, создан новый`. Также добавляются 6 тестовых пользователей для демонстрации.

### Меню приложения

1. Добавить объект
2. Удалить объект (по ID)
3. Редактировать объект
4. Поиск объектов
5. Показать все (с сортировкой)
6. Статистика
7. Показать логи
8. Асинхронный отчёт (изолят)
0. Выход
