import 'dart:io';
import 'package:forum/forum.dart';
import 'package:path/path.dart' as p;

void main() async {
  final dbPath = p.join(Directory.current.path, 'test_load.db');
  final dbFile = File(dbPath);
  if (dbFile.existsSync()) dbFile.deleteSync();

  final db = ForumDatabase(dbPath);
  final userRepo = UserRepository(db);
  final topicRepo = TopicRepository(db);
  final messageRepo = MessageRepository(db);
  
  try {
    print('Нагрузочное тестирование БД');

    print('\n--- ТЕСТ 1: ПОЛЬЗОВАТЕЛИ ---');
    
    final addUserStart = DateTime.now();
    for (int i = 0; i < 100; i++) {
      userRepo.insertUser(
        User(
          id: 'user_$i',
          login: 'User $i',
          email: 'user$i@test.com',
          roleId: '2',
        ),
      );
    }
    print('Добавление 100 пользователей: ${DateTime.now().difference(addUserStart).inMilliseconds} мс');

    final readUserStart = DateTime.now();
    final users = userRepo.getAllUsers();
    print('Чтение ${users.length} пользователей: ${DateTime.now().difference(readUserStart).inMilliseconds} мс');

    print('\n--- ТЕСТ 2: ТЕМЫ ---');
    
    userRepo.insertUser(User(id: 'author', login: 'author', email: 'author@test.com', roleId: '2'));
    
    final addTopicStart = DateTime.now();
    for (int i = 0; i < 100; i++) {
      topicRepo.insertTopic(
        Topic(
          id: 'topic_$i',
          title: 'Topic $i',
          authorId: 'author',
          createdAt: DateTime.now(),
        ),
      );
    }
    print('Добавление 100 тем: ${DateTime.now().difference(addTopicStart).inMilliseconds} мс');

    final readTopicStart = DateTime.now();
    final topics = topicRepo.getAllTopics();
    print('Чтение ${topics.length} тем: ${DateTime.now().difference(readTopicStart).inMilliseconds} мс');

    print('\n--- ТЕСТ 3: СООБЩЕНИЯ ---');
    
    final addMessageStart = DateTime.now();
    for (int i = 0; i < 100; i++) {
      messageRepo.insertMessage(
        Message(
          id: 'msg_$i',
          content: 'Message $i',
          topicId: 'topic_0',
          authorId: 'author',
          postedAt: DateTime.now(),
        ),
      );
    }
    print('Добавление 100 сообщений: ${DateTime.now().difference(addMessageStart).inMilliseconds} мс');

    final readMessageStart = DateTime.now();
    final messages = messageRepo.getAllMessages();
    print('Чтение ${messages.length} сообщений: ${DateTime.now().difference(readMessageStart).inMilliseconds} мс');

    print('\n--- ТЕСТ 4: МНОГОКРАТНОЕ ЧТЕНИЕ (10 итераций) ---');
    
    final readDurations = <int>[];
    for (int i = 0; i < 10; i++) {
      final start = DateTime.now();
      userRepo.getAllUsers();
      readDurations.add(DateTime.now().difference(start).inMicroseconds);
    }
    readDurations.sort();
    print('Чтение пользователей (10 раз):');
    print('  Среднее: ${readDurations.reduce((a, b) => a + b) / readDurations.length} мкс');
    print('  Мин: ${readDurations.first} мкс');
    print('  Макс: ${readDurations.last} мкс');

    print('\n--- ТЕСТ 5: УДАЛЕНИЕ ---');
    
    final deleteStart = DateTime.now();
    for (int i = 0; i < 100; i++) {
      messageRepo.deleteMessage('msg_$i');
    }
    print('Удаление 100 сообщений: ${DateTime.now().difference(deleteStart).inMilliseconds} мс');
    
    final deleteTopicStart = DateTime.now();
    for (int i = 0; i < 100; i++) {
      topicRepo.deleteTopic('topic_$i');
    }
    print('Удаление 100 тем: ${DateTime.now().difference(deleteTopicStart).inMilliseconds} мс');
    
    final deleteUserStart = DateTime.now();
    for (int i = 0; i < 100; i++) {
      userRepo.deleteUser('user_$i');
    }
    print('Удаление 100 пользователей: ${DateTime.now().difference(deleteUserStart).inMilliseconds} мс');

    print('\n--- ТЕСТ ЗАВЕРШЕН ---');
    
  } finally {
    db.close();
    if (dbFile.existsSync()) {
      dbFile.deleteSync();
      print('Временный файл БД удален');
    }
  }
}