import 'package:cloud_firestore/cloud_firestore.dart';

class LawyerService {
  static Future<String?> getLawyerNameById(String lawyerId) async {
    final doc = await FirebaseFirestore.instance.collection('lawyers').doc(lawyerId).get();
    if (doc.exists) {
      return doc['name'];  
    }
    return null;
  }
    static Future<String?> getLawyerImageById(String lawyerId) async {
    final doc = await FirebaseFirestore.instance.collection('lawyers').doc(lawyerId).get();
    if (doc.exists) {
      return doc['profileImageUrl'];
    }
    return null;
  }
}
