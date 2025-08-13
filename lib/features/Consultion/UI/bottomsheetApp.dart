import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';

void showConsultationBottomSheet({
  required BuildContext context,
  required TextEditingController titleController,
  required TextEditingController descriptionController,
  required VoidCallback onSubmit,
  required String buttonText,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Title Field ---
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'عنوان الاستشارة',
                    labelStyle: AppTextStyles.font16primaryColorNormal,
                    filled: true,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: AppTextStyles.font16primaryColorNormal,
                ),
                verticalSpace(20),

                // --- Description Field ---
                TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'تفاصيل الاستشارة',
                    labelStyle: AppTextStyles.font16primaryColorNormal,
                    filled: true,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: AppTextStyles.font14WhiteNormal,
                ),
                verticalSpace(25),

                // --- Submit Button ---
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.btnColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        buttonText,
                        style: AppTextStyles.font20PrimaryNormal,
                      ),
                    ),
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
