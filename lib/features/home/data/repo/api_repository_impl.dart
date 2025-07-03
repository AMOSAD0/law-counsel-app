import 'package:weather_prediction_app/features/home/data/data_source/api_service.dart';
import 'package:weather_prediction_app/features/home/data/model/weather_model.dart';
import 'package:weather_prediction_app/features/home/domin/repositories/api_repositories.dart';

class ApiRepositoryImpl extends ApiRepositories{
  final ApiService apiService;
  ApiRepositoryImpl({required this.apiService});
  @override
  Future<ForecastModel> getWeather() async{
   final weatherData = await apiService.getWeather();
   if (weatherData == null) {
     throw Exception('Weather data is null');
   }
   return ForecastModel.fromJson(weatherData);
  }
}