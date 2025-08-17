import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/UI/ShowLawyer.dart';

class CardLawyerHome extends StatelessWidget {
  const CardLawyerHome({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"image": "assets/images/images33.jfif", "name": "مدني","type": "مدنى"},
      {"image": "assets/images/images33.jfif", "name": "تجارى" ,"type": "تجارى"},
      {"image": "assets/images/images.4jpg.jfif", "name": "جنائي","type": "جنائى"},
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          return InkWell(
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
              width: 140.w,
              margin: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.sp),
                    child: Image.asset(
                      item["image"],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
            
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16.sp),
                    ),
                  ),
            
                  Center(
                    child: Text(
                      item["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
