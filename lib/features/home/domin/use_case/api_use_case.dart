import 'package:weather_prediction_app/features/home/data/model/weather_model.dart';
import 'package:weather_prediction_app/features/home/domin/repositories/api_repositories.dart';

class ApiUseCase {
  final ApiRepositories repositories;

  ApiUseCase({required this.repositories});

  Future<ForecastModel>getWeather() => repositories.getWeather(); 
}