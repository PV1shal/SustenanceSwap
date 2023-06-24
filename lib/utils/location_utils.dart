import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// This function returns future<position> of current location
Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled for this app
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled so send error
    return Future.error('Location services are disabled.');
  }
  // Request permission to access the location
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    // Location permissions are permanently denied, we cannot request permissions for this app so send error
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    // Request permission to access the location again
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      // Location permissions are denied so show error
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  // Get the current position and return
  return await Geolocator.getCurrentPosition();
}

/// Get address by given latitude and longitude
Future<String> getAddress(double latitude, double longitude) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  Placemark place = placemarks[0];
  String address =
      '${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  return address;
}

/// this function is used to get Future<Location> instance from any given address in string
Future<Location> getLocationFromAddress(String address) async {
  if (address.isEmpty) {
    throw ArgumentError("Address cannot be empty");
  }
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return locations[0];
    } else {
      throw Exception("No such location found");
    }
  } catch (e) {
    throw Exception("Error fetching location: $e");
  }
}
