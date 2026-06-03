import 'dart:io';
import 'dart:isolate';
import '../entities/enums.dart';
import '../entities/user.dart';
import '../exceptions.dart';
import '../services/logger_service.dart';
import '../services/user_service.dart';

class Menu {
  final UserService _userService;
  final LoggerService _logger;

  Menu(this._userService, this._logger);

  Future<void> start() async {
    while (true) {
      _showMenu();
      final choice = stdin.readLineSync()?.trim() ?? '';
      try {
        switch (choice) {
          case '1':
            await _add();
            break;
          case '2':
            await _delete();
            break;
          case '3':
            await _edit();
            break;
          case '4':
            _search();
            break;
          case '5':
            _showAll();
            break;
          case '6':
            _showStats();
            break;
          case '7':
            await _showLogs();
            break;
          case '8':
            await _report();
            break;
          case '0':
            await _exit();
            return;
          default:
            print('Неверный выбор');
        }
      } on ValidationException catch (e) {
        print('Ошибка: $e');
      } on NotFoundException catch (e) {
        print('Ошибка: $e');
      } on StorageException catch (e) {
        _logger.log(ActionType.ERROR, 'Ошибка хранилища: $e');
        print('Ошибка хранилища: $e');
      } on LogFileException catch (e) {
        _logger.log(ActionType.ERROR, 'Ошибка лога: $e');
        print('Ошибка лога: $e');
      } catch (e) {
        _logger.log(ActionType.ERROR, 'Неизвестная ошибка: $e');
        print('Неизвестная ошибка: $e');
      }
    }
  }

  void _showMenu() {
    print('\n=== ФОРУМ: Управление пользователями ===');
    print('1. Добавить объект');
    print('2. Удалить объект (по ID)');
    print('3. Редактировать объект');
    print('4. Поиск объектов');
    print('5. Показать все (с сортировкой)');
    print('6. Статистика');
    print('7. Показать логи');
    print('8. Асинхронный отчет (изолят)');
    print('0. Выход');
    final all = _userService.getAll();
    final lastId = _userService.lastAddedId;
    if (lastId != null) {
      print('--- Объектов: ${all.length} | Последний ID: $lastId ---');
    } else {
      print('--- Объектов: ${all.length} ---');
    }
    stdout.write('Выберите действие: ');
  }

  Future<void> _add() async {
    print('--- Добавление пользователя ---');
    final name = _readString('Имя: ');
    final isActive = _readBool('Активен (y/n): ');
    _printRoles();
    final role = _readRole();
    final bio = _readNullableString('Bio (Enter для пропуска): ');
    await _userService.add(name, isActive, role, bio);
    print('Пользователь добавлен');
  }

  Future<void> _delete() async {
    print('--- Удаление пользователя ---');
    final id = _readInt('ID пользователя: ', allowZero: false);
    final user = _userService.getById(id);
    if (user == null) {
      print('Пользователь с ID=$id не найден');
      return;
    }
    await _userService.delete(id);
    print('Пользователь удалён');
  }

  Future<void> _edit() async {
    print('--- Редактирование пользователя ---');
    final id = _readInt('ID пользователя: ', allowZero: false);
    final user = _userService.getById(id);
    if (user == null) {
      print('Пользователь не найден');
      return;
    }
    print('Текущие данные:');
    print('  1. Имя: ${user.name}');
    print('  2. Активен: ${user.isActive}');
    print('  3. Роль: ${user.role.name}');
    print('  4. Bio: ${user.bio ?? "(пусто)"}');
    print('  0. Отмена');
    final field = _readInt('Какое поле изменить? ', allowZero: true);
    if (field == 0) return;
    switch (field) {
      case 1:
        user.name = _readString('Новое имя: ');
        break;
      case 2:
        user.isActive = _readBool('Активен (y/n): ');
        break;
      case 3:
        _printRoles();
        user.role = _readRole();
        break;
      case 4:
        user.bio = _readNullableString('Новое Bio (Enter = пусто): ');
        break;
      default:
        print('Неверный выбор');
        return;
    }
    await _userService.update(user);
    print('Пользователь обновлён');
  }

  void _search() {
    print('--- Поиск ---');
    final query = _readString('Поисковый запрос: ');
    final results = _userService.search(query);
    if (results.isEmpty) {
      print('Ничего не найдено');
    } else {
      _printUsers(results);
    }
  }

  void _showAll() {
    print('--- Все пользователи ---');
    print('Сортировать по: 1 - имени, 2 - роли');
    final sortChoice = _readInt('Выбор: ', allowZero: true);
    var users = _userService.getAll();
    switch (sortChoice) {
      case 1:
        _sortUsers(users, SortField.name);
        break;
      case 2:
        _sortUsers(users, SortField.role);
        break;
      default:
        _sortUsers(users, SortField.name);
    }
    _printUsers(users);
    _logger.log(ActionType.LIST, 'Выведено ${users.length} объектов');
  }

