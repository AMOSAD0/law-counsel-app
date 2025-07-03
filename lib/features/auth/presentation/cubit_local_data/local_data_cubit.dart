
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';
import 'package:weather_prediction_app/features/auth/domin/use_case/auth_use_case.dart';
import 'package:weather_prediction_app/features/auth/presentation/cubit_local_data/local_data_states.dart';

class LocalDataCubit extends Cubit<LocalDataStates>{

  final AuthUseCase authUseCase;
  
  LocalDataCubit(this.authUseCase):super(LocalDataInitial());
  UserModel? user;

  Future<UserModel?> getCacheUser() async {
    try {
      emit(LocalDataLoading());
       user = await authUseCase.getUser();
      emit(LocalDataSuccess());
      return user;
    } catch (e) {
      emit(LocalDataFailure());
      print('Error retrieving cached user: $e');
      return null;
    }
  }


}