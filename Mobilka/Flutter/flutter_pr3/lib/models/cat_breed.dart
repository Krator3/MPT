class CatBreed {
  const CatBreed({
    required this.name,
    this.origin = 'Неизвестно',
    this.length = '—',
    this.minWeight = 0,
    this.maxWeight = 0,
    this.minLife = 0,
    this.maxLife = 0,
    this.familyFriendly = 0,
    this.childrenFriendly = 0,
    this.otherPetsFriendly = 0,
    this.generalHealth = 0,
    this.playfulness = 0,
    this.intelligence = 0,
    this.grooming = 0,
    this.shedding = 0,
  });

  final String name, origin, length;
  final double minWeight, maxWeight, minLife, maxLife;
  final int familyFriendly, childrenFriendly, otherPetsFriendly;
  final int generalHealth, playfulness, intelligence, grooming, shedding;

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    double number(String key) => (json[key] as num?)?.toDouble() ?? 0;
    int score(String key) => (json[key] as num?)?.toInt() ?? 0;
    return CatBreed(
      name: json['name']?.toString() ?? 'Без названия',
      origin: json['origin']?.toString() ?? 'Неизвестно',
      length: json['length']?.toString() ?? '—',
      minWeight: number('min_weight'), maxWeight: number('max_weight'),
      minLife: number('min_life_expectancy'), maxLife: number('max_life_expectancy'),
      familyFriendly: score('family_friendly'), childrenFriendly: score('children_friendly'),
      otherPetsFriendly: score('other_pets_friendly'), generalHealth: score('general_health'),
      playfulness: score('playfulness'), intelligence: score('intelligence'),
      grooming: score('grooming'), shedding: score('shedding'),
    );
  }

  String get weightLabel {
    if (minWeight <= 0) return 'Нет данных';
    const poundsToKg = 0.45359237;
    final minKg = minWeight * poundsToKg;
    final maxKg = maxWeight * poundsToKg;
    return '${minKg.toStringAsFixed(1)}–${maxKg.toStringAsFixed(1)} кг';
  }
  String get lifeLabel => minLife > 0 ? '${minLife.toStringAsFixed(0)}–${maxLife.toStringAsFixed(0)} лет' : 'Нет данных';
}
