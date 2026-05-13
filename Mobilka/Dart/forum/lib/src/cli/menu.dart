import 'dart:io';
import 'package:forum/forum.dart';

void runMenu(ForumDatabase database) {
  final roleRepo = RoleRepository(database);
  final userRepo = UserRepository(database);
  final topicRepo = TopicRepository(database);
  final messageRepo = MessageRepository(database);

  while (true) {
    stdout.writeln('\n========== ФОРУМ ==========');
    stdout.writeln('1 — список пользователей');
    stdout.writeln('2 — добавить пользователя');
    stdout.writeln('3 — редактировать пользователя');
    stdout.writeln('4 — удалить пользователя');
    stdout.writeln('5 — список тем');
    stdout.writeln('6 — добавить тему');
    stdout.writeln('7 — редактировать тему');
    stdout.writeln('8 — удалить тему');
    stdout.writeln('9 — сообщения в теме');
    stdout.writeln('10 — добавить сообщение');
    stdout.writeln('11 — редактировать сообщение');
    stdout.writeln('12 — удалить сообщение');
    stdout.writeln('13 — список ролей');
    stdout.writeln('14 — добавить роль');
    stdout.writeln('15 — редактировать роль');
    stdout.writeln('16 — удалить роль');
    stdout.writeln('17 — ПОКАЗАТЬ ВСЁ ИЗ БД');
    stdout.writeln('0 — выход');
    stdout.write('Выберите пункт: ');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        _listUsers(userRepo);
        break;
      case '2':
        _addUser(userRepo, roleRepo);
        break;
      case '3':
        _editUser(userRepo, roleRepo);
        break;
      case '4':
        _deleteUser(userRepo);
        break;
      case '5':
        _listTopics(topicRepo);
        break;
      case '6':
        _addTopic(topicRepo, userRepo);
        break;
      case '7':
        _editTopic(topicRepo, userRepo);
        break;
      case '8':
        _deleteTopic(topicRepo);
        break;
      case '9':
        _listMessagesInTopic(topicRepo, messageRepo);
        break;
      case '10':
        _addMessage(messageRepo, topicRepo, userRepo);
        break;
      case '11':
        _editMessage(messageRepo, topicRepo, userRepo);
        break;
      case '12':
        _deleteMessage(messageRepo);
        break;
      case '13':
        _listRoles(roleRepo);
        break;
      case '14':
        _addRole(roleRepo);
        break;
      case '15':
        _editRole(roleRepo);
        break;
      case '16':
        _deleteRole(roleRepo, userRepo);
        break;
      case '17':
        _showAll(roleRepo, userRepo, topicRepo, messageRepo);
        break;
      case '0':
        stdout.writeln('До свидания!');
        return;
      default:
        stdout.writeln('Неизвестная команда.');
    }
  }
}

void _listUsers(UserRepository repo) {
  final users = repo.getAllUsers();
  if (users.isEmpty) {
    stdout.writeln('Нет пользователей.');
    return;
  }
  for (final u in users) {
    stdout.writeln('id: ${u.id} | ${u.login} | ${u.email} | roleId: ${u.roleId}');
  }
}

void _addUser(UserRepository userRepo, RoleRepository roleRepo) {
  stdout.writeln('\n--- Добавление пользователя ---');
  final id = InputHelper.askString('ID');
  final login = InputHelper.askString('Логин');
  final email = InputHelper.askString('Email');

  stdout.writeln('\nДоступные роли:');
  for (final r in roleRepo.getAllRoles()) {
    stdout.writeln('  ${r.id} — ${r.name}');
  }
  
  String roleId;
  while (true) {
    roleId = InputHelper.askString('ID роли');
    final roleExists = roleRepo.getRoleById(roleId) != null;
    if (roleExists) {
      break;
    } else {
      stdout.writeln('Ошибка: Роль с ID "$roleId" не существует!');
      stdout.writeln('Введите ID из списка выше.');
    }
  }

  userRepo.insertUser(User(
    id: id,
    login: login,
    email: email,
    roleId: roleId,
  ));
  stdout.writeln('Пользователь добавлен.');
}

void _editUser(UserRepository userRepo, RoleRepository roleRepo) {
  stdout.writeln('\n--- Редактирование пользователя ---');
  _listUsers(userRepo);
  final id = InputHelper.askString('ID пользователя для редактирования');
  
  final existingUser = userRepo.getUserById(id);
  if (existingUser == null) {
    stdout.writeln('Пользователь не найден.');
    return;
  }

  stdout.writeln('Оставьте поле пустым, чтобы не менять.');
  final login = InputHelper.askString('Логин (было: ${existingUser.login})', required: false);
  final email = InputHelper.askString('Email (было: ${existingUser.email})', required: false);
  
  stdout.writeln('\nДоступные роли:');
  for (final r in roleRepo.getAllRoles()) {
    stdout.writeln('  ${r.id} — ${r.name}');
  }
  
  String roleId = existingUser.roleId;
  while (true) {
    final input = InputHelper.askString('ID роли (было: ${existingUser.roleId})', required: false);
    if (input.isEmpty) {
      break;
    }
    final roleExists = roleRepo.getRoleById(input) != null;
    if (roleExists) {
      roleId = input;
      break;
    } else {
      stdout.writeln('Ошибка: Роль с ID "$input" не существует!');
      stdout.writeln('Введите ID из списка выше или оставьте пустым.');
    }
  }

  final updatedUser = User(
    id: existingUser.id,
    login: login.isEmpty ? existingUser.login : login,
    email: email.isEmpty ? existingUser.email : email,
    roleId: roleId,
  );
  
  userRepo.updateUser(updatedUser);
  stdout.writeln('Пользователь обновлён.');
}

