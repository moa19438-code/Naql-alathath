import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class StepServicePage extends StatelessWidget {
  final String? selected;
  final void Function(String value) onSelect;
  final VoidCallback? onNext;
  final VoidCallback onClose;

  const StepServicePage({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onClose,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'طلب جديد',
      actions: [
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اختر نوع الخدمة', style: t.titleLarge),
          const SizedBox(height: 10),
          _ChoiceTile(
            title: 'نقل شقة',
            subtitle: 'نقل كامل مع عمالة',
            icon: Icons.apartment_outlined,
            selected: selected == 'apartment',
            onTap: () => onSelect('apartment'),
          ),
          const SizedBox(height: 10),
          _ChoiceTile(
            title: 'نقل مكتب',
            subtitle: 'نقل أثاث مكتبي',
            icon: Icons.business_outlined,
            selected: selected == 'office',
            onTap: () => onSelect('office'),
          ),
          const SizedBox(height: 10),
          _ChoiceTile(
            title: 'قطعة واحدة',
            subtitle: 'كرسي/ثلاجة/غسالة…',
            icon: Icons.chair_alt_outlined,
            selected: selected == 'single',
            onTap: () => onSelect('single'),
          ),
          const SizedBox(height: 10),
          _ChoiceTile(
            title: 'تغليف فقط',
            subtitle: 'بدون نقل',
            icon: Icons.inventory_2_outlined,
            selected: selected == 'packing',
            onTap: () => onSelect('packing'),
          ),
          const Spacer(),
          AppButton(
            text: 'التالي',
            icon: Icons.arrow_forward,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      onTap: onTap,
      child: AppCard(
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: selected
                    ? cs.primaryContainer
                    : cs.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: selected ? cs.onPrimaryContainer : cs.onSurface,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle, color: cs.primary) else const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
