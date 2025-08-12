import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserRole(String uid) async {
  final docClient = await FirebaseFirestore.instance.collection('clients').doc(uid).get();
  if (docClient.exists) return 'client';

  final docLawyer = await FirebaseFirestore.instance.collection('lawyers').doc(uid).get();
  if (docLawyer.exists) return 'lawyer';

  return null; // مش موجود
}
