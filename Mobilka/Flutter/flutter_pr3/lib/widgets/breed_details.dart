import 'package:flutter/material.dart';
import '../models/cat_breed.dart';

class BreedDetails extends StatelessWidget {
  const BreedDetails({super.key, required this.breed, required this.isFavorite, required this.onFavorite});
  final CatBreed breed;
  final bool isFavorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final scores = <(String, int, IconData)>[
      ('Дружелюбие к семье', breed.familyFriendly, Icons.family_restroom),
      ('Отношение к детям', breed.childrenFriendly, Icons.child_friendly),
      ('Другие питомцы', breed.otherPetsFriendly, Icons.pets),
      ('Игривость', breed.playfulness, Icons.sports_basketball),
      ('Интеллект', breed.intelligence, Icons.psychology),
      ('Здоровье', breed.generalHealth, Icons.health_and_safety),
      ('Уход за шерстью', breed.grooming, Icons.brush),
      ('Линька', breed.shedding, Icons.air),
    ];
    return DraggableScrollableSheet(
      initialChildSize: .82, minChildSize: .55, maxChildSize: .95,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(color: Color(0xFFF8F8F3), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: ListView(controller: controller, padding: const EdgeInsets.fromLTRB(22, 12, 22, 32), children: [
          Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)))),
          const SizedBox(height: 20),
          Row(children: [
            Container(width: 72, height: 72, decoration: BoxDecoration(color: const Color(0xFFE8EDE2), borderRadius: BorderRadius.circular(22)), child: const Center(child: Text('🐈', style: TextStyle(fontSize: 43)))),
            const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(breed.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4), Text('Происхождение: ${breed.origin}', style: TextStyle(color: Colors.grey.shade600)),
            ])),
            IconButton.filledTonal(onPressed: onFavorite, icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? const Color(0xFFD66B64) : null)),
          ]),
          const SizedBox(height: 23),
          const Text('Основные характеристики', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _fact('Вес', breed.weightLabel, Icons.monitor_weight_outlined)),
            const SizedBox(width: 10), Expanded(child: _fact('Жизнь', breed.lifeLabel, Icons.schedule)),
          ]),
          const SizedBox(height: 10), _fact('Длина шерсти', breed.length, Icons.straighten),
          const SizedBox(height: 24),
          const Text('Характер и особенности', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          ...scores.map((item) => _scoreRow(item.$1, item.$2, item.$3)),
        ]),
      ),
    );
  }

  Widget _fact(String title, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Row(children: [Icon(icon, color: const Color(0xFF718B68), size: 20), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)), const SizedBox(height: 3), Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))]))]),
  );

  Widget _scoreRow(String title, int value, IconData icon) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(children: [Icon(icon, size: 18, color: const Color(0xFF718B68)), const SizedBox(width: 10), SizedBox(width: 145, child: Text(title, style: const TextStyle(fontSize: 12))), Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: value.clamp(0, 5).toDouble() / 5, minHeight: 7, backgroundColor: const Color(0xFFE5E9E0), color: const Color(0xFF718B68)))), const SizedBox(width: 10), SizedBox(width: 28, child: Text('$value/5', textAlign: TextAlign.end, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))],
    ),
  );
}
