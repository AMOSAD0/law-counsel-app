import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/features/Client/auth/login_or_signupClient/ui/RegisterClient.dart';
import 'package:law_counsel_app/features/lawyer/signUp/signUp.dart';
import 'package:law_counsel_app/features/lawyer/signUp/signUp2.dart';

class SelectableUser extends StatefulWidget {
  const SelectableUser({super.key});

  @override
  State<SelectableUser> createState() => _SelectableUserState();
}

class _SelectableUserState extends State<SelectableUser> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildSelectableCard(
              index: 0,
              image: AppAssets.Client,
              text: "عميل",
            ),
            horizontalSpace(20),
            buildSelectableCard(
              index: 1,
              image: AppAssets.Lawyer,
              text: "محامي",
            ),
          ],
        ),
        verticalSpace(60),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: OnboradingButton(
            text: "التالي",
            onPressed: () {
              if (selectedIndex != -1) {
                if (selectedIndex == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterClient()),
                  );
                } else if (selectedIndex == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignupForLawyer()),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("الرجاء اختيار نوع المستخدم")),
                );
              }
            },
            color: AppColors.primaryColor,
            textColor: Colors.white,
            width: double.infinity,
            height: 50,
          ).buildButtonBoarding(),
        ),
      ],
    );
  }

  Widget buildSelectableCard({
    required int index,
    required String image,
    required String text,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = selectedIndex == index ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        width: isSelected ? 170 : 150,
        height: isSelected ? 180 : 160,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 80),
            verticalSpace(10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
