import 'package:flutter/material.dart';
import 'create_order_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('وين تبي ننقل؟')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('نقل عفش'),
              subtitle: const Text('شاحنات + عمال'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateOrderScreen(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('شحن سريع'),
              subtitle: const Text('أغراض خفيفة'),
            ),
          ),
        ],
      ),
    );
  }
}
