import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/formatDateToArabic.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';

class Cardarticale extends StatefulWidget {
  final String userName;
  final String? userImage;
  final String content;
  final String? articleImage;
  final String date;

  const Cardarticale({
    super.key,
    required this.userName,
    required this.content,
    required this.date,
    this.userImage,
    this.articleImage,
  });
  @override
  State<Cardarticale> createState() => _CardarticaleState();
}

class _CardarticaleState extends State<Cardarticale> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/300',
              ), // صورة الكاتب
            ),
            title: Text(
              widget.userName,
              style: AppTextStyles.font14PrimaryBold,
            ),
            subtitle: Text(
              formatDateToArabic( widget.date),
              style: AppTextStyles.font12PrimarySemiBold,
            ),
            trailing: Icon(Icons.more_vert, color: AppColors.primaryColor),
          ),

          // Article Image
          if (widget.articleImage != null && widget.articleImage!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(widget.articleImage!, fit: BoxFit.cover),
            ),

          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              widget.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font16primaryColorNormal,
            ),
          ),
          verticalSpace(15),

          // Interactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Row(
              children: [
                Image.asset(AppAssets.heart, height: 25.h, width: 25.w),
                horizontalSpace(4),
                SizedBox(width: 4),
                Text("أعجبني", style: AppTextStyles.font14PrimarySemiBold),
                Spacer(),
                Image.asset(AppAssets.comment, height: 25.h, width: 25.w),
                horizontalSpace(4),
                Text("تعليق", style: AppTextStyles.font14PrimarySemiBold),
              ],
            ),
          ),
          verticalSpace(12),
        ],
      ),
    );
  }
}
