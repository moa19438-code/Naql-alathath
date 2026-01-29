import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class StepLocationsPage extends StatefulWidget {
  final String initialFrom;
  final String initialTo;
  final VoidCallback onClose;
  final VoidCallback onBack;
  final void Function(String from, String to) onNext;

  const StepLocationsPage({
    super.key,
    required this.initialFrom,
    required this.initialTo,
    required this.onClose,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<StepLocationsPage> createState() => _StepLocationsPageState();
}

class _StepLocationsPageState extends State<StepLocationsPage> {
  late final TextEditingController _from = TextEditingController(text: widget.initialFrom);
  late final TextEditingController _to = TextEditingController(text: widget.initialTo);

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  bool get _valid =>
      _from.text.trim().isNotEmpty && _to.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'العناوين',
      actions: [
        IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('من وين؟', style: t.titleLarge),
          const SizedBox(height: 10),
          AppTextField(
            label: 'موقع الاستلام',
            hint: 'مثال: الرياض، حي النرجس، شارع...',
            controller: _from,
            prefixIcon: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          Text('لوين؟', style: t.titleLarge),
          const SizedBox(height: 10),
          AppTextField(
            label: 'موقع التسليم',
            hint: 'مثال: الرياض، حي الياسمين، شارع...',
            controller: _to,
            prefixIcon: const Icon(Icons.location_on_outlined),
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
                  onPressed: _valid ? () => widget.onNext(_from.text, _to.text) : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
