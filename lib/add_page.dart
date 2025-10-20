import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  void submit() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final link = linkController.text.trim();

    if (title.isEmpty || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tytuł i link są wymagane')),
      );
      return;
    }

    print('Tytuł: $title\nOpis: $description\nLink: $link');

    titleController.clear();
    descriptionController.clear();
    linkController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj wpis')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Opis'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: linkController,
              decoration: const InputDecoration(labelText: 'Link'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submit,
              child: const Text('Dodaj'),
            ),
          ],
        ),
      ),
    );
  }
}