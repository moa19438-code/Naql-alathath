import 'package:flutter/material.dart';

void main() => runApp(const CustomerApp());

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naql Alathath - Customer (Demo)',
      home: Scaffold(
        appBar: AppBar(title: const Text('Customer (Demo)')),
        body: Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تطبيق العميل الوهمي'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('إنشاء طلب (وهمي)'),
            ),
          ],
        )),
      ),
    );
  }
}
