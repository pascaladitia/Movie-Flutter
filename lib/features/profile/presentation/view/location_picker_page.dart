import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerPage extends StatefulWidget {
  final LatLng initialLocation;

  const LocationPickerPage({super.key, required this.initialLocation});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late LatLng _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: const Text('Use'),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: widget.initialLocation, zoom: 13),
        onTap: (latLng) => setState(() => _selected = latLng),
        markers: {
          Marker(markerId: const MarkerId('selected'), position: _selected),
        },
      ),
    );
  }
}
