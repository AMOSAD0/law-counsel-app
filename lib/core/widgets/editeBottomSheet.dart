import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_counsel_app/core/helper/UploadImage.dart';
import 'package:law_counsel_app/core/helper/image_picker_helper.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';

class EditArticleBottomSheet extends StatefulWidget {
  final String articleId;
  final String content;
  final String? imageUrl;

  const EditArticleBottomSheet({
    super.key,
    required this.articleId,
    required this.content,
    this.imageUrl,
  });

  @override
  State<EditArticleBottomSheet> createState() => _EditArticleBottomSheetState();
}

class _EditArticleBottomSheetState extends State<EditArticleBottomSheet> {
  late TextEditingController contentController;
  String? updatedImage;

  Future<String?> getImgUrl(File img) async {
    return await ImageUploadHelper.uploadImageToKit(img);
  }

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController(text: widget.content);
    updatedImage = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('تعديل المقالة', style: AppTextStyles.font18PrimaryNormal),
           verticalSpace(16),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'اكتب محتوى المقالة هنا...',
                border: OutlineInputBorder(),
              ),
            ),
            verticalSpace(16),
            if (updatedImage != null)
              Column(
                children: [
                  Image.network(updatedImage!, height: 150),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => updatedImage = null);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      'حذف الصورة',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            TextButton.icon(
              onPressed: () async {
                XFile? file = await ImagePickerHelper.pickImageFromGallery();
                if (file == null) {
                  return;
                }
                File image = File(file.path);
                String? url = await getImgUrl(image);
                setState(() {
                  updatedImage = url;
                });
              },
              label:  Text('اختيار صورة جديدة', style: AppTextStyles.font16primaryColorNormal),
            ),
           
            PublicButton(text: 'حفظ التعديلات', onPressed:  () async {
                await FirebaseFirestore.instance
                    .collection('articles')
                    .doc(widget.articleId)
                    .update({
                      'content': contentController.text,
                      'imageUrl': updatedImage, 
                    });
                Navigator.pop(context);
              },),
            // ElevatedButton(
            //   onPressed: () async {
            //     await FirebaseFirestore.instance
            //         .collection('articles')
            //         .doc(widget.articleId)
            //         .update({
            //           'content': contentController.text,
            //           'imageUrl': updatedImage, 
            //         });
            //     Navigator.pop(context);
            //   },
            //   child:  Text('حفظ التعديلات'),
            // ),
          ],
        ),
      ),
    );
  }
}
