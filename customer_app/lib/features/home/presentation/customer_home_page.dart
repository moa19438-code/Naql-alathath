import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import '../../../app/router.dart';

class CustomerMapHomePage extends StatefulWidget {
  const CustomerMapHomePage({super.key});

  @override
  State<CustomerMapHomePage> createState() => _CustomerMapHomePageState();
}

class _CustomerMapHomePageState extends State<CustomerMapHomePage> {
  GoogleMapController? _mapController;

  static const LatLng _defaultCenter = LatLng(24.7136, 46.6753); // Riyadh
  static const CameraPosition _defaultCamera =
      CameraPosition(target: _defaultCenter, zoom: 12);

  final loc.Location _location = loc.Location();
  StreamSubscription<loc.LocationData>? _sub;

  LatLng? _myLatLng;
  bool _locLoading = false;
  String? _locHint;

  // UI state
  String? fromLabel;
  String? toLabel;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    setState(() {
      _locLoading = true;
      _locHint = null;
    });

    try {
      final enabled = await _location.serviceEnabled();
      if (!enabled) {
        final turnedOn = await _location.requestService();
        if (!turnedOn) {
          setState(() {
            _locHint = 'فعّل خدمة الموقع لعرض موقعك.';
            _locLoading = false;
          });
          return;
        }
      }

      var perm = await _location.hasPermission();
      if (perm == loc.PermissionStatus.denied) {
        perm = await _location.requestPermission();
      }
      if (perm != loc.PermissionStatus.granted &&
          perm != loc.PermissionStatus.grantedLimited) {
        setState(() {
          _locHint = 'تم رفض إذن الموقع.';
          _locLoading = false;
        });
        return;
      }

      final current = await _location.getLocation();
      if (current.latitude != null && current.longitude != null) {
        final p = LatLng(current.latitude!, current.longitude!);
        setState(() {
          _myLatLng = p;
          _locLoading = false;
        });
        _animateTo(p);
      } else {
        setState(() {
          _locHint = 'تعذر قراءة الموقع الحالي.';
          _locLoading = false;
        });
      }

      _sub = _location.onLocationChanged.listen((e) {
        if (e.latitude == null || e.longitude == null) return;
        setState(() => _myLatLng = LatLng(e.latitude!, e.longitude!));
      });
    } catch (_) {
      setState(() {
        _locHint = 'حدث خطأ أثناء تشغيل الموقع.';
        _locLoading = false;
      });
    }
  }

  Future<void> _animateTo(LatLng p) async {
    final c = _mapController;
    if (c == null) return;
    await c.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: p, zoom: 15)),
    );
  }

  Future<void> _openPickupDropoffSheet() async {
    final result = await showModalBottomSheet<_PickupDropoffResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickupDropoffSheet(
        currentFrom: fromLabel,
        currentTo: toLabel,
      ),
    );

    if (result == null) return;

    setState(() {
      fromLabel = result.from;
      toLabel = result.to;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final markers = <Marker>{
      if (_myLatLng != null)
        Marker(
          markerId: const MarkerId('me'),
          position: _myLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
    };

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _defaultCamera,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: markers,
              onMapCreated: (c) => _mapController = c,
            ),
          ),

          // Top overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _TopSearchBar(
                          subtitle: _locLoading
                              ? 'جارٍ تحديد موقعك...'
                              : (_locHint ?? 'جاهز لطلب نقل'),
                          onTap: _openPickupDropoffSheet,
                        ),
                      ),
                      const SizedBox(width: 10),
                      AppCard(
                        padding: const EdgeInsets.all(6),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_locHint != null)
                    AppCard(
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: cs.onSurfaceVariant),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _locHint!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ),
                          TextButton(
                            onPressed: _initLocation,
                            child: const Text('إعادة'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Floating GPS
          Positioned(
            right: AppSpacing.md,
            bottom: 250,
            child: AppCard(
              padding: const EdgeInsets.all(6),
              child: IconButton(
                onPressed:
                    _myLatLng == null ? _initLocation : () => _animateTo(_myLatLng!),
                icon: const Icon(Icons.gps_fixed),
              ),
            ),
          ),

          // Bottom sheet (Uber-like)
          _HomeBottomSheet(
            fromLabel: fromLabel,
            toLabel: toLabel,
            onSetFromTo: _openPickupDropoffSheet,
            onCreateOrder: () => context.go(CustomerRoutes.createOrder),
          ),
        ],
      ),
    );
  }
}

