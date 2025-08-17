import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusChatRenderer extends StatelessWidget {
  final String userType; // "client" أو "lawyer"
  final String status;   // ongoing, pending, completed, disputed
  // final String input;
    final TextEditingController messageController ;
    final String chatId;
  
  final Function() sendMessage;
  final List<Map<String, dynamic>> chats;
  final int index;
  final String lawyerId;
  final String clientId;

  const StatusChatRenderer({
    super.key,
    required this.userType,
    required this.status,
    required this.messageController,
    required this.chatId,
    // required this.input,
    // required this.setInput,
    required this.sendMessage,
    required this.chats,
    required this.index,
    required this.lawyerId,
    required this.clientId,
  });

  Future<void> handleAcceptEndRequest(BuildContext context) async {
    final chatDocRef =
        FirebaseFirestore.instance.collection("chats").doc(chatId);

    await chatDocRef.update({"status": "completed"});

    // Payments release
    final paymentsRef = FirebaseFirestore.instance.collection("payments");
    final querySnapshot = await paymentsRef
        .where("lawyerId", isEqualTo: chats[index]["lawyerId"])
        .where("clientId", isEqualTo: chats[index]["clientId"])
        .where("status", isEqualTo: "escrow")
        .get();

    double amount = 0;
    for (final paymentDoc in querySnapshot.docs) {
      final paymentDocRef = paymentsRef.doc(paymentDoc.id);
      amount = paymentDoc["amount"] * 1.0;
      await paymentDocRef.update({"status": "released"});
    }

    // Update lawyer balance
    final lawyerDocRef =
        FirebaseFirestore.instance.collection("lawyers").doc(chats[index]["lawyerId"]);
    await lawyerDocRef.update({
      "balance": FieldValue.increment(amount - amount * 0.1),
    });

    // Update platform balance
    final platformDocRef =
        FirebaseFirestore.instance.collection("platform").doc("balance");
    await platformDocRef.update({
      "balance": FieldValue.increment(amount * 0.1),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تمت الموافقة على إنهاء الاستشارة")),
    );
  }

  Future<void> handleRejectEndRequest(BuildContext context) async {
    final chatDocRef =
        FirebaseFirestore.instance.collection("chats").doc(chatId);

    await chatDocRef.update({"status": "disputed"});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم رفض إنهاء الاستشارة")),
    );
  }

  @override
@override
Widget build(BuildContext context) {
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const SizedBox.shrink();
      }

      final chatData = snapshot.data!.data() as Map<String, dynamic>;
      final status = chatData["status"] ?? "ongoing";
      final endRequestBy = chatData["endRequestBy"];

      switch (status) {
        case "ongoing":
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("تأكيد"),
                        content: const Text("هل تريد إنهاء الاستشارة؟"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("إلغاء"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await FirebaseFirestore.instance
                                  .collection("chats")
                                  .doc(chatId)
                                  .update({
                                "status": "pending",
                                "endRequestBy": userType,
                              });
                            },
                            child: const Text("تأكيد"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: const Text("إنهاء الاستشارة"),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "اكتب رسالتك هنا",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      sendMessage();
                      messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          );

        case "pending":
          if (endRequestBy != userType) {
            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[50],
                border: Border.all(color: Colors.yellow[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("الطرف الآخر طلب إنهاء الاستشارة",
                      style: TextStyle(color: Colors.orange)),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => handleAcceptEndRequest(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        child: const Text("موافق"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => handleRejectEndRequest(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                        child: const Text("غير موافق"),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[50],
                border: Border.all(color: Colors.yellow[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text("تم إرسال طلب إنهاء الاستشارة",
                    style: TextStyle(color: Colors.orange)),
              ),
            );
          }

        case "completed":
          return Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border.all(color: Colors.green[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text("تم الانتهاء من الاستشارة",
                  style:
                      TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          );

        case "disputed":
          return Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border.all(color: Colors.blue[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text("الإدارة ستقوم بمراجعة القضية",
                  style: TextStyle(color: Colors.blue)),
            ),
          );

        default:
          return const SizedBox.shrink();
      }
    },
  );
}
}
