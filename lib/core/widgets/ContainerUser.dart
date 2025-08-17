import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/core/widgets/customAlertPopup.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';

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
                  Navigator.pushNamed(
                    context,
                    Routes.registerClient,
                  );
                } else if (selectedIndex == 1) {
                  Navigator.pushNamed(
                    context,
                    Routes.registerLawyer,
                  );
                }
              } else {
                AlertPopup.show(
                  context,
                  message: "الرجاء اختيار نوع المستخدم",
                  type: AlertType.info,
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
        width: isSelected ? 160.w : 150.w,
        height: isSelected ? 190.h : 180.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: Container(
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
      ),
    );
  }
}
