import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/di.dart';
import '../models/cat_breed.dart';
import '../services/cat_service.dart';
import '../widgets/breed_card.dart';
import '../widgets/breed_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  final Set<String> _favorites = {};
  List<CatBreed> _breeds = [];
  bool _loading = true;
  String? _error;
  int _tab = 0;
  String _sort = 'По алфавиту';
  String _filter = 'Все';

  @override
  void initState() {
    super.initState();
    _favorites.addAll(getIt<SharedPreferences>().getStringList('favorite_breeds') ?? []);
    _load();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await getIt<CatService>().fetchBreeds();
      if (!mounted) return;
      setState(() { _breeds = result; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  Future<void> _toggleFavorite(CatBreed breed) async {
    setState(() {
      if (!_favorites.add(breed.name)) _favorites.remove(breed.name);
    });
    await getIt<SharedPreferences>().setStringList('favorite_breeds', _favorites.toList());
  }

  List<CatBreed> get _visible {
    var items = _breeds.where((b) {
      final q = _search.text.trim().toLowerCase();
      final matchesSearch = b.name.toLowerCase().contains(q) || b.origin.toLowerCase().contains(q);
      final matchesTab = _tab == 0 || _favorites.contains(b.name);
      final matchesFilter = switch (_filter) {
        'Для семьи' => b.familyFriendly >= 4,
        'Для детей' => b.childrenFriendly >= 4,
        'Умные' => b.intelligence >= 4,
        _ => true,
      };
      return matchesSearch && matchesTab && matchesFilter;
    }).toList();
    if (_sort == 'По популярности для семьи') {
      items.sort((a,b) => b.familyFriendly.compareTo(a.familyFriendly));
    } else if (_sort == 'По продолжительности жизни') {
      items.sort((a,b) => b.maxLife.compareTo(a.maxLife));
    } else {
      items.sort((a,b) => a.name.compareTo(b.name));
    }
    return items;
  }

  void _openDetails(CatBreed breed) => showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (_) => BreedDetails(breed: breed, isFavorite: _favorites.contains(breed.name), onFavorite: () => _toggleFavorite(breed)),
  );

  void _surpriseMe() {
    if (_breeds.isEmpty) return;
    final breed = _breeds[Random().nextInt(_breeds.length)];
    _openDetails(breed);
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    return Scaffold(
      body: SafeArea(child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _header()),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
          child: TextField(controller: _search, decoration: InputDecoration(
            hintText: 'Найти породу или страну…', prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _search.text.isEmpty ? null : IconButton(icon: const Icon(Icons.close), onPressed: _search.clear),
          )),
        )),
        SliverToBoxAdapter(child: _controls()),
        if (_loading) const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator()))
        else if (_error != null) SliverFillRemaining(hasScrollBody: false, child: _errorState())
        else if (items.isEmpty) SliverFillRemaining(hasScrollBody: false, child: _emptyState())
        else SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          sliver: SliverLayoutBuilder(builder: (context, constraints) {
            final width = constraints.crossAxisExtent;
            final count = width > 850 ? 3 : width > 560 ? 2 : 1;
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count, mainAxisSpacing: 14, crossAxisSpacing: 14,
                mainAxisExtent: count == 1 ? 190 : 220,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final breed = items[index];
                return BreedCard(breed: breed, isFavorite: _favorites.contains(breed.name),
                  onTap: () => _openDetails(breed), onFavorite: () => _toggleFavorite(breed));
              }, childCount: items.length),
            );
          }),
        ),
      ])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Каталог'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Избранное'),
        ],
      ),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFE5EBDD), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.pets_rounded, color: Color(0xFF536B50))),
        const SizedBox(width: 11),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CAT ATLAS', style: TextStyle(fontSize: 11, letterSpacing: 2.2, fontWeight: FontWeight.w800, color: Color(0xFF71806B))), Text('Мир кошачьих пород', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF20251F)))]),
        const Spacer(),
        IconButton(onPressed: _load, tooltip: 'Обновить каталог', icon: const Icon(Icons.refresh_rounded)),
      ]),
      const SizedBox(height: 22),
      Container(
        width: double.infinity, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF536B50), Color(0xFF344A3B)])),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Найди своего\nидеального компаньона', style: TextStyle(color: Colors.white, fontSize: 22, height: 1.16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 9),
            Text(_loading ? 'Загружаем каталог…' : '${_breeds.length} пород в каталоге · изучай и сравнивай', style: const TextStyle(color: Color(0xFFDCE5D6), fontSize: 12)),
            const SizedBox(height: 15),
            OutlinedButton.icon(onPressed: _surpriseMe, icon: const Icon(Icons.auto_awesome, size: 16), label: const Text('Удиви меня'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54))),
          ])),
          const SizedBox(width: 8),
          const Text('🐈', style: TextStyle(fontSize: 76)),
        ]),
      ),
    ]),
  );

  Widget _controls() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 5, 20, 8),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(_tab == 0 ? 'Исследуй породы' : 'Твои любимцы', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const Spacer(),
        PopupMenuButton<String>(initialValue: _sort, onSelected: (v) => setState(() => _sort = v), itemBuilder: (_) => const [
          PopupMenuItem(value: 'По алфавиту', child: Text('По алфавиту')),
          PopupMenuItem(value: 'По популярности для семьи', child: Text('Для семьи')),
          PopupMenuItem(value: 'По продолжительности жизни', child: Text('Долгожители')),
        ], child: Row(children: [const Icon(Icons.swap_vert, size: 18), const SizedBox(width: 4), Text('Сортировка', style: TextStyle(fontSize: 12, color: Colors.grey.shade700))])),
      ]),
      const SizedBox(height: 10),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
        _filterChip('Все'), const SizedBox(width: 8), _filterChip('Для семьи'), const SizedBox(width: 8),
        _filterChip('Для детей'), const SizedBox(width: 8), _filterChip('Умные'),
      ])),
      if (!_loading && _error == null) Padding(padding: const EdgeInsets.only(top: 9), child: Text('Найдено: ${_visible.length}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
    ]),
  );

  Widget _filterChip(String label) => FilterChip(
    label: Text(label), selected: _filter == label,
    onSelected: (_) => setState(() => _filter = label),
    showCheckmark: false, selectedColor: const Color(0xFFE1E9DC),
    side: BorderSide(color: _filter == label ? const Color(0xFF536B50) : Colors.black12),
    labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _filter == label ? const Color(0xFF3F593D) : Colors.black87),
  );

  Widget _errorState() => Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.cloud_off_rounded, size: 48, color: Color(0xFF879481)), const SizedBox(height: 12),
    const Text('Не удалось загрузить каталог', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8),
    Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)), const SizedBox(height: 18),
    FilledButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: const Text('Повторить')),
  ])));

  Widget _emptyState() {
    final favoritesAreEmpty = _tab == 1 && _favorites.isEmpty;
    return Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(favoritesAreEmpty ? Icons.favorite_border_rounded : Icons.search_off_rounded, size: 48, color: const Color(0xFF879481)),
      const SizedBox(height: 12),
      Text(
        favoritesAreEmpty ? 'В избранном пока пусто' : 'Ничего не найдено',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 6),
      Text(
        favoritesAreEmpty
            ? 'Добавляй понравившиеся породы в избранное, чтобы быстро находить их здесь.'
            : 'Измени запрос или фильтр, чтобы увидеть другие породы.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54),
      ),
      if (favoritesAreEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: FilledButton.icon(
            onPressed: () => setState(() => _tab = 0),
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Перейти в каталог'),
          ),
        )
      else
        TextButton(
          onPressed: () => setState(() { _search.clear(); _filter = 'Все'; _tab = 0; }),
          child: const Text('Сбросить фильтры'),
        ),
    ])));
  }
}
