// import 'package:cloud_firestore/cloud_firestore.dart';

// class ConsultationModel {
//   final String ?id;
//   final String title;
//   final String description;
//   final String userId;
//   final String ?userName;
//   final String lawyerId;
//   final String status;
//   final bool deletedByClient;
//   final String? responseMessage;
//   final DateTime createdAt;


//   ConsultationModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.userId,
//     required this.lawyerId,
//     required this.status,
//     required this.deletedByClient,
//     required this.createdAt,
//     this.userName,
//     this.responseMessage,
//   });

//   factory ConsultationModel.fromJson(Map<String, dynamic> json,String id) {
//     return ConsultationModel(
//       id: id,
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       userId: json['userId'] ?? '',
//       userName: json['userName']?? '',
//       lawyerId: json['lawyerId'] ?? '',
//       status: json['status'] ?? '',
//       deletedByClient: json['deletedByClient'] ?? false,
//       responseMessage: json['responseMessage'],
//       createdAt: (json['createdAt'] as Timestamp).toDate(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'userId': userId,
//       'userName': userName,
//       'lawyerId': lawyerId,
//       'status': status,
//       'deletedByClient': deletedByClient,
//       'responseMessage': responseMessage,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }
// }
