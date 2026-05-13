import 'identity.dart';

class Message implements Identity {
  @override
  final String id;
  final String content;
  final String topicId;
  final String authorId;
  final DateTime postedAt;

  const Message({
    required this.id,
    required this.content,
    required this.topicId,
    required this.authorId,
    required this.postedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'content': content,
    'topicId': topicId,
    'authorId': authorId,
    'postedAt': postedAt.toIso8601String(),
  };

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      content: map['content'] as String,
      topicId: map['topicId'] as String,
      authorId: map['authorId'] as String,
      postedAt: DateTime.parse(map['postedAt'] as String),
    );
  }
}