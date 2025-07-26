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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اكتب مقالة', style: AppTextStyles.font16primaryColorBold),
                verticalSpace(10),
                // Text Field
                TextField(
                  controller: _contentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'بماذا تفكر..................',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                verticalSpace(10),

                // Add Image Button
                PublicTextFormField(
                  onTap: () async {
                    XFile? file =
                        await ImagePickerHelper.pickImageFromGallery();
                    if (file == null) {
                      return;
                    }
                    setState(() {
                      _selectedImage = File(file.path);
                      ImgController.text = file.name;
                    });
                  },
                  label: 'اضافة صورة',
                  controller: ImgController,
                  readOnly: true,
                  padding: EdgeInsets.all(0),
                  suffixIcon: Icon(
                    Icons.image,
                    color: AppColors.primaryColor,
                    size: 30.r,
                  ),
                ),
                verticalSpace(12),
                // Publish Button
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<CreateArticleBloc, CreateArticleState>(
                    listener: (context, state) {
                      if (state is CreateArticleSuccess) {
                        _contentController.clear();
                        setState(() {
                          _selectedImage = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم نشر المقال بنجاح')),
                        );
                      } else if (state is CreateArticleFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('فشل النشر: ${state.message}'),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CreateArticleLoading) {
                        return const CircularProgressIndicator();
                      }

                      return ElevatedButton(
                        onPressed: () async {
                          if (_selectedImage != null ||
                              _contentController.text.isNotEmpty) {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final userDoc =
                                  await FirebaseFirestore.instance
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
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('يرجى إضافة محتوى أو صورة'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
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
