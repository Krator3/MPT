import '../../domain/models/topic.dart';
import '../database.dart';

class TopicRepository {
  final ForumDatabase db;

  TopicRepository(this.db);

  void insertTopic(Topic topic) {
    db.db.execute(
      'INSERT OR REPLACE INTO topics VALUES(?,?,?,?)',
      [topic.id, topic.title, topic.authorId, topic.createdAt.toIso8601String()],
    );
  }

  List<Topic> getAllTopics() {
    final rows = db.db.select('SELECT id, title, authorId, createdAt FROM topics');
    return rows.map((row) => Topic.fromMap(row)).toList();
  }

  Topic? getTopicById(String id) {
    final rows = db.db.select('SELECT id, title, authorId, createdAt FROM topics WHERE id=?', [id]);
    return rows.isNotEmpty ? Topic.fromMap(rows.first) : null;
  }

  void updateTopic(Topic topic) {
    db.db.execute(
      'UPDATE topics SET title=?, authorId=?, createdAt=? WHERE id=?',
      [topic.title, topic.authorId, topic.createdAt.toIso8601String(), topic.id],
    );
  }

  void deleteTopic(String id) {
    db.db.execute('DELETE FROM topics WHERE id=?', [id]);
  }
}