import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_counsel_app/core/helper/image_picker_helper.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/bloc/createArticaleBloc.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/bloc/createArticaleEvent.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/bloc/createArticaleState.dart';

class CreateArticleWidget extends StatefulWidget {
  const CreateArticleWidget({super.key});

  @override
  State<CreateArticleWidget> createState() => _CreateArticleWidgetState();
}

class _CreateArticleWidgetState extends State<CreateArticleWidget> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController ImgController = TextEditingController();
  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateArticleBloc(),
      child: Form(
        key: _formKey,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' اكتب مقالة',
                  style: AppTextStyles.font18PrimaryNormal.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                verticalSpace(12),

                // Text Field
                TextField(
                  controller: _contentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'بماذا تفكر؟ شارك أفكارك...',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.all(14.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                verticalSpace(12),

                // Add Image
                PublicTextFormField(
                  onTap: () async {
                    XFile? file =
                        await ImagePickerHelper.pickImageFromGallery();
                    if (file == null) return;
                    setState(() {
                      _selectedImage = File(file.path);
                      ImgController.text = file.name;
                    });
                  },
                  label: 'إضافة صورة',
                  controller: ImgController,
                  readOnly: true,
                  padding: EdgeInsets.zero,
                  suffixIcon: Icon(
                    Icons.image_outlined,
                    color: AppColors.primaryColor,
                    size: 26.r,
                  ),
                ),

                if (_selectedImage != null) ...[
                  verticalSpace(8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      _selectedImage!,
                      height: 140.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],

                verticalSpace(16),

                // Publish Button
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<CreateArticleBloc, CreateArticleState>(
                    listener: (context, state) {
                      if (state is CreateArticleSuccess) {
                        _contentController.clear();
                        ImgController.clear();
                        setState(() => _selectedImage = null);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(' تم نشر المقال بنجاح'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (state is CreateArticleFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(' فشل النشر: ${state.message}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CreateArticleLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ElevatedButton.icon(
                        onPressed: () async {
                          if (_selectedImage != null ||
                              _contentController.text.isNotEmpty) {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final userDoc = await FirebaseFirestore.instance
                                  .collection('lawyers')
                                  .doc(user.uid)
                                  .get();
                              final userName =
                                  userDoc.data()?['name'] ?? 'مستخدم';

                              context.read<CreateArticleBloc>().add(
                                PublishArticle(
                                  content: _contentController.text,
                                  image: _selectedImage,
                                  userId: user.uid,
                                  userName: userName,
                                  userImage: userDoc.data()?['profileImageUrl'],
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ' يرجى إضافة محتوى أو صورة أولاً',
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 2,
                        ),
                        icon: Icon(Icons.send_rounded, size: 20.r),
                        label: Text(
                          'نشر',
                          style: AppTextStyles.font16WhiteNormal,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
