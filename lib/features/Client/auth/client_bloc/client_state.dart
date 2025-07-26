import 'package:law_counsel_app/features/Client/auth/data/ModelClient.dart';

abstract class ClientState {}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final ClientModel client;

  ClientLoaded({required this.client});
}

class IsClient extends ClientState {}

class IsLawyer extends ClientState {}

class ClientError extends ClientState {
  final String message;

  ClientError({required this.message});
}
