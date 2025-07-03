class ForecastModel {
  final List<WeatherModel>? forecastday;

  ForecastModel({this.forecastday});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      forecastday: (json["forecast"]?["forecastday"] as List? ?? [])
          .map((item) => WeatherModel.fromJson(item))
          .toList(),
    );
  }

}

class WeatherModel {
  final String? date;
  final double? avgTempC;
  final int? avgHumidity;
  final int? daily_will_it_rain;
  final String? condition;
  final double? uv;

  WeatherModel(
      {this.date,
      this.avgTempC,
      this.avgHumidity,
      this.daily_will_it_rain,
      this.condition,
      this.uv});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      date: json["date"],
      avgTempC: json["day"]["avgtemp_c"],
      avgHumidity: json["day"]["avghumidity"],
      daily_will_it_rain: json["day"]["daily_will_it_rain"],
      condition: json["day"]["condition"]["text"],
      uv: json["day"]["uv"],
    );
  }
}
