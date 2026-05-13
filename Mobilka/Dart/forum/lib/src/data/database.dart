import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class ForumDatabase {
  final Database _db;

  ForumDatabase(String path) : _db = sqlite3.open(path) {
    _db.execute('PRAGMA foreign_keys = ON');
    _createTables();
    _seedRoles();
  }

  factory ForumDatabase.inApp() {
    return ForumDatabase(p.join(Directory.current.path, 'forum.db'));
  }

  Database get db => _db;

  void _createTables() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS roles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        login TEXT NOT NULL,
        email TEXT NOT NULL,
        roleId TEXT NOT NULL,
        FOREIGN KEY(roleId) REFERENCES roles(id) ON DELETE RESTRICT
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS topics (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        authorId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY(authorId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS messages (
        id TEXT PRIMARY KEY,
        content TEXT NOT NULL,
        topicId TEXT NOT NULL,
        authorId TEXT NOT NULL,
        postedAt TEXT NOT NULL,
        FOREIGN KEY(topicId) REFERENCES topics(id) ON DELETE CASCADE,
        FOREIGN KEY(authorId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');
  }

  void _seedRoles() {
    final result = _db.select('SELECT COUNT(*) as count FROM roles');
    final count = result.first['count'] as int;
    
    if (count == 0) {
      _db.execute('INSERT INTO roles VALUES(?,?)', ['1', 'admin']);
      _db.execute('INSERT INTO roles VALUES(?,?)', ['2', 'user']);
    }
  }

  void close() => _db.dispose();
}