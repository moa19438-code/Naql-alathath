import 'package:flutter/material.dart';
import 'searching_driver_screen.dart';

class CreateOrderScreen extends StatelessWidget {
  const CreateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: 'small', child: Text('حمولة صغيرة')),
                DropdownMenuItem(value: 'medium', child: Text('حمولة متوسطة')),
                DropdownMenuItem(value: 'large', child: Text('حمولة كبيرة')),
              ],
              onChanged: (_) {},
              hint: const Text('حجم الحمولة'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchingDriverScreen(),
                  ),
                );
              },
              child: const Text('تأكيد الطلب'),
            ),
          ],
        ),
      ),
    );
  }
}
