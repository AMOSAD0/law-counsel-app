import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardLawyerHome extends StatelessWidget {
  const CardLawyerHome({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"image": "assets/images/images33.jfif", "name": "طلاق"},
      {"image": "assets/images/images33.jfif", "name": "مالي"},
      {"image": "assets/images/images.4jpg.jfif", "name": "جنائي"},
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          return Container(
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
          );
        },
      ),
    );
  }
}
