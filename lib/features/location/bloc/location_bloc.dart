
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_prediction_app/features/location/domain/entities/location_entity.dart';
import 'package:weather_prediction_app/features/location/domain/usecases/get_location_usecase.dart';

class LocationBloc extends Cubit<LocationEntity?>{
  final GetLocationUsecase getLocationUsecase;
  String country="";
  LocationBloc(this.getLocationUsecase):super(null);
  

  Future<String> fetchLocation() async{
    try {
      final location = await getLocationUsecase();
      emit(location);
      print(location.country);
      country= location.country;
      return  location.country;
    } catch(error){
      emit(null);
      print( "Failed to fetch location: $error");
      return "";
    }
  }
}