import 'package:flutter/material.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naql Alathath - Admin (Demo)',
      home: Scaffold(
        appBar: AppBar(title: const Text('Admin Panel (Demo)')),
        body: Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('لوحة تحكم وهمية'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('إدارة الطلبات (وهمي)'),
            ),
          ],
        )),
      ),
    );
  }
}
