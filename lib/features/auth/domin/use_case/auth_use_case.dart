import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';
import 'package:weather_prediction_app/features/auth/domin/repositories/auth_repositories.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

   Future<User?> signUp(String fullName,String email, String password) => repository.signUp(fullName,email, password);

   Future<User?> login(String email, String password) => repository.login(email, password);

   Future<User?> getCurrentUserFromFirebase() => repository.getCurrentUserFromFirebase();
   
   Future<UserModel?> getUser() => repository.getUser();
}