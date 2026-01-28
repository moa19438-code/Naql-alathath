import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: 'Naql Alathath',
      actions: const [
        Padding(
          padding: EdgeInsetsDirectional.only(end: 8),
          child: Icon(Icons.notifications_none),
        ),
      ],
      body: ListView(
        children: [
          AppCard(
            child: Row(
              children: [
                Icon(Icons.my_location, color: cs.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('موقعك الحالي', style: t.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'الرياض • حي النرجس (تجريبي)',
                        style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_location_alt_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('جاهز تنقل أثاثك؟', style: t.titleLarge),
                const SizedBox(height: 6),
                Text(
                  'احجز نقل سريع مع تتبّع مباشر وتأكيد فوري.',
                  style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'اطلب نقل الآن',
                  icon: Icons.local_shipping_outlined,
                  onPressed: () => context.go(AppRoutes.createOrder),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Text('الخدمات', style: t.titleLarge),
          const SizedBox(height: 10),
          const _ServicesGrid(),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text('آخر الطلبات', style: t.titleLarge)),
              TextButton(onPressed: () {}, child: const Text('عرض الكل')),
            ],
          ),
          const SizedBox(height: 10),

          const _OrderTile(
            title: 'نقل شقة',
            subtitle: 'من حي النرجس إلى حي الياسمين',
            status: 'مكتمل',
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: 10),
          const _OrderTile(
            title: 'نقل قطعة واحدة',
            subtitle: 'من حي الملقا إلى حي الصحافة',
            status: 'قيد التنفيذ',
            icon: Icons.chair_alt_outlined,
          ),
        ],
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          children: [
            Expanded(
              child: _ServiceCard(
                title: 'نقل شقة',
                subtitle: 'مع عمالة وتغليف',
                icon: Icons.apartment_outlined,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ServiceCard(
                title: 'نقل مكتب',
                subtitle: 'تنظيم وترتيب',
                icon: Icons.business_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ServiceCard(
                title: 'قطعة واحدة',
                subtitle: 'سريع وخفيف',
                icon: Icons.chair_alt_outlined,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ServiceCard(
                title: 'تغليف فقط',
                subtitle: 'مواد ممتازة',
                icon: Icons.inventory_2_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      onTap: () {},
      child: AppCard(
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final IconData icon;

  const _OrderTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final statusColor = status == 'مكتمل' ? cs.primary : cs.secondary;

    return AppCard(
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: cs.surfaceVariant.withOpacity(0.55),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: t.labelMedium?.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
