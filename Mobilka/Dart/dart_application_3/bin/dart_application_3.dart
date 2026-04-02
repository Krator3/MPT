import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:characters/characters.dart';

enum Mood {
  happy('\u{1F600}', 'радостный', 7),
  suspicious('\u{1F928}', 'подозрительный', 9),
  sad('\u{1F61E}', 'грустный', 3),
  angry('\u{1F620}', 'злой', 6),
  embarrassed('\u{1F605}', 'смущенный', 4);

  final String emoji;
  final String description;
  final int energy;

  const Mood(this.emoji, this.description, this.energy);
}

void main() {
  print('Введите ваше имя:');
  String name = stdin.readLineSync(encoding: utf8)!;

  print('\nГенерируем случайное настроение...');
  Mood randomMood = Mood.values[Random().nextInt(Mood.values.length)];

  print('Привет, $name! Твое настроение: ${randomMood.emoji} ${randomMood.description} (энергия: ${randomMood.energy}/10)');

  int codePoint = randomMood.emoji.runes.first;
  print('\nЮникод вашего эмодзи: U+${codePoint.toRadixString(16).toUpperCase().padLeft(5, '0')}');

  print('\nХотите просмотреть сложные эмодзи? (Y/N):');
  String answer = stdin.readLineSync(encoding: utf8)!;

  if (answer.trim().toLowerCase() == 'y') {
    print('\nВыберите сложный эмодзи:');
    print('1. 👨‍👩‍👧‍👦 (семья)');
    print('2. 👩‍🏫 (учитель)');
    print('3. 🏴‍☠️ (пиратский флаг)');
    print('\nВведите номер (1-3):');
    
    String choice = stdin.readLineSync(encoding: utf8)!;
    String emojis = '';
    
    switch (choice) {
      case '1':
        emojis = '👨‍👩‍👧‍👦';
        break;
      case '2':
        emojis = '👩‍🏫';
        break;
      case '3':
        emojis = '🏴‍☠️';
        break;
      default:
        print('Неверный выбор, используем семью');
        emojis = '👨‍👩‍👧‍👦';
    }

    print('\nАнализ строки "$emojis":');
    print('- 16-битных единиц: ${emojis.length}');
    print('- Кодовых точек: ${emojis.runes.length}');
    print('- Реальных символов: ${emojis.characters.length}');

    print('\nПодробный вывод юникода:');
    int i = 1;
    for (int rune in emojis.runes) {
      print('Символ $i: ${String.fromCharCode(rune)} → U+${rune.toRadixString(16).toUpperCase().padLeft(5, '0')}');
      i++;
    }
  }
  print('\nСпасибо, приходите снова!');
}