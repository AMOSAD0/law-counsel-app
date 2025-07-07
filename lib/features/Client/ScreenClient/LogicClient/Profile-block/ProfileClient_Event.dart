import 'package:law_counsel_app/features/Client/auth/data/ModelClient.dart';

abstract class ProfileClientEvent {}

class ProfileClientLoadEvent extends ProfileClientEvent {}

class ProfileClientUpdateEvent extends ProfileClientEvent {
  final ClientModel clientModel;
  ProfileClientUpdateEvent({required this.clientModel});
}

class ProfileClientImageUpdateEvent extends ProfileClientEvent {
  final String imageUrl;
  ProfileClientImageUpdateEvent({required this.imageUrl});
}

class ProfileClientDeleteEvent extends ProfileClientEvent {}

class ProfileClientLogoutEvent extends ProfileClientEvent {}
class ProfileClientSuccessEvent extends ProfileClientEvent {
  final String message;
  ProfileClientSuccessEvent({required this.message});
}
class ProfileClientErrorEvent extends ProfileClientEvent {
  final String message;
  ProfileClientErrorEvent({required this.message});
}