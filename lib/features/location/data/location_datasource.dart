import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationDatasource {
  Future<String> getCountryFromLocation();
}

class LocationDatasourceImpl implements LocationDatasource {
  @override
  Future<String> getCountryFromLocation() async {
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      );
    
     if (placemarks.isNotEmpty) {
      return placemarks.first.country ?? "Unknown";
    } else {
      throw Exception("Could not retrieve country.");
    }
  }
}
