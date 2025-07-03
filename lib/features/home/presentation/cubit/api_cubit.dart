import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_prediction_app/features/home/data/model/weather_model.dart';
import 'package:weather_prediction_app/features/home/domin/use_case/api_use_case.dart';
import 'package:weather_prediction_app/features/home/presentation/cubit/api_states.dart';

class ApiCubit extends Cubit<ApiStates> {
  final ApiUseCase apiUseCase;
  ApiCubit(this.apiUseCase) : super(ApiInitial());

   ForecastModel? forecastModel;

  Future<ForecastModel?> getWeather() async {
    try{
    emit(ApiLoading());
    forecastModel= await apiUseCase.getWeather();
    emit(ApiSuccess());
    return forecastModel;
    }catch(e){
      emit(ApiFailure());
       print('Error getting data: $e');
      return null;
    }
  }
}
