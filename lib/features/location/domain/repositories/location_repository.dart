import 'package:weather_prediction_app/features/location/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future <LocationEntity> getCurrentLocation();
}