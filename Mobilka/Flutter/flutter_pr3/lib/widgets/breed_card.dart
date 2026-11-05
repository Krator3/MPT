import 'package:flutter/material.dart';
import '../models/cat_breed.dart';

class BreedCard extends StatelessWidget {
  const BreedCard({super.key, required this.breed, required this.isFavorite, required this.onTap, required this.onFavorite});
  final CatBreed breed;
  final bool isFavorite;
  final VoidCallback onTap, onFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, borderRadius: BorderRadius.circular(22),
      child: InkWell(borderRadius: BorderRadius.circular(22), onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 52, height: 52, decoration: BoxDecoration(color: const Color(0xFFF0F2EB), borderRadius: BorderRadius.circular(17)), child: const Center(child: Text('🐈', style: TextStyle(fontSize: 29))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(breed.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 3), Text(breed.origin, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ])),
            IconButton(onPressed: onFavorite, visualDensity: VisualDensity.compact, icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? const Color(0xFFD66B64) : Colors.black38)),
          ]),
          const Spacer(),
          Row(children: [
            _miniInfo(Icons.monitor_weight_outlined, breed.weightLabel), const SizedBox(width: 12),
            _miniInfo(Icons.schedule_rounded, breed.lifeLabel),
          ]),
          const SizedBox(height: 13),
          Row(children: [
            Expanded(child: _score('Семья', breed.familyFriendly)),
            const SizedBox(width: 10), Expanded(child: _score('Игривость', breed.playfulness)),
            const SizedBox(width: 10), Expanded(child: _score('Ум', breed.intelligence)),
          ]),
          const SizedBox(height: 10),
          Row(children: [Text('Подробнее о породе', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600)), const Spacer(), const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF536B50))]),
        ])),
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) => Expanded(child: Row(children: [Icon(icon, size: 14, color: const Color(0xFF75836E)), const SizedBox(width: 5), Flexible(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.black87)))]));

  Widget _score(String label, int value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Expanded(child: Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600))), Text('$value/5', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
    const SizedBox(height: 5), ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(value: value.clamp(0, 5).toDouble() / 5, minHeight: 5, backgroundColor: const Color(0xFFEDF0E9), color: const Color(0xFF718B68))),
  ]);
}
