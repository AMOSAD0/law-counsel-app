import 'package:law_counsel_app/features/Chat/data/MessageModel.dart';

class ChatState {}

class ChatInitState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatOnLoadedState extends ChatState {
  List<MessageModel> messages;
  ChatOnLoadedState(this.messages);
}

class ChatErrorState extends ChatState {
  final String ErrorMassage;
  ChatErrorState(this.ErrorMassage);
}
