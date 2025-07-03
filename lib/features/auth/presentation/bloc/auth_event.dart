import 'dart:async';

import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';

abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  SignUpEvent({required this.fullName,required this.email, required this.password});
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class CheckCurrentUserEvent extends AuthEvent {
  final Completer<UserModel> completer;

  CheckCurrentUserEvent({required this.completer});
}