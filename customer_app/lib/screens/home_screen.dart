import 'package:flutter/material.dart';
import 'create_order_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Naql Alathath')),
      body: Center(
        child: ElevatedButton(
          child: const Text('طلب نقل عفش'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateOrderScreen()),
            );
          },
        ),
      ),
    );
  }
}
