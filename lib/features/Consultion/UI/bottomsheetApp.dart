import 'package:flutter/material.dart';

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
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'عنوان الاستشارة'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'تفاصيل الاستشارة'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onSubmit,
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      );
    },
  );
}