class _TopSearchBar extends StatelessWidget {
  final String subtitle;
  final VoidCallback onTap;

  const _TopSearchBar({
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('إلى أين؟', style: t.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _HomeBottomSheet extends StatelessWidget {
  final String? fromLabel;
  final String? toLabel;
  final VoidCallback onSetFromTo;
  final VoidCallback onCreateOrder;

  const _HomeBottomSheet({
    required this.fromLabel,
    required this.toLabel,
    required this.onSetFromTo,
    required this.onCreateOrder,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.22,
      maxChildSize: 0.62,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.xl),
            ),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 44,
                  decoration: BoxDecoration(
                    color: cs.onSurfaceVariant.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('طلب جديد', style: t.titleLarge),
              const SizedBox(height: 10),

              AppCard(
                child: Column(
                  children: [
                    _FromToRow(
                      title: 'من',
                      value: fromLabel ?? 'اختر موقع الاستلام',
                      icon: Icons.my_location,
                      onTap: onSetFromTo,
                    ),
                    const Divider(height: 18),
                    _FromToRow(
                      title: 'إلى',
                      value: toLabel ?? 'اختر موقع التسليم',
                      icon: Icons.location_on_outlined,
                      onTap: onSetFromTo,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              AppButton(
                text: 'اطلب نقل الآن',
                icon: Icons.local_shipping_outlined,
                onPressed: onCreateOrder,
              ),

              const SizedBox(height: 12),
              Text('الخدمات', style: t.titleLarge),
              const SizedBox(height: 10),
              const _ServiceRow(),
            ],
          ),
        );
      },
    );
  }
}

class _FromToRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _FromToRow({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: cs.onPrimaryContainer, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _ServiceRow extends StatelessWidget {
  const _ServiceRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _MiniServiceCard(
            title: 'نقل شقة',
            icon: Icons.apartment_outlined,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _MiniServiceCard(
            title: 'قطعة واحدة',
            icon: Icons.chair_alt_outlined,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _MiniServiceCard(
            title: 'تغليف',
            icon: Icons.inventory_2_outlined,
          ),
        ),
      ],
    );
  }
}

class _MiniServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _MiniServiceCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      onTap: () {},
      child: AppCard(
        child: Column(
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
            const SizedBox(height: 10),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
/// Bottom sheet to set From/To
/// ---------------------------
class _PickupDropoffResult {
  final String? from;
  final String? to;
  const _PickupDropoffResult({this.from, this.to});
}

class _PickupDropoffSheet extends StatefulWidget {
  final String? currentFrom;
  final String? currentTo;

  const _PickupDropoffSheet({
    required this.currentFrom,
    required this.currentTo,
  });

  @override
  State<_PickupDropoffSheet> createState() => _PickupDropoffSheetState();
}

class _PickupDropoffSheetState extends State<_PickupDropoffSheet> {
  late final TextEditingController fromC =
      TextEditingController(text: widget.currentFrom ?? '');
  late final TextEditingController toC =
      TextEditingController(text: widget.currentTo ?? '');

  @override
  void dispose() {
    fromC.dispose();
    toC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(child: Text('تحديد المسار')),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AppTextField(
                label: 'من (Pickup)',
                hint: 'مثال: حي النرجس',
                controller: fromC,
                prefixIcon: const Icon(Icons.my_location),
              ),
              const SizedBox(height: 10),
              AppTextField(
                label: 'إلى (Dropoff)',
                hint: 'مثال: حي الياسمين',
                controller: toC,
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
              const SizedBox(height: 12),

              // Saved / Recent (تجريبي)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('اقتراحات سريعة'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _Chip(
                          text: 'المنزل',
                          onTap: () => setState(() => toC.text = 'المنزل'),
                        ),
                        _Chip(
                          text: 'العمل',
                          onTap: () => setState(() => toC.text = 'العمل'),
                        ),
                        _Chip(
                          text: 'حي النرجس',
                          onTap: () => setState(() => fromC.text = 'حي النرجس'),
                        ),
                        _Chip(
                          text: 'حي الياسمين',
                          onTap: () => setState(() => toC.text = 'حي الياسمين'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              AppButton(
                text: 'تأكيد',
                icon: Icons.check,
                onPressed: () {
                  Navigator.pop(
                    context,
                    _PickupDropoffResult(
                      from: fromC.text.trim().isEmpty ? null : fromC.text.trim(),
                      to: toC.text.trim().isEmpty ? null : toC.text.trim(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _Chip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(0.6),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(text),
      ),
    );
  }
}
