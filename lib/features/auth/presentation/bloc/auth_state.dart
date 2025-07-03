import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess({required this.user});
}
class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}

class AuthCheckCurrentUserSave extends AuthState {
  final UserModel user;
  AuthCheckCurrentUserSave({required this.user});
}