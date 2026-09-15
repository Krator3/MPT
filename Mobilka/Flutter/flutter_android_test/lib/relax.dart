import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5D14D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/relax.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Peter Mach',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mind Deep Relax',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Join the Community as we prepare over 33 days to relax and feel joy with the mind and happiness session across the World.',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009B97),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Play Next Session',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildListItem(
                  iconColor: const Color(0xFF4A7BFF),
                  title: 'Sweet Memories',
                  subtitle: 'December 29 Pre-Launch',
                ),
                const SizedBox(height: 16),
                _buildListItem(
                  iconColor: const Color(0xFF009B97),
                  title: 'A Day Dream',
                  subtitle: 'December 29 Pre-Launch',
                ),
                const SizedBox(height: 16),
                _buildListItem(
                  iconColor: const Color(0xFFF2994A),
                  title: 'Mind Explore',
                  subtitle: 'December 29 Pre-Launch',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem({
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz, color: Color(0xFFCCCCCC)),
      ],
    );
  }
}