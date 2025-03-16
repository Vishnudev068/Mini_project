import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/global.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// Global user location variables

class MapScreen extends StatefulWidget {
  final LatLng location;
  const MapScreen({super.key, required this.location});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  late LatLng userLocation;
  late LatLng destination;
  List<LatLng> routeCoords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    double userLat = globalLatitude ?? 9.022656;
    double userLong = globalLongitude ?? 76.750553;

    userLocation = LatLng(userLat, userLong);
    destination = widget.location;

    fetchRoute();
  }

  Future<void> fetchRoute() async {
    final url = Uri.encodeFull(
      'https://router.project-osrm.org/route/v1/driving/'
      '${userLocation.longitude},${userLocation.latitude};'
      '${destination.longitude},${destination.latitude}?'
      'overview=full&geometries=polyline',
    );

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final String encodedPolyline = data['routes'][0]['geometry'];

          setState(() {
            routeCoords = decodePolyline(encodedPolyline);
            isLoading = false;
          });
        } else {
          print('No route found in API response');
        }
      } else {
        print('Failed to load route. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    if (encoded.isEmpty) return [];
    List<PointLatLng> result = PolylinePoints().decodePolyline(encoded);
    return result.map((p) => LatLng(p.latitude, p.longitude)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("OSM Route")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading spinner
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: userLocation,
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userLocation,
                      width: 50,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer Glow Effect
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue
                                  .withOpacity(0.3), // Soft glow effect
                            ),
                          ),

                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Marker(
                      point: destination,
                      width: 30,
                      height: 30,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                              width: 25,
                              height: 25,
                              color: Colors.red,
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (routeCoords.isNotEmpty) // Render route if available
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routeCoords,
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
