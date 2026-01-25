import 'package:flutter/material.dart';
import 'order_completed_screen.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الطلب')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_shipping, size: 80),
          const SizedBox(height: 20),
          const Text('السائق في الطريق'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderCompletedScreen(),
                ),
              );
            },
            child: const Text('إنهاء الطلب'),
          ),
        ],
      ),
    );
  }
}
