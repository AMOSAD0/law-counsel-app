import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';


abstract class AuthRepository {
  Future<User?> signUp(String fullName,String email, String password);
  Future<User?> login(String email, String password);
  Future<User?> getCurrentUserFromFirebase();
  Future<UserModel?> getUser();

}