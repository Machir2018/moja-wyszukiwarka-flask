import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MojaWyszukiwarkaApp());
}

class MojaWyszukiwarkaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moja Wyszukiwarka',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: WyszukiwarkaScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WyszukiwarkaScreen extends StatefulWidget {
  @override
  _WyszukiwarkaScreenState createState() => _WyszukiwarkaScreenState();
}

class _WyszukiwarkaScreenState extends State<WyszukiwarkaScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _results = [];
  bool _loading = false;

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _results.clear();
    });

    final url = Uri.parse('https://moja-wyszukiwarka-flask.onrender.com/search?q=$query');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _results = data.map((item) => item.toString()).toList();
        });
      } else {
        setState(() {
          _results = ['Błąd serwera: ${response.statusCode}'];
        });
      }
    } catch (e) {
      setState(() {
        _results = ['Błąd połączenia: $e'];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moja Wyszukiwarka'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 350,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Wpisz zapytanie...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              child: Text('Szukaj'),
            ),
            SizedBox(height: 24),
            _loading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(Icons.link),
                            title: Text(_results[index]),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );