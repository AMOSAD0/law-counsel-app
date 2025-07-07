import 'package:law_counsel_app/features/Client/auth/data/ModelClient.dart';

abstract class ProfileClientState {}


class ProfileClientInitial extends ProfileClientState {}

class ProfileClientLoading extends ProfileClientState {}


class ProfileClientLoaded extends ProfileClientState {
  final ClientModel client;
  ProfileClientLoaded(this.client);
}

class ProfileClientUpdated extends ProfileClientState {
  final ClientModel client;
  ProfileClientUpdated(this.client);
}


class ProfileClientSuccess extends ProfileClientState {
  final String message;
  ProfileClientSuccess(this.message);
}


class ProfileClientMessage extends ProfileClientState {
  final String message;
  ProfileClientMessage(this.message);
}
class ProfileClientImageUpdated extends ProfileClientState {
  final String message;

  ProfileClientImageUpdated(this.message);
}

class ProfileClientError extends ProfileClientState {
  final String message;
  ProfileClientError(this.message);
}
