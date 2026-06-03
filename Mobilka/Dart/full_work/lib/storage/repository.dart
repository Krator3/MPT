import '../entities/identifiable.dart';
import '../exceptions.dart';

class Repository<T extends Identifiable> {
  final Map<int, T> _items = {};

  void add(T item) {
    _items[item.getId()] = item;
  }

  void remove(int id) {
    if (!_items.containsKey(id)) {
      throw NotFoundException('Объект с ID=$id не найден');
    }
    _items.remove(id);
  }

  void update(T item) {
    if (!_items.containsKey(item.getId())) {
      throw NotFoundException('Объект с ID=${item.getId()} не найден');
    }
    _items[item.getId()] = item;
  }

  T? getById(int id) => _items[id];

  List<T> getAll() => _items.values.toList();

  void addAll(Iterable<T> items) {
    for (final item in items) {
      _items[item.getId()] = item;
    }
  }
}
