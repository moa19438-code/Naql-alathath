import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

import 'create_order_model.dart';

class StepSchedulePage extends StatefulWidget {
  final CreateOrderModel model;
  final VoidCallback onClose;
  final VoidCallback onBack;
  final void Function(DateTime scheduledAt) onConfirm;

  const StepSchedulePage({
    super.key,
    required this.model,
    required this.onClose,
    required this.onBack,
    required this.onConfirm,
  });

  @override
  State<StepSchedulePage> createState() => _StepSchedulePageState();
}

class _StepSchedulePageState extends State<StepSchedulePage> {
  DateTime? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.model.scheduledAt;
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      initialDate: (selected ?? now),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selected ?? now.add(const Duration(hours: 1))),
    );
    if (time == null) return;

    setState(() {
      selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: 'الموعد والملخص',
      actions: [
        IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اختر موعد النقل', style: t.titleLarge),
          const SizedBox(height: 10),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.schedule),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selected == null
                        ? 'ما تم اختيار موعد'
                        : '${selected!.year}/${selected!.month}/${selected!.day} - ${selected!.hour.toString().padLeft(2, '0')}:${selected!.minute.toString().padLeft(2, '0')}',
                    style: t.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: _pickDateTime,
                  child: Text(selected == null ? 'اختيار' : 'تعديل'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Text('ملخص الطلب', style: t.titleLarge),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Row('الخدمة', _serviceLabel(widget.model.serviceType)),
                const SizedBox(height: 6),
                _Row('من', widget.model.fromAddress ?? '-'),
                const SizedBox(height: 6),
                _Row('إلى', widget.model.toAddress ?? '-'),
                const SizedBox(height: 6),
                _Row('ملاحظات', (widget.model.itemsNotes?.trim().isEmpty ?? true) ? '—' : widget.model.itemsNotes!.trim()),
              ],
            ),
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
                  text: 'تأكيد الطلب',
                  icon: Icons.check_circle_outline,
                  onPressed: (selected == null)
                      ? null
                      : () => widget.onConfirm(selected!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'ملاحظة: التأكيد الآن يرجع للصفحة الرئيسية (بدون إرسال للباكند).',
            style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  String _serviceLabel(String? v) {
    return switch (v) {
      'apartment' => 'نقل شقة',
      'office' => 'نقل مكتب',
      'single' => 'قطعة واحدة',
      'packing' => 'تغليف فقط',
      _ => '—',
    };
  }
}

class _Row extends StatelessWidget {
  final String k;
  final String v;
  const _Row(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text(k, style: t.labelLarge)),
        Expanded(child: Text(v, style: t.bodyMedium)),
      ],
    );
  }
}
