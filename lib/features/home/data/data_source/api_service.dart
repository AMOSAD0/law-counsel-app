import 'package:dio/dio.dart';
import 'package:weather_prediction_app/features/home/data/data_source/api_constant.dart';

class ApiService {
  final Dio dio;

  ApiService({required this.dio});

  Future<Map<String,dynamic>?> getWeather()async{
    try{
      Response response =await dio.get(
        ApiConstant.apiBaseUrl,
      );

      if(response.statusCode == 200){
        return response.data;
      }else{
        print(response.statusMessage);
        return null;
      }
    }catch(e){
      print("Error : $e");
      return null;
    }

  }
}