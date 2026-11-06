import 'package:geolocator/geolocator.dart';

import 'model.dart';

abstract class LocationService {
  /// The phone's position, or null if permission is refused or no fix arrives. GPS needs no
  /// internet, so this works in the field.
  Future<GeoFix?> current();
}

class DeviceLocation implements LocationService {
  @override
  Future<GeoFix?> current() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return GeoFix(position.latitude, position.longitude, accuracyM: position.accuracy);
    } catch (_) {
      return null;
    }
  }
}
