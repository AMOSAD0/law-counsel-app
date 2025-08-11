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
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        // gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: [
        //           AppColors.whiteColor,
        //           const Color.fromARGB(134, 148, 158, 199),
                 
        //         ],
        //       ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.04),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with User Info
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                // User Avatar with Border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: widget.userImage != null
                        ? NetworkImage(widget.userImage!)
                        : AssetImage(AppAssets.defaultImgProfile) as ImageProvider,
                  ),
                ),
                
                horizontalSpace(16),
                
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: AppTextStyles.font16primaryColorBold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      verticalSpace(4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.primaryColor.withOpacity(0.6),
                          ),
                          horizontalSpace(6),
                          Text(
                            formatDateToArabic(widget.date),
                            style: AppTextStyles.font14PrimarySemiBold.copyWith(
                              color: AppColors.primaryColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Menu
                if (userId == widget.uderId)
                  Container(
                    decoration: BoxDecoration(
                      // color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return EditArticleBottomSheet(
                                articleId: widget.articleId,
                                content: widget.content,
                                imageUrl: widget.articleImage,
                              );
                            },
                          );
                        } else if (value == 'delete') {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return ConfirmDeleteBottomSheet(
                                articleId: widget.articleId,
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: AppColors.primaryColor,
                                    size: 18,
                                  ),
                                  horizontalSpace(8),
                                  const Text('تعديل'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  horizontalSpace(8),
                                  const Text('حذف'),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Article Image
          if (widget.articleImage != null && widget.articleImage != '')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Image.network(
                    widget.articleImage!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
            ),
          
          // Article Content
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font16primaryColorBold.copyWith(
                    height: 1.5,
                    color: AppColors.primaryColor.withOpacity(0.8),
                  ),
                ),
                
                verticalSpace(16),
                
                
              ],
            ),
          ),
          
          // Interactive Section
          if (userType == 'lawyer')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(16.0),
              
              child: Row(
                children: [
                  // Like Button
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (widget.likes!.contains(userId)) {
                          widget.likes!.remove(userId);
                        } else {
                          widget.likes!.add(userId!);
                        }
                        await articleRef.update({'likes': widget.likes});
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: //widget.likes!.contains(userId)
                              // ? AppColors.primaryColor.withOpacity(0.1)
                               AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.likes!.contains(userId)
                                ? AppColors.primaryColor.withOpacity(0.3)
                                : AppColors.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              widget.likes!.contains(userId)
                                  ? AppAssets.activeHeart
                                  : AppAssets.heart,
                              height: 20.h,
                              width: 20.w,
                            ),
                            horizontalSpace(8),
                            Text(
                              widget.likes!.isEmpty
                                  ? '0'
                                  : widget.likes!.length.toString(),
                              style: AppTextStyles.font14PrimarySemiBold.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            horizontalSpace(4),
                            Text(
                              "أعجبني",
                              style: AppTextStyles.font14PrimarySemiBold.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  horizontalSpace(12),
                  
                  // Comment Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return CommentsBottomSheet(
                              articleId: widget.articleId,
                              userId: userId!,
                            );
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.comment,
                              height: 20.h,
                              width: 20.w,
                            ),
                            horizontalSpace(8),
                            Text(
                              "تعليق",
                              style: AppTextStyles.font14PrimarySemiBold.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          verticalSpace(16),
        ],
      ),
    );
  }
}
