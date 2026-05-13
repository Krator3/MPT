import 'package:forum/forum.dart';

void main() {
  final db = ForumDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}