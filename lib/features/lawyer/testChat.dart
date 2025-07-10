import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/features/Chat/UI/Chat.dart';

class TestChatForLawyer extends StatelessWidget {
  const TestChatForLawyer({super.key});
  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    //
    // if (user == null) {
    //   return Center(child: Text("لم يتم تسجيل الدخول"));
    // }

    return ChatScreen(
      currentUserId:"1LgdtODjbta0gnUVWaGNwFqmMTm2",
      currentUserEmail: "j@j.com",
      receiverId:"0hPemfz1O8Xd3RoEIyJ5GqO4BoH3",
      receiverEmail: "ahmed@gmail.com",


      // currentUserId: user.uid,
      // currentUserEmail: user.email!,
      // receiverId: "client456",
      // receiverEmail: "0hPemfz1O8Xd3RoEIyJ5GqO4BoH3",
    );
  }

}
