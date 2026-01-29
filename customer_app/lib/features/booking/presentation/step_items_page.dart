import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class StepItemsPage extends StatefulWidget {
  final String initialNotes;
  final VoidCallback onClose;
  final VoidCallback onBack;
  final void Function(String notes) onNext;

  const StepItemsPage({
    super.key,
    required this.initialNotes,
    required this.onClose,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<StepItemsPage> createState() => _StepItemsPageState();
}

class _StepItemsPageState extends State<StepItemsPage> {
  late final TextEditingController _notes =
      TextEditingController(text: widget.initialNotes);

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'تفاصيل الأثاث',
      actions: [
        IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('وش بتنقل؟', style: t.titleLarge),
          const SizedBox(height: 10),
          const AppCard(
            child: Text('مؤقتًا نستخدم ملاحظات. لاحقًا بنضيف اختيار عدد القطع + صور + تغليف + عمال إضافيين.'),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'ملاحظات (اختياري)',
            hint: 'مثال: ثلاجة + سرير + كنب… الدور الثالث بدون مصعد',
            controller: _notes,
            keyboardType: TextInputType.multiline,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'رجوع',
                  variant: AppButtonVariant.secondary,
                  icon: Icons.arrow_back,
                  onPressed: widget.onBack,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  text: 'التالي',
                  icon: Icons.arrow_forward,
                  onPressed: () => widget.onNext(_notes.text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
