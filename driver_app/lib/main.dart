import 'package:flutter/material.dart';

void main() => runApp(const DriverApp());

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naql Alathath - Driver (Demo)',
      home: Scaffold(
        appBar: AppBar(title: const Text('Driver (Demo)')),
        body: Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تطبيق السائق الوهمي'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('عرض الطلبات (وهمي)'),
            ),
          ],
        )),
      ),
    );
  }
}
