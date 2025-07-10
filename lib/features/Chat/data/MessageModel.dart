import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? id;
  final String text;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String receiverEmail;
  final Timestamp timestamp;

  MessageModel({
    this.id,
    required this.text,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.receiverEmail,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'receiverEmail': receiverEmail,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      receiverId: map['receiverId'] ?? '',   
      receiverEmail: map['receiverEmail'] ?? '',   
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}
