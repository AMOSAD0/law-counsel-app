import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_prediction_app/features/home/data/model/weather_model.dart';
import 'package:weather_prediction_app/features/home/domin/use_case/ai_use_case.dart';
import 'package:weather_prediction_app/features/home/presentation/cubit/ai_model_states.dart';

class AiModelCubit extends Cubit<AiModelStates> {
  final AiUseCase aiUseCase;

  AiModelCubit(this.aiUseCase) : super(AiModelinitial());
  int ?prediction;
  Future<int?> getPrediction(WeatherModel? features) async {
    try {
      emit(AiModeloading());
      if (features != null) {
       prediction= await aiUseCase.getPrediction(fromList(features));
        emit(AiModelSuccess());
        return prediction;
      } else {
        emit(AiModelFaliuer());
        print("Error: features is null");
        return null;
      }

    } catch (e) {
      emit(AiModelFaliuer());
      print("Error: $e");
      return null;
    }
  }

  List<int> fromList(WeatherModel data) {
    List<int> list = List.filled(5, 0);
    if (data.daily_will_it_rain! > 50) {
      list[0] = 1;
      list[1] = 0;
    } else {
      list[0] = 0;
      list[1] = 1;
    }

    if (data.avgTempC! > 32) {
      list[2] = 1;
    } else {
      list[2] = 0;
    }
    
    if (data.avgTempC! < 38) {
      list[3] = 1;
    } else {
      list[3] = 0;
    }

    if (data.avgHumidity! < 60) {
      list[4] = 1;
    } else {
      list[4] = 0;
    }
    // Replace print with proper logging
    // print(list);
    return list;
  }
}
