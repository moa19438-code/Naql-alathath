import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import '../../../config/keys.dart';
import '../../../app/router.dart';
import '../../../core/places/google_places_api.dart';
import '../../../core/places/place_autocomplete_field.dart';

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

  void _goCreateOrder() {
    final from = (fromLabel ?? '').trim();
    final to = (toLabel ?? '').trim();

    final q = <String, String>{};
    if (from.isNotEmpty) q['from'] = from;
    if (to.isNotEmpty) q['to'] = to;

    final uri = Uri(path: CustomerRoutes.createOrder, queryParameters: q);
    context.go(uri.toString());
  }

  Future<void> _openFromToSheet() async {
    final r = await showModalBottomSheet<_FromToResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FromToSheet(from: fromLabel, to: toLabel),
    );

    if (r == null) return;
    setState(() {
      fromLabel = r.from;
      toLabel = r.to;
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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      onTap: _openFromToSheet,
                      child: AppCard(
                        child: Row(
                          children: [
                            Icon(Icons.search, color: cs.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'إلى أين؟',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _locLoading
                                        ? 'جارٍ تحديد موقعك...'
                                        : (_locHint ?? 'جاهز لطلب نقل'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: cs.onSurfaceVariant),
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
            ),
          ),

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

          DraggableScrollableSheet(
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

                    AppCard(
                      child: Column(
                        children: [
                          _Row(
                            title: 'من',
                            value: fromLabel ?? 'اختر موقع الاستلام',
                            icon: Icons.my_location,
                            onTap: _openFromToSheet,
                          ),
                          const Divider(height: 18),
                          _Row(
                            title: 'إلى',
                            value: toLabel ?? 'اختر موقع التسليم',
                            icon: Icons.location_on_outlined,
                            onTap: _openFromToSheet,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    AppButton(
                      text: 'اطلب نقل الآن',
                      icon: Icons.local_shipping_outlined,
                      onPressed: _goCreateOrder,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _Row({
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

class _FromToResult {
  final String? from;
  final String? to;
  const _FromToResult({this.from, this.to});
}

class _FromToSheet extends StatefulWidget {
  final String? from;
  final String? to;

  const _FromToSheet({this.from, this.to});

  @override
  State<_FromToSheet> createState() => _FromToSheetState();
}

class _FromToSheetState extends State<_FromToSheet> {
  late final TextEditingController fromC =
      TextEditingController(text: widget.from ?? '');
  late final TextEditingController toC =
      TextEditingController(text: widget.to ?? '');

  // ضع المفتاح أنت (ولا ترفعه للريبو العام)
  final places = GooglePlacesApi(apiKey: 'YOUR_GOOGLE_MAPS_API_KEY');

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

              PlaceAutocompleteField(
                label: 'من (Pickup)',
                hint: 'ابحث عن موقع الاستلام',
                icon: Icons.my_location,
                api: places,
                initialText: fromC.text,
                onPick: (v) => setState(() => fromC.text = v),
              ),

              const SizedBox(height: 10),

              PlaceAutocompleteField(
                label: 'إلى (Dropoff)',
                hint: 'ابحث عن موقع التسليم',
                icon: Icons.location_on_outlined,
                api: places,
                initialText: toC.text,
                onPick: (v) => setState(() => toC.text = v),
              ),

              const SizedBox(height: 12),

              AppButton(
                text: 'تأكيد',
                icon: Icons.check,
                onPressed: () {
                  final f = fromC.text.trim();
                  final t = toC.text.trim();
                  Navigator.pop(
                    context,
                    _FromToResult(
                      from: f.isEmpty ? null : f,
                      to: t.isEmpty ? null : t,
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
