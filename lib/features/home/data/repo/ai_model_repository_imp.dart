import 'package:weather_prediction_app/features/home/data/data_source/ai_model_service.dart';
import 'package:weather_prediction_app/features/home/domin/repositories/ai_model_repositories.dart';

class AiModelRepositoryImp extends AiModelRepositories{
  final AiModelService aiModelRepositoriesl;
  AiModelRepositoryImp({required this.aiModelRepositoriesl});

  @override
  Future<int?> getPrediction(List<int> features)async {
   return await aiModelRepositoriesl.getPrediction(features);
   
  }
  }