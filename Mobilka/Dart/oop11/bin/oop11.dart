// 1. Кружка и Человек
class Cup {
  int water = 100;
  void drink(int amount) => water -= amount;
}

class Human {
  void drinkFrom(Cup cup, int amount) => cup.drink(amount);
}

// 2. Шкаф с несколькими системами хранения
class StorageSystem {
  List<String> items = [];
}

class Wardrobe {
  List<StorageSystem> storageSystems = [];
  
  void addStorageSystem(StorageSystem system) {
    storageSystems.add(system);
  }
  
  void putItem(String item, int systemIndex) {
    storageSystems[systemIndex].items.add(item);
  }
  
  String takeItem(String item, int systemIndex) {
    storageSystems[systemIndex].items.remove(item);
    return item;
  }
}

// 3. Гриф и Блин
class Plate {
  int weight;
  Plate(this.weight);
}

class Barbell {
  int maxLoad;
  int leftWeight = 0;
  int rightWeight = 0;
  
  Barbell(this.maxLoad);
  
  void addLeft(Plate plate) {
    if (leftWeight + rightWeight + plate.weight <= maxLoad) {
      leftWeight += plate.weight;
    }
  }
  
  void addRight(Plate plate) {
    if (leftWeight + rightWeight + plate.weight <= maxLoad) {
      rightWeight += plate.weight;
    }
  }
}

// 4. Конвертер денег из одной валюты в другую
class CurrencyConverter {
  Map<String, double> rates = {
    'USD': 1.0,
    'RUB': 90.0,
    'EUR': 0.92,
    'GBP': 0.79,
  };
  
  void setRate(String currency, double rate) {
    rates[currency] = rate;
  }
  
  double convert(double amount, String from, String to) {
    if (!rates.containsKey(from) || !rates.containsKey(to)) {
      throw Exception('Валюта не найдена');
    }
    // Сначала конвертируем в USD (базовую валюту), затем в нужную
    double inUSD = amount / rates[from]!;
    return inUSD * rates[to]!;
  }
}

// 6. Класс с перегруженными арифметическими операциями
class MathValue {
  int value;
  MathValue(this.value);
  
  MathValue operator +(MathValue other) => MathValue(value + other.value);
  MathValue operator -(MathValue other) => MathValue(value - other.value);
  MathValue operator *(MathValue other) => MathValue(value * other.value);
  MathValue operator /(MathValue other) => MathValue(value ~/ other.value);
  
  @override
  String toString() => value.toString();
}

// 7. Автомобиль с перечислениями
enum CarState { stop, move, turn }

class Car {
  CarState state = CarState.stop;
  void go() => state = CarState.move;
  void stop() => state = CarState.stop;
  void turn() => state = CarState.turn;
}

// 8. Базовый класс и производные геометрические фигуры
abstract class GeometricFigure {
  double getArea();
}

class Rectangle extends GeometricFigure {
  double width, height;
  Rectangle(this.width, this.height);
  @override
  double getArea() => width * height;
}

class Triangle extends GeometricFigure {
  double base, height;
  Triangle(this.base, this.height);
  @override
  double getArea() => (base * height) / 2;
}

class Circle extends GeometricFigure {
  double radius;
  Circle(this.radius);
  @override
  double getArea() => 3.14159 * radius * radius;
}

// 9. Конвертер систем счисления
class NumberSystemConverter {
  // Из десятичной
  static String decimalToBinary(int number) => number.toRadixString(2);
  static String decimalToOctal(int number) => number.toRadixString(8);
  static String decimalToHex(int number) => number.toRadixString(16);
  
  // В десятичную
  static int binaryToDecimal(String binary) => int.parse(binary, radix: 2);
  static int octalToDecimal(String octal) => int.parse(octal, radix: 8);
  static int hexToDecimal(String hex) => int.parse(hex, radix: 16);
  
  // Перевод между любыми системами (2-36)
  static String convertBase(String number, int fromRadix, int toRadix) {
    int decimalValue = int.parse(number, radix: fromRadix);
    return decimalValue.toRadixString(toRadix);
  }
}

// 10. Класс со списком фигур для поиска максимальной площади
class FigureContainer {
  List<GeometricFigure> figures = [];
  
  void addFigure(GeometricFigure figure) {
    figures.add(figure);
  }
  
  GeometricFigure findMaxArea() {
    GeometricFigure max = figures[0];
    for (var figure in figures) {
      if (figure.getArea() > max.getArea()) {
        max = figure;
      }
    }
    return max;
  }
}

// 11. Стол и столовые приборы
class Cutlery {
  String name;
  Cutlery(this.name);
}

class Fork extends Cutlery {
  Fork() : super('Вилка');
}

class Spoon extends Cutlery {
  Spoon() : super('Ложка');
}

class Knife extends Cutlery {
  Knife() : super('Нож');
}

class Table {
  List<Cutlery> items = [];
  
  void placeItem(Cutlery item) {
    items.add(item);
  }
  
  void removeItem(Cutlery item) {
    items.remove(item);
  }
}

void main() {
  // 1
  Cup cup = Cup();
  Human human = Human();
  human.drinkFrom(cup, 30);
  print('1. В кружке осталось: ${cup.water}');

  // 2
  Wardrobe wardrobe = Wardrobe();
  wardrobe.addStorageSystem(StorageSystem());
  wardrobe.addStorageSystem(StorageSystem());
  wardrobe.putItem('Книга', 0);
  wardrobe.putItem('Обувь', 1);
  print('2. Вещи разложены по разным системам хранения');

  // 3
  Barbell barbell = Barbell(100);
  barbell.addLeft(Plate(20));
  barbell.addRight(Plate(20));
  print('3. Вес на грифе: ${barbell.leftWeight + barbell.rightWeight} кг');

  // 4
  print('4.');
  CurrencyConverter converter = CurrencyConverter();
  print(' 100 USD в RUB: ${converter.convert(100, "USD", "RUB")}');
  print(' 100 EUR в USD: ${converter.convert(100, "EUR", "USD")}');

  // 6
  MathValue a = MathValue(10);
  MathValue b = MathValue(3);
  print('6. 10+3=${a + b}, 10-3=${a - b}, 10*3=${a * b}, 10/3=${a / b}');

  // 7
  Car car = Car();
  car.go();
  print('7. Состояние автомобиля: ${car.state}');
  car.turn();
  print('   После поворота: ${car.state}');

  // 8
  Rectangle rect = Rectangle(5, 4);
  Triangle tri = Triangle(6, 3);
  Circle circ = Circle(2);
  print('8. Площади: ${rect.getArea()}, ${tri.getArea()}, ${circ.getArea()}');

  // 9
  print('9.');
  print(' 255 в hex: ${NumberSystemConverter.decimalToHex(255)}');
  print(' 255 в octal: ${NumberSystemConverter.decimalToOctal(255)}');
  print(' FF в decimal: ${NumberSystemConverter.hexToDecimal("FF")}');
  print(' FF в octal: ${NumberSystemConverter.convertBase("FF", 16, 8)}');

  // 10
  FigureContainer container = FigureContainer();
  container.addFigure(rect);
  container.addFigure(tri);
  container.addFigure(circ);
  print('10. Максимальная площадь: ${container.findMaxArea().getArea()}');

  // 11
  Table table = Table();
  Fork fork = Fork();
  Spoon spoon = Spoon();
  table.placeItem(fork);
  table.placeItem(spoon);
  print('11. Приборов на столе: ${table.items.length}');
  table.removeItem(fork);
  print('    После удаления: ${table.items.length}');
}