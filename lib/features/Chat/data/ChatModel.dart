import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/features/Chat/data/MessageModel.dart';

class ChatModel {
  final String chatId;
  final String clientId;
  final String clientEmail;
  final String lawyerId;
  final String lawyerEmail;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final bool isActive;

  ChatModel({
    required this.chatId,
    required this.clientId,
    required this.clientEmail,
    required this.lawyerId,
    required this.lawyerEmail,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientEmail': clientEmail,
      'lawyerId': lawyerId,
      'lawyerEmail': lawyerEmail,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isActive': isActive,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatModel(
      chatId: docId,
      clientId: map['clientId'] ?? '',
      clientEmail: map['clientEmail'] ?? '',
      lawyerId: map['lawyerId'] ?? '',
      lawyerEmail: map['lawyerEmail'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] ?? Timestamp.now(),
      isActive: map['isActive'] ?? true,
    );
  }
  
}
