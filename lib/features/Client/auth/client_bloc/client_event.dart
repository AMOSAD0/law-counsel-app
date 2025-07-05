class ClientEvent {}

class ClientRegisterEvent extends ClientEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  ClientRegisterEvent(this.name, this.phone, {required this.email, required this.password});
}

class ClientLoginEvent extends ClientEvent {
  final String email;
  final String password;

  ClientLoginEvent({required this.email, required this.password});
}

class ClientLogoutEvent extends ClientEvent {}
