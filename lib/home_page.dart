import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  String searchQuery = '';

  void _submitSearch() {
    setState(() {
      searchQuery = searchController.text.trim();
    });

    // Tu możesz dodać logikę filtrowania wpisów
    print('Szukam: $searchQuery');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: SplatterPainter())),
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBoldHeader('Wyszukiwarka'),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                labelText: 'Szukaj',
                                hintText: 'Wyszukaj markę lub sprzedawcę',
                              ),
                              onFieldSubmitted: (_) => _submitSearch(),
                            ),
                            const SizedBox(height: 32),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: _submitSearch,
                                icon: const Icon(Icons.search),
                                label: const Text('Szukaj', style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (searchQuery.isNotEmpty)
                              Text('Wyniki dla: "$searchQuery"',
                                  style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBoldHeader(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SplatterPainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.green.withOpacity(0.3),
      Colors.red.withOpacity(0.3),
      Colors.white.withOpacity(0.2),
    ];

    for (int i = 0; i < 40; i++) {
      final paint = Paint()
        ..color = colors[random.nextInt(colors.length)]
        ..style = PaintingStyle.fill;

      final radius = random.nextDouble() * 50 + 20;
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}