void _deleteUser(UserRepository repo) {
  final id = InputHelper.askString('ID пользователя для удаления');
  repo.deleteUser(id);
  stdout.writeln('Удалено.');
}

void _listTopics(TopicRepository repo) {
  final topics = repo.getAllTopics();
  if (topics.isEmpty) {
    stdout.writeln('Нет тем.');
    return;
  }
  for (final t in topics) {
    stdout.writeln('id: ${t.id} | ${t.title} | автор: ${t.authorId} | ${t.createdAt.toLocal()}');
  }
}

void _addTopic(TopicRepository topicRepo, UserRepository userRepo) {
  stdout.writeln('\n--- Добавление темы ---');
  final id = InputHelper.askString('ID темы');
  final title = InputHelper.askString('Заголовок');

  stdout.writeln('\nДоступные пользователи:');
  _listUsers(userRepo);
  
  String authorId;
  while (true) {
    authorId = InputHelper.askString('ID автора');
    final userExists = userRepo.getUserById(authorId) != null;
    if (userExists) {
      break;
    } else {
      stdout.writeln('Ошибка: Пользователь с ID "$authorId" не существует!');
      stdout.writeln('Введите ID из списка выше.');
    }
  }
  
  final createdAt = DateTime.now();

  topicRepo.insertTopic(Topic(
    id: id,
    title: title,
    authorId: authorId,
    createdAt: createdAt,
  ));
  stdout.writeln('Тема добавлена.');
}

void _editTopic(TopicRepository topicRepo, UserRepository userRepo) {
  stdout.writeln('\n--- Редактирование темы ---');
  _listTopics(topicRepo);
  final id = InputHelper.askString('ID темы для редактирования');
  
  final existingTopic = topicRepo.getTopicById(id);
  if (existingTopic == null) {
    stdout.writeln('Тема не найдена.');
    return;
  }

  stdout.writeln('Оставьте поле пустым, чтобы не менять.');
  final title = InputHelper.askString('Заголовок (было: ${existingTopic.title})', required: false);

  final updatedTopic = Topic(
    id: existingTopic.id,
    title: title.isEmpty ? existingTopic.title : title,
    authorId: existingTopic.authorId,
    createdAt: existingTopic.createdAt,
  );
  
  topicRepo.updateTopic(updatedTopic);
  stdout.writeln('Тема обновлена.');
}

void _deleteTopic(TopicRepository repo) {
  final id = InputHelper.askString('ID темы для удаления');
  repo.deleteTopic(id);
  stdout.writeln('Удалено.');
}

void _listMessagesInTopic(TopicRepository topicRepo, MessageRepository messageRepo) {
  stdout.writeln('\n--- Список тем ---');
  _listTopics(topicRepo);
  final topicId = InputHelper.askString('ID темы');

  final messages = messageRepo.getMessagesForTopic(topicId);
  if (messages.isEmpty) {
    stdout.writeln('В этой теме нет сообщений.');
    return;
  }

  stdout.writeln('\n--- Сообщения ---');
  for (final m in messages) {
    final preview = m.content.length > 50 ? '${m.content.substring(0, 50)}...' : m.content;
    stdout.writeln('id: ${m.id} | автор: ${m.authorId} | ${m.postedAt.toLocal()}');
    stdout.writeln('    $preview');
  }
}

void _addMessage(MessageRepository messageRepo, TopicRepository topicRepo, UserRepository userRepo) {
  stdout.writeln('\n--- Добавление сообщения ---');
  final id = InputHelper.askString('ID сообщения');
  final content = InputHelper.askString('Текст сообщения');

  stdout.writeln('\nДоступные темы:');
  _listTopics(topicRepo);
  
  String topicId;
  while (true) {
    topicId = InputHelper.askString('ID темы');
    final topicExists = topicRepo.getTopicById(topicId) != null;
    if (topicExists) {
      break;
    } else {
      stdout.writeln('Ошибка: Тема с ID "$topicId" не существует!');
      stdout.writeln('Введите ID из списка выше.');
    }
  }

  stdout.writeln('\nДоступные пользователи:');
  _listUsers(userRepo);
  
  String authorId;
  while (true) {
    authorId = InputHelper.askString('ID автора');
    final userExists = userRepo.getUserById(authorId) != null;
    if (userExists) {
      break;
    } else {
      stdout.writeln('Ошибка: Пользователь с ID "$authorId" не существует!');
      stdout.writeln('Введите ID из списка выше.');
    }
  }
  
  final postedAt = InputHelper.askDateTime('Дата и время создания сообщения');

  messageRepo.insertMessage(Message(
    id: id,
    content: content,
    topicId: topicId,
    authorId: authorId,
    postedAt: postedAt,
  ));
  stdout.writeln('Сообщение добавлено.');
}

