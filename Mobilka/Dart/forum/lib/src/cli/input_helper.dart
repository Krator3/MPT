import 'dart:io';
import '../domain/validators/date_validator.dart';
import '../domain/validators/text_validator.dart';

class InputHelper {
  static String askString(String prompt, {bool required = true}) {
    while (true) {
      stdout.write('$prompt: ');
      final input = stdin.readLineSync()?.trim() ?? '';
      if (required && !isNotEmptyString(input)) {
        stdout.writeln('Ошибка: поле не может быть пустым.');
        continue;
      }
      return input;
    }
  }

  static DateTime askDateTime(String prompt) {
    while (true) {
      stdout.write('$prompt (ГГГГ-ММ-ДД ЧЧ:ММ): ');
      final input = stdin.readLineSync()?.trim() ?? '';
      DateTime? parsed;
      try {
        parsed = DateTime.parse(input);
      } catch (_) {
        try {
          parsed = DateTime.parse(input.replaceFirst(' ', 'T'));
        } catch (_) {}
      }
      if (parsed != null && isValidDateTime(parsed.toIso8601String())) {
        return parsed;
      }
      stdout.writeln('Ошибка: неверный формат даты/времени.');
    }
  }
}