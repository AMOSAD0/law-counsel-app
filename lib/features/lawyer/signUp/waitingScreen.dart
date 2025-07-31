import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';

class WaitingScreen extends StatelessWidget {
  final String userId;

  const WaitingScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lawyers')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Column(
              children: [
                const Center(child: Text("حدث خطأ في تحميل البيانات.")),
              ],
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("لا يوجد بيانات لهذا المستخدم."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final isApproved = data['isApproved'];
          final messageToLawyer = data['messageToLawyer'] as String?;

          if (isApproved == true) {
            Future.microtask(() {
              Navigator.pushReplacementNamed(context, Routes.login);
            });
            return Column(
              children: [
                Image.asset(AppAssets.logo),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "تمت الموافقة، جاري التوجيه...",
                    style: AppTextStyles.font28primaryColorBold,
                  ),
                ),
              ],
            );
          } else if (isApproved == false &&
              (messageToLawyer != null && messageToLawyer.isNotEmpty)) {
            return Column(
              children: [
                Image.asset(AppAssets.logo2),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            "تم رفض طلبك من قبل الإدارة.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.font28primaryColorBold,
                          ),
                          SizedBox(height: 10),
                          Text(
                            messageToLawyer,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.font16WhiteNormal,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          backgroundColor: AppColors.btnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: AppTextStyles.font16WhiteNormal,

                        ),

                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.registerLawyer);
                        },
                        child: const Text("العودة إلى تسجيل الدخول"),
                      ),

                    ],
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Image.asset(AppAssets.logo2),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "تم تسجيلك بنجاح\nيرجى انتظار موافقة الإدارة.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font28primaryColorBold,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
