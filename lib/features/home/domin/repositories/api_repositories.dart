import 'package:weather_prediction_app/features/home/data/model/weather_model.dart';

abstract class ApiRepositories {
  Future<ForecastModel>getWeather();
}