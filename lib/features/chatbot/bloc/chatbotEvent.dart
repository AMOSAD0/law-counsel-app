import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessageChatbotEvent extends ChatbotEvent {
  final String userMessage;

  SendMessageChatbotEvent(this.userMessage);

  @override
  List<Object> get props => [userMessage];
}
