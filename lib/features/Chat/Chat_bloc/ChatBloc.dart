import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Chat/Chat_bloc/ChatEvent.dart';
import 'package:law_counsel_app/features/Chat/Chat_bloc/ChatState.dart';
import 'package:law_counsel_app/features/Chat/data/MessageModel.dart';
import 'package:law_counsel_app/features/Chat/r/repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatInitState()) {
    on<LoadChatEvent>((event, emit) async {
      emit(ChatLoadingState());

      await emit.forEach<List<MessageModel>>(
        chatRepository.getMessages(event.chatId),
        onData: (messages) => ChatOnLoadedState(messages),
        onError: (error, stackTrace) => ChatErrorState(error.toString()),
      );
    });

 
    on<SendMessageEvent>((event, emit) async {
      try {
        await chatRepository.sendMessage(event.chatId, event.model);
      
      } catch (e) {
        emit(ChatErrorState("فشل إرسال الرسالة"));
      }
    });
  }
}

