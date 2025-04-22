import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TravelRouteMapWidget extends StatelessWidget {
  final List<LatLng> routePoints;
  final List<LatLng> waypointLocations;

  const TravelRouteMapWidget({
    super.key,
    required this.routePoints,
    required this.waypointLocations,
  });

  @override
  Widget build(BuildContext context) {
    LatLng defaultCenter = LatLng(39.1458, 34.1603);

    return SizedBox(
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          center: defaultCenter,
          zoom: 5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
          MarkerLayer(
            markers: waypointLocations.map((location) {
              return Marker(
                point: location,
                width: 40,
                height: 40,
                builder: (context) => const Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.red,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
