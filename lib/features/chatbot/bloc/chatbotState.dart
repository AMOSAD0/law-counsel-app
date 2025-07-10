import 'package:equatable/equatable.dart';
import 'package:law_counsel_app/features/chatbot/model/messageModel.dart';


abstract class ChatbotState extends Equatable {
  final List<MessageChatbot> messages;

  const ChatbotState(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatbotInitial extends ChatbotState {
  ChatbotInitial() : super([]);
}

class ChatbotLoading extends ChatbotState {
  ChatbotLoading(List<MessageChatbot> messages) : super(messages);
}

class ChatbotLoaded extends ChatbotState {
  ChatbotLoaded(List<MessageChatbot> messages) : super(messages);
}

class ChatbotError extends ChatbotState {
  final String error;

  ChatbotError(List<MessageChatbot> messages, this.error) : super(messages);

  @override
  List<Object> get props => [messages, error];
}
