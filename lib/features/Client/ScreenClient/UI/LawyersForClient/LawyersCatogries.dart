import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/ListLawyer.dart';

class Lawyerscatogries extends StatefulWidget {
  const Lawyerscatogries({super.key});

  @override
  State<Lawyerscatogries> createState() => _LawyerscatogriesState();
}

class _LawyerscatogriesState extends State<Lawyerscatogries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.btnColor),

        backgroundColor: AppColors.primaryColor,
        title: Text("كل التخصصات", style: AppTextStyles.font18WhiteNormal),
      ),
      body: LawyerCategoryList(),
    );
  }
}
