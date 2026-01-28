import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

void main() {
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Naql Alathath',
      body: Column(
        children: [
          const AppCard(
            child: Text('واجهة جديدة فخمة تبدأ من هنا 👌'),
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'ابدأ طلب نقل',
            onPressed: () {},
            icon: Icons.local_shipping_outlined,
          ),
        ],
      ),
    );
  }
}
