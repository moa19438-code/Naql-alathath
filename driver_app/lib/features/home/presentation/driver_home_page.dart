import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool online = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: 'Driver',
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: Center(child: _StatusPill(online: online)),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('حالتك الآن', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                AppButton(
                  text: online ? 'متصل (Online)' : 'غير متصل (Offline)',
                  icon: online ? Icons.wifi : Icons.wifi_off,
                  onPressed: () => setState(() => online = !online),
                ),
                const SizedBox(height: 10),
                Text(
                  online
                      ? 'أنت متاح لاستقبال الطلبات القريبة.'
                      : 'فعّل وضع Online لاستقبال الطلبات.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('طلبات قريبة', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _NearbyOrderCard(
                index: i + 1,
                onAccept: online ? () {} : null,
                onReject: online ? () {} : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyOrderCard extends StatelessWidget {
  final int index;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _NearbyOrderCard({
    required this.index,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('طلب #$index', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.my_location, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('من: حي النرجس')),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('إلى: حي الياسمين')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'قبول',
                  icon: Icons.check_circle_outline,
                  onPressed: onAccept,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  text: 'رفض',
                  icon: Icons.close,
                  variant: AppButtonVariant.secondary,
                  onPressed: onReject,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool online;
  const _StatusPill({required this.online});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = online ? cs.primaryContainer : cs.errorContainer;
    final fg = online ? cs.onPrimaryContainer : cs.onErrorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        online ? 'ONLINE' : 'OFFLINE',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
      ),
    );
  }
}
