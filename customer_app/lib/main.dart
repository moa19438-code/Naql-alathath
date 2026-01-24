import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NaqlAlathathApp());
}

class NaqlAlathathApp extends StatelessWidget {
  const NaqlAlathathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naql Alathath',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}
