import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/Conslution/Messages.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_bloc.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_state.dart';
import 'package:law_counsel_app/features/Client/auth/login_or_signupClient/ui/loginClient.dart';

class DrwerApp extends StatelessWidget {
  const DrwerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryColor,
      child: BlocBuilder<ProfileclientBloc, ProfileClientState>(
        builder: (context, state) {
          if (state is ProfileClientLoaded) {
            final client = state.client;

            return ListView(
              children: [
                DrawerHeader(child: Image.asset(AppAssets.logo2)),
                ListTile(
                  leading: Text(
                    "المحادثات",
                    style: AppTextStyles.font18WhiteNormal,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Messages(),
                        ),
                      );
                    },
                    icon: Image.asset(AppAssets.chatMassager, width: 30),
                  ),
                ),
                ListTile(
                  leading: Text(
                    "تسجيل الخروج",
                    style: AppTextStyles.font18WhiteNormal,
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loginclient()),
                      );
                    },
                    icon: Image.asset(AppAssets.logout, width: 30),
                  ),
                ),
                ListTile(
                  leading: Text(
                    "حذف حساب",
                    style: AppTextStyles.font18WhiteNormal,
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser?.delete();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loginclient()),
                      );
                    },
                    icon: Image.asset(AppAssets.trash, width: 30),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
