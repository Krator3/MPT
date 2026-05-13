import '../../domain/models/message.dart';
import '../database.dart';

class MessageRepository {
  final ForumDatabase db;

  MessageRepository(this.db);

  void insertMessage(Message message) {
    db.db.execute(
      'INSERT OR REPLACE INTO messages VALUES(?,?,?,?,?)',
      [
        message.id,
        message.content,
        message.topicId,
        message.authorId,
        message.postedAt.toIso8601String(),
      ],
    );
  }

  List<Message> getMessagesForTopic(String topicId) {
    final rows = db.db.select(
      'SELECT id, content, topicId, authorId, postedAt FROM messages WHERE topicId=?',
      [topicId],
    );
    return rows.map((row) => Message.fromMap(row)).toList();
  }

  List<Message> getAllMessages() {
    final rows = db.db.select('SELECT id, content, topicId, authorId, postedAt FROM messages');
    return rows.map((row) => Message.fromMap(row)).toList();
  }

  Message? getMessageById(String id) {
    final rows = db.db.select(
      'SELECT id, content, topicId, authorId, postedAt FROM messages WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Message.fromMap(rows.first) : null;
  }

  void updateMessage(Message message) {
    db.db.execute(
      'UPDATE messages SET content=?, topicId=?, authorId=?, postedAt=? WHERE id=?',
      [message.content, message.topicId, message.authorId, message.postedAt.toIso8601String(), message.id],
    );
  }

  void deleteMessage(String id) {
    db.db.execute('DELETE FROM messages WHERE id=?', [id]);
  }
}