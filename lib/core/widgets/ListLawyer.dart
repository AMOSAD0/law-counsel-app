import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/UI/ShowLawyer.dart';

class LawyerCategoryList extends StatelessWidget {
  const LawyerCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> lawyerCategories = [
      {
        "image": "assets/images/images33.jfif",
        "type": "جنائى",
        "desc": "نقبل قضايا الجرائم مثل القتل، السرقة، المخدرات، التعدي الخ...",
      },
      {
        "image": "assets/images/images.44jpg.jfif",
        "type": "مدنى",
        "desc":
            "نقبل قضايا العقود، التعويضات، النزاعات على الملكية، الديون، القضايا المدنية الأخرى...",
      },
      {
        "image": "assets/images/images.4jpg.jfif",
        "type": "إدارى",
        "desc":
            "نقبل قضايا الحكومة، المنازعات الإدارية، التراخيص، القرارات الإدارية...",
      },
      {
        "image": "assets/images/lawofWorkerjpg.jfif",
        "type": "العمل",
        "desc":
            "نقبل قضايا العمل، الفصل التعسفي، الأجور، حقوق العمال، عقود العمل...",
      },
      {
        "image": "assets/images/lawofWorkerjpg.jfif",
        "type": "الضرائب",
        "desc":
            "نقبل قضايا الضرائب، التهرب الضريبي، المنازعات الضريبية، الاستشارات الضريبية...",
      },
      {
        "image": "assets/images/images.4jpg.jfif",
        "type": "التأمينات والمعاشات",
        "desc":
            "نقبل قضايا التأمينات الاجتماعية، المعاشات، التعويضات عن الحوادث...",
      },
      {
        "image":  "assets/images/images33.jfif",
        "type": "الأحوال الشخصية",
        "desc":
            "نقبل قضايا الطلاق، النفقة، الحضانة، تقسيم الممتلكات، القضايا الأسرية الأخرى...",
      },
      {
        "image": "assets/images/lawofWorkerjpg.jfif",
        "type": "تجارى",
        "desc":
            "نقبل قضايا الشركات، العقود التجارية، العلامات التجارية، الإفلاس...",
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: lawyerCategories.length,
      itemBuilder: (context, index) {
        final item = lawyerCategories[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: InkWell(
            onTap: () {
              final category = item['type'];
              if (category != null && category.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowLawyer(category: category.trim()),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("لا توجد تخصصات لعرضها")),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightBlueWithOpacity),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      item['image']!,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  horizontalSpace(15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['type']!,
                          style: AppTextStyles.font16primaryColorBold,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item['desc']!,
                          style: AppTextStyles.font14PrimarySemiBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
