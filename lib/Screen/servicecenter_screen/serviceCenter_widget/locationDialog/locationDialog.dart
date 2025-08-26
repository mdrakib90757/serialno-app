import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/color.dart';

class LocationPickerDialog extends StatefulWidget {
  const LocationPickerDialog({super.key});

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  final Completer<GoogleMapController> _controller = Completer();

  // Initial camera position (Dhaka)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 12,
  );

  final Set<Marker> _markers = {};
  LatLng? _selectedLocation;
  final Set<Polyline> _polylines = {};

  void _addMarkerOnTap(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(markerId: const MarkerId("selected"), position: position),
      );
      _selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor().primariColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 400,
                child: GoogleMap(
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  polylines: _polylines,
                  onMapCreated: (c) => _controller.complete(c),
                  onTap: _addMarkerOnTap,
                ),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(5),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: AppColor().primariColor),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor().primariColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(5),
                      ),
                    ),

                    child: Text(
                      "Select",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_selectedLocation != null) {
                        Navigator.pop(context, _selectedLocation);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
