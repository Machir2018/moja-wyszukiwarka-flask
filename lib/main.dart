import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'link_item.dart';
import 'home_page.dart';
import 'add_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyA86bNGOOcH8IZc2-uyKKen-9NfgyoK9OA',
      authDomain: 'yupoo-linki.firebaseapp.com',
      projectId: 'yupoo-linki',
      storageBucket: 'yupoo-linki.firebasestorage.app',
      messagingSenderId: '991305640017',
      appId: '1:991305640017:web:5633580b4c497501e6f070',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moja Wyszukiwarka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/add': (context) => const AddPage(),
      },
    );
  }
}