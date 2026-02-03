import 'dart:io';
import 'dart:math';

void main() {
  double? num1;
  while (num1 == null) {
    print('Введите первое число:');
    String input = stdin.readLineSync()!;
    try {
      num1 = double.parse(input);
    } catch (e) {
      print('Ошибка: "$input" не является числом! Попробуйте снова.');
    }
  }
  
  double? num2;
  while (num2 == null) {
    print('Введите второе число:');
    String input = stdin.readLineSync()!;
    try {
      num2 = double.parse(input);
    } catch (e) {
      print('Ошибка: "$input" не является числом! Попробуйте снова.');
    }
  }
  
  print('\n=== Арифметические операции ===');
  print('$num1 + $num2 = ${num1 + num2}');
  print('$num1 - $num2 = ${num1 - num2}');
  print('$num1 * $num2 = ${num1 * num2}');
  
  if (num2 != 0) {
    print('$num1 / $num2 = ${num1 / num2}');
    print('$num1 ~/ $num2 = ${num1 ~/ num2}');
    print('$num1 % $num2 = ${num1 % num2}');
  } else {
    print('Деление на ноль невозможно!');
  }
  
  print('pow($num1, $num2) = ${pow(num1, num2)}');
  
  print('\n=== Операции сравнения ===');
  
  if (num1 == num2) {
    print('$num1 == $num2: true');
  } else {
    print('$num1 == $num2: false');
  }
  
  if (num1 != num2) {
    print('$num1 != $num2: true');
  } else {
    print('$num1 != $num2: false');
  }
  
  if (num1 > num2) {
    print('$num1 > $num2: true');
  } else {
    print('$num1 > $num2: false');
  }
  
  if (num1 < num2) {
    print('$num1 < $num2: true');
  } else {
    print('$num1 < $num2: false');
  }
  
  if (num1 >= num2) {
    print('$num1 >= $num2: true');
  } else {
    print('$num1 >= $num2: false');
  }
  
  if (num1 <= num2) {
    print('$num1 <= $num2: true');
  } else {
    print('$num1 <= $num2: false');
  }
  
  print('\n=== Логические операции ===');
  
  bool? bool1;
  while (bool1 == null) {
    print('Введите true/false для первого логического значения:');
    String input = stdin.readLineSync()!.toLowerCase();
    if (input == 'true') {
      bool1 = true;
    } else if (input == 'false') {
      bool1 = false;
    } else {
      print('Ошибка: введите "true" или "false"');
    }
  }
  
  bool? bool2;
  while (bool2 == null) {
    print('Введите true/false для второго логического значения:');
    String input = stdin.readLineSync()!.toLowerCase();
    if (input == 'true') {
      bool2 = true;
    } else if (input == 'false') {
      bool2 = false;
    } else {
      print('Ошибка: введите "true" или "false"');
    }
  }
  
  print('$bool1 && $bool2 = ${bool1 && bool2}');
  print('$bool1 || $bool2 = ${bool1 || bool2}');
  print('!$bool1 = ${!bool1}');
  print('!$bool2 = ${!bool2}');
}