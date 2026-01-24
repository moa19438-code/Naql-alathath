import 'package:flutter/material.dart';
import 'orders_screen.dart';
import 'drivers_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة التحكم')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('الطلبات'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
          ),
          ListTile(
            title: const Text('السائقين'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DriversScreen())),
          ),
        ],
      ),
    );
  }
}
