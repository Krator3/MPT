import '../../domain/models/role.dart';
import '../database.dart';

class RoleRepository {
  final ForumDatabase db;

  RoleRepository(this.db);

  void insertRole(Role role) {
    db.db.execute(
      'INSERT OR REPLACE INTO roles VALUES(?,?)',
      [role.id, role.name],
    );
  }

  List<Role> getAllRoles() {
    final rows = db.db.select('SELECT id, name FROM roles');
    return rows.map((row) => Role.fromMap(row)).toList();
  }

  Role? getRoleById(String id) {
    final rows = db.db.select('SELECT id, name FROM roles WHERE id=?', [id]);
    return rows.isNotEmpty ? Role.fromMap(rows.first) : null;
  }

  void updateRole(Role role) {
    db.db.execute(
      'UPDATE roles SET name=? WHERE id=?',
      [role.name, role.id],
    );
  }

  void deleteRole(String id) {
    db.db.execute('DELETE FROM roles WHERE id=?', [id]);
  }
}