import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dodaj Wpis',
      theme: ThemeData(
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      home: AddEntryPage(),
    );
  }
}

class AddEntryPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

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
                  padding: EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBoldHeader('Nowy wpis'),
                              SizedBox(height: 24),
                              _buildTextField(titleController, Icons.title, 'Tytuł', 'Wprowadź tytuł'),
                              SizedBox(height: 16),
                              _buildTextField(descriptionController, Icons.description, 'Opis', 'Wprowadź opis'),
                              SizedBox(height: 32),
                              _buildSearchLabel(),
                              SizedBox(height: 8),
                              _buildTextField(searchController, Icons.search, 'Szukaj', 'Wyszukaj...'),
                              SizedBox(height: 32),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Wpis dodany!')),
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.check_circle),
                                  label: Text('Zapisz', style: TextStyle(fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildSearchLabel() {
    return Text(
      'Wyszukaj Markę lub Sprzedawcę',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade800),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String label, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        hintText: hint,
      ),
      validator: (value) => value == null || value.isEmpty ? 'To pole jest wymagane' : null,
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