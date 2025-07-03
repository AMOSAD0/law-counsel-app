import 'package:hive_flutter/hive_flutter.dart';

abstract class LocationLocalData {
  Future<void>cacheLocation(String location);
  Future<String?>getCacheLocation();
}

class LocationLocalDataImpl implements LocationLocalData{
  final Box _locationBox;
  LocationLocalDataImpl(this._locationBox);

  @override
  Future<void> cacheLocation(String location)async {
    await _locationBox.put('location', location);
  }

  @override
  Future<String?> getCacheLocation() async {
    return await _locationBox.get('location');
  }


}