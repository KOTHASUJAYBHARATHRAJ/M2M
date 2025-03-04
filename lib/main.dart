import 'package:flutter/material.dart';
import './pages/currmet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Removed debug banner
      home: CurrencyConverter(), // Fixed class name to match your widget
    );
  }
}
