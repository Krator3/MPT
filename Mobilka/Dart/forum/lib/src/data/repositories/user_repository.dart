import '../../domain/models/user.dart';
import '../database.dart';

class UserRepository {
  final ForumDatabase db;

  UserRepository(this.db);

  void insertUser(User user) {
    db.db.execute(
      'INSERT OR REPLACE INTO users VALUES(?,?,?,?)',
      [user.id, user.login, user.email, user.roleId],
    );
  }

  List<User> getAllUsers() {
    final rows = db.db.select('SELECT id, login, email, roleId FROM users');
    return rows.map((row) => User.fromMap(row)).toList();
  }

  User? getUserById(String id) {
    final rows = db.db.select('SELECT id, login, email, roleId FROM users WHERE id=?', [id]);
    return rows.isNotEmpty ? User.fromMap(rows.first) : null;
  }

  void updateUser(User user) {
    db.db.execute(
      'UPDATE users SET login=?, email=?, roleId=? WHERE id=?',
      [user.login, user.email, user.roleId, user.id],
    );
  }

  void deleteUser(String id) {
    db.db.execute('DELETE FROM users WHERE id=?', [id]);
  }
}