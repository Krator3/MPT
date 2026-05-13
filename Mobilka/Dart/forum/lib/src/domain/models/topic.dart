import 'identity.dart';

class Topic implements Identity {
  @override
  final String id;
  final String title;
  final String authorId;
  final DateTime createdAt;

  const Topic({
    required this.id,
    required this.title,
    required this.authorId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'authorId': authorId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] as String,
      title: map['title'] as String,
      authorId: map['authorId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}