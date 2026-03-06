void main() {
  List<String> students = [
    'Сидоров Коля',
    'Синицын Вова',
    'Петров Вася',
    'Смирнов Алексей',
    'Козлова Мария',
    'Васильева Елена'
  ];

  List<String> subjects = [
    'Математика',
    'Физика',
    'Информатика',
    'Литература'
  ];

  List<List<dynamic>> grades = [
    ['Сидоров Коля', 'Математика', 5],
    ['Сидоров Коля', 'Физика', 4],
    ['Сидоров Коля', 'Информатика', 5],
    ['Сидоров Коля', 'Литература', 4],

    ['Синицын Вова', 'Математика', 5],
    ['Синицын Вова', 'Физика', 5],
    ['Синицын Вова', 'Информатика', 5],
    ['Синицын Вова', 'Литература', 5],
    
    ['Петров Вася', 'Математика', 3],
    ['Петров Вася', 'Физика', 3],
    ['Петров Вася', 'Информатика', 4],
    ['Петров Вася', 'Литература', 3],

    ['Смирнов Алексей', 'Математика', 2],
    ['Смирнов Алексей', 'Физика', 3],
    ['Смирнов Алексей', 'Информатика', 3],
    ['Смирнов Алексей', 'Литература', 4],
    
    ['Козлова Мария', 'Математика', 4],
    ['Козлова Мария', 'Физика', 4],
    ['Козлова Мария', 'Информатика', 4],
    ['Козлова Мария', 'Литература', 5],

    ['Васильева Елена', 'Математика', 5],
    ['Васильева Елена', 'Физика', 5],
    ['Васильева Елена', 'Информатика', 4],
    ['Васильева Елена', 'Литература', 5],
  ];

  List<String> otlichniki = [];
  List<String> horoshisty = [];
  List<String> ostalnye = [];

  for (var student in students) {
    double sum = 0;
    int count = 0;
    for (var grade in grades) {
      if (grade[0] == student) {
        sum += grade[2];
        count++;
      }
    }
    double avg = sum / count;

    if (avg >= 4.5) {
      otlichniki.add(student);
    } else if (avg >= 3.5) {
      horoshisty.add(student);
    } else {
      ostalnye.add(student);
    }
  }

  print('\nКатегории студентов:');
  print('Отличники: ${otlichniki.isEmpty ? "нет" : otlichniki.join(", ")}');
  print('Хорошисты: ${horoshisty.isEmpty ? "нет" : horoshisty.join(", ")}');
  print('Остальные: ${ostalnye.isEmpty ? "нет" : ostalnye.join(", ")}');


  // Сколько раз встречается каждая оценка
  int count2 = 0, count3 = 0, count4 = 0, count5 = 0;
  for (var grade in grades) {
    if (grade[2] == 2) count2++;
    if (grade[2] == 3) count3++;
    if (grade[2] == 4) count4++;
    if (grade[2] == 5) count5++;
  }

  print('\nСтатистика оценок:');
  print('Двоек: $count2');
  print('Троек: $count3');
  print('Четвёрок: $count4');
  print('Пятёрок: $count5');


  print('\nСтуденты с пятёрками по предметам:');
  for (var subject in subjects) {
    List<String> fives = [];
    for (var grade in grades) {
      if (grade[1] == subject && grade[2] == 5) {
        fives.add(grade[0]);
      }
    }
    print('$subject: ${fives.isEmpty ? "нет" : fives.join(", ")}');
  }

  print('\nПредметы без двоек:');
  List<String> noTwos = [];
  for (var subject in subjects) {
    bool hasTwo = false;
    for (var grade in grades) {
      if (grade[1] == subject && grade[2] == 2) {
        hasTwo = true;
        break;
      }
    }
    if (!hasTwo) {
      noTwos.add(subject);
    }
  }
  print(noTwos.isEmpty ? "нет" : noTwos.join(", "));

  print('\nПредмет с наибольшим количеством двоек:');
  String maxTwoSubject = '';
  int maxTwoCount = 0;
  
  for (var subject in subjects) {
    int twoCount = 0;
    for (var grade in grades) {
      if (grade[1] == subject && grade[2] == 2) {
        twoCount++;
      }
    }
    if (twoCount > maxTwoCount) {
      maxTwoCount = twoCount;
      maxTwoSubject = subject;
    }
  }
  print('$maxTwoSubject ($maxTwoCount)');

  print('\nСтудент(ы) с наибольшим количеством пятёрок:');
  int maxFives = 0;
  List<String> bestStudents = [];
  
  for (var student in students) {
    int fivesCount = 0;
    for (var grade in grades) {
      if (grade[0] == student && grade[2] == 5) {
        fivesCount++;
      }
    }
    if (fivesCount > maxFives) {
      maxFives = fivesCount;
      bestStudents = [student];
    } else if (fivesCount == maxFives && fivesCount > 0) {
      bestStudents.add(student);
    }
  }
  print('${bestStudents.join(", ")} ($maxFives)');

  print('\nПредметы с оценкой ниже 4:');
  for (var student in students) {
    List<String> lowGrades = [];
    for (var grade in grades) {
      if (grade[0] == student && grade[2] < 4) {
        lowGrades.add('${grade[1]} (${grade[2]})');
      }
    }
    if (lowGrades.isNotEmpty) {
      print('$student: ${lowGrades.join(", ")} (Всего: ${lowGrades.length})');
    }
  }

  print('\nПары студент-предмет с оценкой 5:');
  for (var grade in grades) {
    if (grade[2] == 5) {
      print('${grade[0]} - ${grade[1]}');
    }
  }
}