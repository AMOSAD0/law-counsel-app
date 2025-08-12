import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/formatDateToArabic.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/CommentsBottomSheet.dart';
import 'package:law_counsel_app/core/widgets/deleteBottomSheet.dart';
import 'package:law_counsel_app/core/widgets/editeBottomSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cardarticale extends StatefulWidget {
  final String uderId;
  final String userName;
  final String? userImage;
  final String content;
  final String? articleImage;
  final String date;
  final String articleId;
  final List<String>? likes;

  const Cardarticale({
    super.key,
    required this.uderId,
    required this.userName,
    required this.content,
    required this.date,
    required this.articleId,
    this.userImage,
    this.articleImage,
    this.likes,
  });

  @override
  State<Cardarticale> createState() => _CardarticaleState();
}

class _CardarticaleState extends State<Cardarticale> {
  String? userId;
  String? userType;
  late final DocumentReference articleRef;

  @override
  void initState() {
    super.initState();
    articleRef = FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.articleId);
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('uid');
      userType = prefs.getString('userType');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  backgroundImage: widget.userImage != null
                      ? NetworkImage(widget.userImage!)
                      : AssetImage(AppAssets.defaultImgProfile)
                            as ImageProvider,
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: AppTextStyles.font16primaryColorBold,
                      ),
                      verticalSpace(4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey),
                          horizontalSpace(6),
                          Text(
                            formatDateToArabic(widget.date),
                            style: AppTextStyles.font14PrimarySemiBold.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (userId == widget.uderId)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) => EditArticleBottomSheet(
                            articleId: widget.articleId,
                            content: widget.content,
                            imageUrl: widget.articleImage,
                          ),
                        );
                      } else if (value == 'delete') {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) => ConfirmDeleteBottomSheet(
                            articleId: widget.articleId,
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: AppColors.primaryColor),
                            horizontalSpace(8),
                            Text('تعديل'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            horizontalSpace(8),
                            Text('حذف'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Image
          if (widget.articleImage != null && widget.articleImage!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                widget.articleImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.h,
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              widget.content,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font16primaryColorBold.copyWith(
                height: 1.6,
                color: AppColors.primaryColor.withOpacity(0.8),
              ),
            ),
          ),

          // Buttons
          if (userType == 'lawyer')
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      onTap: () async {
                        if (widget.likes!.contains(userId)) {
                          widget.likes!.remove(userId);
                        } else {
                          widget.likes!.add(userId!);
                        }
                        await articleRef.update({'likes': widget.likes});
                      },
                      icon: widget.likes!.contains(userId)
                          ? AppAssets.activeHeart
                          : AppAssets.heart,
                      label: "أعجبني",
                      count: widget.likes!.length,
                      isActive: widget.likes!.contains(userId),
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: _buildActionButton(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) => CommentsBottomSheet(
                            articleId: widget.articleId,
                            userId: userId!,
                          ),
                        );
                      },
                      icon: AppAssets.comment,
                      label: "تعليق",
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String icon,
    required String label,
    int count = 0,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryColor.withOpacity(0.08)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive
                ? AppColors.primaryColor.withOpacity(0.3)
                : AppColors.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 20.h, width: 20.w),
            if (count > 0) ...[
              horizontalSpace(8),
              Text('$count', style: AppTextStyles.font14PrimarySemiBold),
            ],
            horizontalSpace(6),
            Text(label, style: AppTextStyles.font14PrimarySemiBold),
          ],
        ),
      ),
    );
  }
}
