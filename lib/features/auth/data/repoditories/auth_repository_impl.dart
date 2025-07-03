import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_prediction_app/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:weather_prediction_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';
import 'package:weather_prediction_app/features/auth/domin/repositories/auth_repositories.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl(
      {required this.authRemoteDataSource, required this.authLocalDataSource});
  @override
  Future<User?> signUp(String fullName, String email, String password) async {
    final user = await authRemoteDataSource.signUp(fullName, email, password);
    await authLocalDataSource.cacheUser(UserModel.fromEntity(user!));
    return user;
  }

  @override
  Future<User?> login(String email, String password) async {
    final user = await authRemoteDataSource.login(email, password);
    await authLocalDataSource.cacheUser(UserModel.fromEntity(user!));
    return user;
  }

  @override
  Future<User?> getCurrentUserFromFirebase() async {
    return await authRemoteDataSource.getCurrentUserFromFirebase();
  }

  @override
  Future<UserModel?> getUser() async {
    {
      return await authLocalDataSource.getCacheUser();
    }
  }
}
