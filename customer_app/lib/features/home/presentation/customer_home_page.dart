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

  // Riyadh default
  static const LatLng _defaultCenter = LatLng(24.7136, 46.6753);
  static const CameraPosition _defaultCamera =
      CameraPosition(target: _defaultCenter, zoom: 12);

  final loc.Location _location = loc.Location();
  StreamSubscription<loc.LocationData>? _sub;

  LatLng? _myLatLng;
  String? _locationHint;
  bool _locLoading = false;

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
      _locationHint = null;
    });

    try {
      final enabled = await _location.serviceEnabled();
      if (!enabled) {
        final turnedOn = await _location.requestService();
        if (!turnedOn) {
          setState(() {
            _locationHint = 'فعّل خدمة الموقع لعرض موقعك على الخريطة.';
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
          _locationHint = 'تم رفض إذن الموقع.';
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
          _locationHint = 'تعذر قراءة الموقع الحالي.';
          _locLoading = false;
        });
      }

      // تحديثات لاحقة (اختياري)
      _sub = _location.onLocationChanged.listen((e) {
        if (e.latitude == null || e.longitude == null) return;
        setState(() => _myLatLng = LatLng(e.latitude!, e.longitude!));
      });
    } catch (_) {
      setState(() {
        _locationHint = 'حدث خطأ أثناء تشغيل الموقع.';
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final markers = <Marker>{
      if (_myLatLng != null)
        Marker(
          markerId: const MarkerId('me'),
          position: _myLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure),
        ),
    };

    return Scaffold(
      // نخلي الخريطة خلف، وUI فوقها
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _defaultCamera,
              myLocationEnabled: false, // نخليه false ونحط marker بنفسنا
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: markers,
              onMapCreated: (c) => _mapController = c,
            ),
          ),

          // Top bar فوق الخريطة (فخم)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  // Card خلفية للعنوان/الموقع
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.my_location, color: cs.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('موقعك الحالي', style: t.titleMedium),
                                const SizedBox(height: 2),
                                Text(
                                  _myLatLng != null
                                      ? 'جاهز لطلب نقل'
                                      : (_locLoading
                                          ? 'جارٍ تحديد موقعك...'
                                          : (_locationHint ??
                                              'الرياض (افتراضي)')),
                                  style: t.bodySmall
                                      ?.copyWith(color: cs.onSurfaceVariant),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _initLocation,
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Notifications
                  AppCard(
                    padding: const EdgeInsets.all(6),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // زر “تحديد موقعي” (floating)
          Positioned(
            right: AppSpacing.md,
            bottom: 240,
            child: AppCard(
              padding: const EdgeInsets.all(6),
              child: IconButton(
                onPressed: _myLatLng == null ? _initLocation : () => _animateTo(_myLatLng!),
                icon: const Icon(Icons.gps_fixed),
              ),
            ),
          ),

          // Bottom Sheet فخم (مثل أوبر)
          _BottomSheet(
            onCreateOrder: () => context.go(CustomerRoutes.createOrder),
          ),
        ],
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final VoidCallback onCreateOrder;
  const _BottomSheet({required this.onCreateOrder});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.20,
      maxChildSize: 0.60,
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

              Text('إلى أين؟', style: t.titleLarge),
              const SizedBox(height: 10),

              AppCard(
                child: Row(
                  children: [
                    Icon(Icons.search, color: cs.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ابحث عن موقع الاستلام/التسليم (قريبًا)',
                        style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ),
                    const Icon(Icons.chevron_right),
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
