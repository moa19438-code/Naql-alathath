import 'package:flutter/material.dart';
import 'orders_screen.dart';

class HomeScreenDriver extends StatelessWidget {
  const HomeScreenDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Naql Alathath Driver')),
      body: Center(
        child: ElevatedButton(
          child: const Text('عرض الطلبات'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            );
          },
        ),
      ),
    );
  }
}
