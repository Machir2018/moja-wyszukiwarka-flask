import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'link_item.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final newLink = LinkItem(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      url: linkController.text.trim(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('links')
          .add(newLink.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link dodany pomyślnie!')),
      );

      titleController.clear();
      descriptionController.clear();
      linkController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: ${e.toString()}')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj wpis'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Tytuł'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Wpisz tytuł' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Opis'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: linkController,
                        decoration: const InputDecoration(labelText: 'Link'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Wpisz link';
                          final uri = Uri.tryParse(value);
                          if (uri == null || !uri.hasAbsolutePath) return 'Niepoprawny URL';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: isSubmitting ? null : submit,
                        icon: const Icon(Icons.add),
                        label: const Text('Dodaj'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}