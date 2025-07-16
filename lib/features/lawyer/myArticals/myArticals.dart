import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/cardArticale.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/widgets/createArticale.dart';

class Myarticals extends StatelessWidget {
  const Myarticals({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.whiteColor),
        drawer: Drawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'البحث',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              verticalSpace(16),
              CreateArticleWidget(),
              verticalSpace(16),
              Text(
                'مقالاتي',
                style: AppTextStyles.font20PrimarySemiBold,
              ),
              verticalSpace(16),
              // Cardarticale(),
            ],
          ),
        ),
      ),
    );
  }
}
