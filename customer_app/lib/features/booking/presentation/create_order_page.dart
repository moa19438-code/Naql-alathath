import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:go_router/go_router.dart';

class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'إنشاء طلب',
      actions: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppCard(
            child: Text('هنا بنبدأ الـ Wizard خطوة بخطوة (خدمة، من/إلى، تفاصيل، موعد…)'),
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'التالي (قريبًا)',
            onPressed: () {},
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}
