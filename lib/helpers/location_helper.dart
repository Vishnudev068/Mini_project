import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc; // Alias for location package
import 'package:permission_handler/permission_handler.dart'
    as perm; // Alias for permission_handler package

class LocationHelper {
  static Future<void> checkLocationPermission(
      BuildContext context, VoidCallback onPermissionGranted) async {
    loc.Location location = loc.Location();

    // Check if location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _showLocationDialog(context);
        return;
      }
    }

    // Check permission status using permission_handler
    perm.PermissionStatus permissionStatus =
        await perm.Permission.location.status;
    if (permissionStatus.isDenied || permissionStatus.isRestricted) {
      perm.PermissionStatus requestStatus =
          await perm.Permission.location.request();
      if (requestStatus.isDenied) {
        _showLocationDialog(context);
        return;
      }
    }

    // If permission is granted, execute callback
    onPermissionGranted();
  }

  // Show dialog if location permission is denied
  static void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enable Location"),
          content: Text(
              "This app requires location access to function properly. Please enable it in settings."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await perm
                    .openAppSettings(); // Open settings using permission_handler
              },
              child: Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
