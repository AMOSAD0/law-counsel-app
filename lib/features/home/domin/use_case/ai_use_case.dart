import 'package:weather_prediction_app/features/home/domin/repositories/ai_model_repositories.dart';

class AiUseCase {
  final AiModelRepositories repositories;

  AiUseCase({required this.repositories});

  Future<int?> getPrediction (List<int>features)=> repositories.getPrediction(features);
}