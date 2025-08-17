import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/roleUser.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/Conslution/Messages.dart';
import 'package:law_counsel_app/features/Client/auth/login_or_signupClient/ui/loginClient.dart';
import 'package:law_counsel_app/features/lawyer/MyConsultationsLawyer/Messages.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DrwerApp extends StatelessWidget {
  const DrwerApp({super.key});

  Future<String?> _getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future _deleteUid( ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('userType');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUid(),
      builder: (context, uidSnapshot) {
        if (!uidSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final uid = uidSnapshot.data!;
        return FutureBuilder<String?>(
          future: getUserRole(uid),
          builder: (context, roleSnapshot) {
            if (!roleSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final role = roleSnapshot.data;
            
            if (role == 'client') {
             
              return _drawerContent(
                context,
                messagesPage: const Messages(),
                loginPage: const Loginclient(),
              );
            } else if (role == 'lawyer') {
              return _drawerContent(
                context,
                messagesPage: const MessagesLawyer(),
                loginPage: const Loginclient(),
              );
            } else {
              return const Center(child: Text('خطأ في تحديد الدور'));
            }
          },
        );
      },
    );
  }Widget _drawerContent(
  BuildContext context, {
  required Widget messagesPage,
  required Widget loginPage,
}) {
  return Drawer(
    backgroundColor: AppColors.primaryColor, 
    child: ListView(
      children: [
        DrawerHeader(child: Image.asset(AppAssets.logo2)),
        ListTile(
          leading: Text("المحادثات", style: AppTextStyles.font18WhiteNormal),
          trailing: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => messagesPage),
              );
            },
            icon: Image.asset(AppAssets.chatMassager, width: 30),
          ),
        ),
        ListTile(
          leading: Text("تسجيل الخروج", style: AppTextStyles.font18WhiteNormal),
          trailing: IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await _deleteUid();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => loginPage),
                (route) => false,
              );
            },
            icon: Image.asset(AppAssets.logout, width: 30),
          ),
        ),
        ListTile(
          leading: Text("حذف حساب", style: AppTextStyles.font18WhiteNormal),
          trailing: IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.currentUser?.delete();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => loginPage),
                (route) => false,
              );
            },
            icon: Image.asset(AppAssets.trash, width: 30),
          ),
        ),
      ],
    ),
  );
}
}