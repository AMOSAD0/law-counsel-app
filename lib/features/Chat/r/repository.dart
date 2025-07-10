import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/features/Chat/data/MessageModel.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> sendMessage(String chatId, MessageModel modelMessage) {
    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add(modelMessage.toMap());
  }
}
