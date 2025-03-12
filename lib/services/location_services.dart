import 'package:flutter_application_4/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Map<String, dynamic>> getLatLong() async {
    try {
      Position position = await _determinePosition();

      
      globalLatitude = position.latitude;
      globalLongitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        globalLatitude!,
        globalLongitude!,
      );

      Placemark place = placemarks.first;

      return {
        "latitude": globalLatitude,
        "longitude": globalLongitude,
        "locality":
            place.locality ?? place.subLocality ?? place.street ?? "Unknown",
        "address":
            "${place.locality}, ${place.administrativeArea}, ${place.country}",
      };
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Please enable them in settings.');
    }

    return await Geolocator.getCurrentPosition();
  }

  
}
