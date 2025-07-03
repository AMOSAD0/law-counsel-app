
import 'package:weather_prediction_app/features/location/domain/entities/location_entity.dart';
import 'package:weather_prediction_app/features/location/domain/repositories/location_repository.dart';

class GetLocationUsecase {
  final LocationRepository repository;
  GetLocationUsecase(this.repository);

  Future<LocationEntity> call() async{
    return await repository.getCurrentLocation();
  }
}