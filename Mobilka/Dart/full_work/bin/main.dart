import 'package:full_work/entities/enums.dart';
import 'package:full_work/entities/user.dart';
import 'package:full_work/services/logger_service.dart';
import 'package:full_work/services/user_service.dart';
import 'package:full_work/storage/binary_storage.dart';
import 'package:full_work/storage/repository.dart';
import 'package:full_work/ui/menu.dart';

void main() async {
  final repository = Repository<ForumUser>();
  final storage = BinaryStorage<ForumUser>(
    filePath: 'data.bin',
    serializer: (user) => user.toBytes(),
    deserializer: ForumUser.fromBytes,
  );
  final logger = LoggerService(logFilePath: 'logs.txt');
  await logger.init();
  final userService = UserService(repository, storage, logger);
  await userService.init();
  if (userService.getAll().isEmpty) {
    await _seedTestData(userService);
  }
  final menu = Menu(userService, logger);
  await menu.start();
}

Future<void> _seedTestData(UserService service) async {
  await service.add('ivanov', true, Role.user, 'Любит форумы');
  await service.add('petrova', true, Role.moderator, null);
  await service.add('sidorov', false, Role.user, null);
  await service.add('admin01', true, Role.admin, 'Главный администратор');
  await service.add('kuznetsov', true, Role.moderator, null);
  await service.add('smirnova', false, Role.user, null);
  print('Добавлены тестовые данные (6 пользователей)');
}
