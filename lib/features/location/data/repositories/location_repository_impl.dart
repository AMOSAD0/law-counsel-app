import 'package:weather_prediction_app/features/location/data/location_datasource.dart';
import 'package:weather_prediction_app/features/location/data/location_local_data.dart';
import 'package:weather_prediction_app/features/location/domain/entities/location_entity.dart';
import 'package:weather_prediction_app/features/location/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDatasource dataSource;
  final LocationLocalData localData;

  LocationRepositoryImpl({required this.dataSource, required this.localData});

  @override
  Future<LocationEntity> getCurrentLocation() async {
    try{
      final location =await localData.getCacheLocation(); 
    if (location==null) {
      final country = await dataSource.getCountryFromLocation();
      await localData.cacheLocation(country);
      return  LocationEntity(country: country);
    } else {    
      return LocationEntity(country:location);
      }

    }
    catch(e){
      
      throw Exception("Failed to get location: $e");
    }
  }
}
