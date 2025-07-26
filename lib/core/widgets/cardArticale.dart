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
    });
  }

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
              backgroundImage: widget.userImage != null? NetworkImage(
                widget.userImage!,
              ) : AssetImage(AppAssets.defaultImgProfile),
              ), 
            title: Text(
              widget.userName,
              style: AppTextStyles.font14PrimaryBold,
            ),
            subtitle: Text(
              formatDateToArabic(widget.date),
              style: AppTextStyles.font12PrimarySemiBold,
            ),

            trailing:
                userId == widget.uderId
                    ? PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.primaryColor,
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
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
                                top: Radius.circular(16),
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
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('تعديل'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('حذف'),
                            ),
                          ],
                    )
                    : SizedBox.shrink(),
          ),

          // Article Image
          if (widget.articleImage != null && widget.articleImage != '')
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
                InkWell(
                  onTap: () async {
                    if (widget.likes!.contains(userId)) {
                      widget.likes!.remove(userId);
                    } else {
                      widget.likes!.add(userId!);
                    }

                    await articleRef.update({'likes': widget.likes});
                  },
                  child: Image.asset(
                    widget.likes!.isNotEmpty || widget.likes!.contains(userId)
                        ? AppAssets.activeHeart
                        : AppAssets.heart,

                    height: 25.h,
                    width: 25.w,
                  ),
                ),
                horizontalSpace(4),
                Text(
                  widget.likes!.isEmpty ? '' : widget.likes!.length.toString(),
                  style: AppTextStyles.font14PrimarySemiBold,
                ),
                horizontalSpace(8),
                Text("أعجبني", style: AppTextStyles.font14PrimarySemiBold),
                Spacer(),
                InkWell(
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
                  child: Image.asset(
                    AppAssets.comment,
                    height: 25.h,
                    width: 25.w,
                  ),
                ),
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
