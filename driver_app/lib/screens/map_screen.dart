import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreenDriver extends StatefulWidget {
  const MapScreenDriver({super.key});

  @override
  State<MapScreenDriver> createState() => _MapScreenDriverState();
}

class _MapScreenDriverState extends State<MapScreenDriver> {
  GoogleMapController? mapController;
  LatLng _center = const LatLng(24.7136, 46.6753); // الرياض

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _trackLocation();
  }

  void _trackLocation() async {
    Location location = Location();
    location.onLocationChanged.listen((loc) {
      setState(() {
        _center = LatLng(loc.latitude!, loc.longitude!);
      });
      mapController?.animateCamera(CameraUpdate.newLatLng(_center));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الطلب')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
