import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/chatbot/bloc/chatbotEvent.dart';
import 'package:law_counsel_app/features/chatbot/bloc/chatbotState.dart';
import 'package:law_counsel_app/features/chatbot/model/messageModel.dart';
import '../data/gemini_service.dart';


class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  ChatbotBloc() : super(ChatbotInitial()) {
    on<SendMessageChatbotEvent>(_onSendMessageChatbot);
  }

  Future<void> _onSendMessageChatbot(SendMessageChatbotEvent event, Emitter<ChatbotState> emit) async {
    final currentMessages = List<MessageChatbot>.from(state.messages)
      ..add(MessageChatbot(text: event.userMessage, isUser: true));

    emit(ChatbotLoading(currentMessages));

    try {
      final botReply = await GeminiService.sendMessage(event.userMessage);
      final updatedMessages = List<MessageChatbot>.from(currentMessages)
        ..add(MessageChatbot(text: botReply, isUser: false));

      emit(ChatbotLoaded(updatedMessages));
    } catch (e) {
      emit(ChatbotError(currentMessages, e.toString()));
    }
  }
}
