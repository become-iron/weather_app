import 'package:geolocator/geolocator.dart'
    show
        Geolocator,
        LocationAccuracy,
        LocationPermission,
        LocationSettings,
        Position;

enum LocationExceptionType {
  serviceDisabled,
  permissionDenied,
  permissionPermanentlyDenied;
}

class LocationException implements Exception {
  final LocationExceptionType type;
  const LocationException(this.type);

  String get message {
    return switch (type) {
      LocationExceptionType.serviceDisabled =>
        'Location services are disabled.',
      LocationExceptionType.permissionDenied =>
        'Location permissions are denied.',
      LocationExceptionType.permissionPermanentlyDenied =>
        'Location permissions are permanently denied. '
            'We cannot re-request them.',
    };
  }

  @override
  String toString() {
    return message;
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    throw const LocationException(LocationExceptionType.serviceDisabled);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      throw const LocationException(LocationExceptionType.permissionDenied);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    throw const LocationException(
      LocationExceptionType.permissionPermanentlyDenied,
    );
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      // Low accuracy location is sufficient for the needs of the application.
      // Also, its acquisition should be faster.
      accuracy: LocationAccuracy.low,
    ),
  );
}
