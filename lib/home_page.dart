import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'link_item.dart';

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
  }

  Stream<List<LinkItem>> getLinksStream() {
    return FirebaseFirestore.instance
        .collection('links')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return LinkItem.fromFirestore(data);
            }).where((link) {
              final q = searchQuery.toLowerCase();
              return link.title.toLowerCase().contains(q) ||
                     link.description.toLowerCase().contains(q) ||
                     link.url.toLowerCase().contains(q);
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Transform.translate(
                offset: const Offset(0, -40),
                child: Center(
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
                              if (searchQuery.isNotEmpty) ...[
                                Text('Wyniki dla: "$searchQuery"',
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 16),
                                StreamBuilder<List<LinkItem>>(
                                  stream: getLinksStream(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return const CircularProgressIndicator();
                                    final links = snapshot.data!;
                                    if (links.isEmpty) {
                                      return const Text('Brak wyników.');
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: links.length,
                                      itemBuilder: (context, index) {
                                        final link = links[index];
                                        return Card(
                                          child: ListTile(
                                            title: Text(link.title),
                                            subtitle: Text(link.description),
                                            trailing: const Icon(Icons.open_in_new),
                                            onTap: () => launchUrl(Uri.parse(link.url)),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
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
}