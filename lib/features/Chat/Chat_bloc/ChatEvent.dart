import 'package:law_counsel_app/features/Chat/data/MessageModel.dart';

class ChatEvent {}

class LoadChatEvent extends ChatEvent {
  final String chatId;
  LoadChatEvent(this.chatId);
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final MessageModel model;
  SendMessageEvent(this.chatId, this.model);
}