void _editMessage(MessageRepository messageRepo, TopicRepository topicRepo, UserRepository userRepo) {
  stdout.writeln('\n--- Редактирование сообщения ---');
  final id = InputHelper.askString('ID сообщения для редактирования');
  
  final existingMessage = messageRepo.getMessageById(id);
  if (existingMessage == null) {
    stdout.writeln('Сообщение не найдено.');
    return;
  }

  stdout.writeln('Оставьте поле пустым, чтобы не менять.');
  final content = InputHelper.askString('Текст (было: ${existingMessage.content.substring(0, existingMessage.content.length > 50 ? 50 : existingMessage.content.length)}...)', required: false);

  final updatedMessage = Message(
    id: existingMessage.id,
    content: content.isEmpty ? existingMessage.content : content,
    topicId: existingMessage.topicId,
    authorId: existingMessage.authorId,
    postedAt: existingMessage.postedAt,
  );
  
  messageRepo.updateMessage(updatedMessage);
  stdout.writeln('Сообщение обновлено.');
}

void _deleteMessage(MessageRepository repo) {
  final id = InputHelper.askString('ID сообщения для удаления');
  repo.deleteMessage(id);
  stdout.writeln('Удалено.');
}

void _listRoles(RoleRepository roleRepo) {
  final roles = roleRepo.getAllRoles();
  if (roles.isEmpty) {
    stdout.writeln('Нет ролей.');
    return;
  }
  stdout.writeln('\n--- Список ролей ---');
  for (final r in roles) {
    stdout.writeln('${r.id} | ${r.name}');
  }
}

void _addRole(RoleRepository roleRepo) {
  stdout.writeln('\n--- Добавление роли ---');
  final id = InputHelper.askString('ID роли');
  final name = InputHelper.askString('Название роли');
  
  roleRepo.insertRole(Role(id: id, name: name));
  stdout.writeln('Роль добавлена.');
}

void _editRole(RoleRepository roleRepo) {
  stdout.writeln('\n--- Редактирование роли ---');
  _listRoles(roleRepo);
  final id = InputHelper.askString('ID роли для редактирования');
  
  final existingRole = roleRepo.getRoleById(id);
  if (existingRole == null) {
    stdout.writeln('Роль не найдена.');
    return;
  }

  final name = InputHelper.askString('Новое название роли (было: ${existingRole.name})');
  roleRepo.updateRole(Role(id: existingRole.id, name: name));
  stdout.writeln('Роль обновлена.');
}

void _deleteRole(RoleRepository roleRepo, UserRepository userRepo) {
  stdout.writeln('\n--- Удаление роли ---');
  _listRoles(roleRepo);
  final id = InputHelper.askString('ID роли для удаления');
  
  final usersWithRole = userRepo.getAllUsers().where((u) => u.roleId == id);
  if (usersWithRole.isNotEmpty) {
    stdout.writeln('Нельзя удалить роль: есть пользователи с этой ролью!');
    stdout.writeln('Сначала удалите или измените роль у пользователей:');
    for (final u in usersWithRole) {
      stdout.writeln('  - ${u.id} | ${u.login}');
    }
    return;
  }
  
  roleRepo.deleteRole(id);
  stdout.writeln('Роль удалена.');
}

void _showAll(RoleRepository roleRepo, UserRepository userRepo, TopicRepository topicRepo, MessageRepository messageRepo) {
  stdout.writeln('\n========== РОЛИ ==========');
  for (final r in roleRepo.getAllRoles()) {
    stdout.writeln('${r.id} | ${r.name}');
  }

  stdout.writeln('\n========== ПОЛЬЗОВАТЕЛИ ==========');
  _listUsers(userRepo);

  stdout.writeln('\n========== ТЕМЫ ==========');
  _listTopics(topicRepo);

  stdout.writeln('\n========== СООБЩЕНИЯ ==========');
  for (final t in topicRepo.getAllTopics()) {
    stdout.writeln('\n--- Тема: ${t.title} (${t.id}) ---');
    final messages = messageRepo.getMessagesForTopic(t.id);
    if (messages.isEmpty) {
      stdout.writeln('  (нет сообщений)');
    } else {
      for (final m in messages) {
        stdout.writeln('  [${m.postedAt.toLocal()}] ${m.authorId}: ${m.content}');
      }
    }
  }
}