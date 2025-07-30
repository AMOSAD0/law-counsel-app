import 'package:cloud_firestore/cloud_firestore.dart';

class LawyerService {
  static Future<String?> getLawyerNameById(String lawyerId) async {
    if (lawyerId.isEmpty) return null; 
    print(" Getting lawyer name for ID: $lawyerId"); 

    final doc = await FirebaseFirestore.instance
        .collection('lawyers')
        .doc(lawyerId)
        .get();

    if (doc.exists) {
      return doc['name'];
    }
    return null;
  }

  static Future<String?> getLawyerImageById(String lawyerId) async {
    if (lawyerId.isEmpty) return null; // ✅ حماية من قيمة فاضية
    print("🖼️ Getting lawyer image for ID: $lawyerId"); // Debug

    final doc = await FirebaseFirestore.instance
        .collection('lawyers')
        .doc(lawyerId)
        .get();

    if (doc.exists) {
      return doc['profileImageUrl'];
    }
    return null;
  }
}
