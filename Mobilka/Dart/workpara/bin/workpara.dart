void main() {
  print('ЗАДАЧА №1');
  print(formatName('Петр', 'Новиков')); // Новиков Петр
  print(formatName('Петр', 'Новиков', 'Сергеевич')); // Новиков Петр Сергеевич
  
  print('\nЗАДАЧА №2');
  print('7 + 2 = ${calculate(7, 2, '+')}'); // 9
  print('9 - 6 = ${calculate(9, 6, '-')}'); // 3
  print('6 * 7 = ${calculate(6, 7, '*')}'); // 42
  print('20 / 2 = ${calculate(20, 2, '/')}'); // 10
  print('10 / 0 = ${calculate(10, 0, '/')}'); // null
  print('Неверная операция: ${calculate(5, 5, '%')}'); // null
  
  print('\nЗАДАЧА №3');
  countSigns([-10, -5, 0, 3, 8, -1, 0, 15, -7, 4, 0, 11]);
  
  print('\nЗАДАЧА №4');
  List<int> numbers = [2, 3, 4, 5, 3, 2, 4];
  print('Исходный список: $numbers');

  List<int> doubled = transformList(numbers, (x) => x * 2);
  print('Удвоенный: $doubled');

  List<int> squared = transformList(numbers, (x) => x * x);
  print('Квадраты: $squared');
  
  print('\nЗАДАЧА №5');
  print('Сумма цифр числа 571 = ${sumDigits(571)}');
  print('Сумма цифр числа 7 = ${sumDigits(7)}');
  print('Сумма цифр числа 0 = ${sumDigits(0)}');
  print('Сумма цифр числа 9815 = ${sumDigits(9815)}');
}

// Задача 1
String formatName(String firstName, String lastName, [String? middleName]) {
  if (middleName != null && middleName.isNotEmpty) {
    return '$lastName $firstName $middleName';
  } else {
    return '$lastName $firstName';
  }
}

// Задача 2
double? calculate(double a, double b, String operation) {
  switch (operation) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      if (b == 0) {
        return null;
      }
      return a / b;
    default:
      return null;
  }
}

// Задача 3
void countSigns(List<int> numbers) {
  int positive = 0;
  int negative = 0;
  int zero = 0;
  
  for (int num in numbers) {
    if (num > 0) {
      positive++;
    } else if (num < 0) {
      negative++;
    } else {
      zero++;
    }
  }
  print('Положительных: $positive');
  print('Отрицательных: $negative');
  print('Нулевых: $zero');
}

// Задача 4
List<int> transformList(List<int> numbers, int Function(int) transformer) {
  List<int> result = [];
  for (int num in numbers) {
    result.add(transformer(num));
  }
  return result;
}

// Задача 5
int sumDigits(int n) {
  if (n < 10) {
    return n;
  }
  
  // последняя цифра + сумма остальных цифр
  return (n % 10) + sumDigits(n ~/ 10);
}