  void _showStats() {
    print('--- Статистика ---');
    final stats = _userService.getStats();
    print('Всего пользователей: ${stats['total']}');
    print('Активных: ${stats['active']}');
    print('Неактивных: ${stats['inactive']}');
    print('Админов: ${stats['adminCount']}');
    print('Модераторов: ${stats['moderatorCount']}');
    print('Пользователей: ${stats['userCount']}');
    _logger.log(ActionType.STATS, 'Просмотр статистики');
  }

  Future<void> _showLogs() async {
    print('--- Последние строки лога ---');
    try {
      final lines = await _logger.getLastLines(15);
      if (lines.isEmpty) {
        print('Лог пуст');
      } else {
        for (final line in lines) {
          print(line);
        }
      }
    } on LogFileException catch (e) {
      _logger.log(ActionType.ERROR, 'Ошибка чтения лога: $e');
      print('Ошибка: $e');
    }
    _logger.log(ActionType.VIEW_LOGS, 'Просмотр логов');
  }

  Future<void> _report() async {
    print('Отчёт генерируется...');
    _logger.log(ActionType.REPORT, 'Генерация отчёта');
    final users = _userService.getAll();
    final receivePort = ReceivePort();
    final data = <String, dynamic>{
      'sendPort': receivePort.sendPort,
      'users': users.map((u) => u.toMap()).toList(),
    };
    await Isolate.spawn(_reportIsolate, data);
    final result = await receivePort.first as Map<String, dynamic>;
    print('\n--- Асинхронный отчёт ---');
    print('Всего пользователей: ${result['total']}');
    print('Активных: ${result['active']}');
    print('Неактивных: ${result['inactive']}');
    print('Админов: ${result['adminCount']}');
    print('Модераторов: ${result['moderatorCount']}');
    print('Пользователей: ${result['userCount']}');
  }

  Future<void> _exit() async {
    _logger.log(ActionType.EXIT, 'Приложение завершено');
    await _logger.flush();
    _logger.close();
    print('До свидания!');
    exit(0);
  }

  String _readString(String prompt) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim() ?? '';
    if (input.isEmpty) throw ValidationException('Поле не может быть пустым');
    return input;
  }

  int _readInt(String prompt, {required bool allowZero}) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim() ?? '';
    final value = int.tryParse(input);
    if (value != null) {
      if (allowZero && value >= 0) return value;
      if (!allowZero && value > 0) return value;
    }
    throw ValidationException('Введите корректное число');
  }

  bool _readBool(String prompt) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    if (input == 'y' || input == 'yes' || input == 'д' || input == 'да') return true;
    if (input == 'n' || input == 'no' || input == 'н' || input == 'нет') return false;
    throw ValidationException('Введите y/n');
  }

  void _printRoles() {
    print('Роли:');
    for (var i = 0; i < Role.values.length; i++) {
      print('  ${i + 1}. ${Role.values[i].name}');
    }
  }

  Role _readRole() {
    stdout.write('Выберите роль (1-${Role.values.length}): ');
    final input = stdin.readLineSync()?.trim() ?? '';
    final value = int.tryParse(input);
    if (value != null && value >= 1 && value <= Role.values.length) {
      return Role.values[value - 1];
    }
    throw ValidationException('Введите число от 1 до ${Role.values.length}');
  }

  String? _readNullableString(String prompt) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim() ?? '';
    return input.isEmpty ? null : input;
  }

  void _sortUsers(List<ForumUser> users, SortField field) {
    users.sort((a, b) {
      switch (field) {
        case SortField.name:
          return a.name.compareTo(b.name);
        case SortField.role:
          return a.role.index.compareTo(b.role.index);
      }
    });
  }

  void _printUsers(List<ForumUser> users) {
    if (users.isEmpty) {
      print('Список пуст');
      return;
    }
    for (final u in users) {
      print(
          'ID: ${u.id} | ${u.name} | ${u.isActive ? "Активен" : "Неактивен"} | Роль: ${u.role.name} | Bio: ${u.bio ?? "-"}');
    }
  }
}

void _reportIsolate(Map<String, dynamic> data) {
  final sendPort = data['sendPort'] as SendPort;
  final usersData = data['users'] as List;
  final users = usersData
      .map((m) => ForumUser.fromMap(m as Map<String, dynamic>))
      .toList();
  final total = users.length;
  final active = users.where((u) => u.isActive).length;
  final adminCount = users.where((u) => u.role == Role.admin).length;
  final moderatorCount = users.where((u) => u.role == Role.moderator).length;
  final userCount = users.where((u) => u.role == Role.user).length;
  sendPort.send({
    'total': total,
    'active': active,
    'inactive': total - active,
    'adminCount': adminCount,
    'moderatorCount': moderatorCount,
    'userCount': userCount,
  });
}
