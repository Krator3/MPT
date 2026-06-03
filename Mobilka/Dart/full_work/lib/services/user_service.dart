import 'dart:io';
import '../entities/enums.dart';
import '../entities/user.dart';
import '../exceptions.dart';
import '../storage/binary_storage.dart';
import '../storage/repository.dart';
import 'logger_service.dart';

class UserService {
  final Repository<ForumUser> _repository;
  final BinaryStorage<ForumUser> _storage;
  final LoggerService _logger;
  int _nextId = 1;
  int? _lastAddedId;

  UserService(this._repository, this._storage, this._logger);

  int? get lastAddedId => _lastAddedId;

  Future<void> init() async {
    try {
      final result = await _storage.load();
      _nextId = result.nextId;
      _repository.addAll(result.items);
      if (_nextId > 1) _lastAddedId = _nextId - 1;
    } on StorageException {
      await File('data.bin').writeAsBytes([0, 0, 0, 0, 0, 0, 0, 1]);
      _logger.log(ActionType.START, 'Файл data.bin не найден, создан новый');
    }
    _logger.log(ActionType.START, 'Приложение запущено');
  }

  Future<ForumUser> add(
      String name,
      bool isActive,
      Role role,
      String? bio) async {
    final user = ForumUser(
      id: _nextId++,
      name: name,
      isActive: isActive,
      role: role,
      bio: bio,
    );
    _repository.add(user);
    _lastAddedId = user.id;
    await _save();
    _logger.log(ActionType.ADD, 'Добавлен объект ID=${user.id}');
    return user;
  }

  Future<void> delete(int id) async {
    _repository.remove(id);
    await _save();
    _logger.log(ActionType.DELETE, 'Удалён объект ID=$id');
  }

  Future<void> update(ForumUser user) async {
    _repository.update(user);
    await _save();
    _logger.log(ActionType.EDIT, 'Отредактирован объект ID=${user.id}');
  }

  ForumUser? getById(int id) => _repository.getById(id);

  List<ForumUser> getAll() => _repository.getAll();

  List<ForumUser> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    final results = _repository.getAll().where((u) =>
        u.name.toLowerCase().contains(q) ||
        u.role.name.contains(q)).toList();
    _logger.log(ActionType.SEARCH, 'Поиск: "$query" — найдено ${results.length}');
    return results;
  }

  Map<String, dynamic> getStats() {
    final all = _repository.getAll();
    final active = all.where((e) => e.isActive).length;
    return {
      'total': all.length,
      'active': active,
      'inactive': all.length - active,
      'adminCount': all.where((e) => e.role == Role.admin).length,
      'moderatorCount': all.where((e) => e.role == Role.moderator).length,
      'userCount': all.where((e) => e.role == Role.user).length,
    };
  }

  Future<void> _save() async {
    await _storage.save(_repository.getAll(), _nextId);
  }
}
