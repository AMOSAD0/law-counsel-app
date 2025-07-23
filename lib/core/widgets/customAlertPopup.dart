import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';

enum AlertType { success, error ,info}

class AlertPopup {
  static Future<void> show(
    BuildContext context, {
    required String message,
    AlertType type = AlertType.error,
  }) async{
    final Color backgroundColor = type == AlertType.success
        ? Colors.green.shade600
        :type== AlertType.error? Colors.red.shade600 
        :Colors.blue.shade600;

    final Icon icon = type == AlertType.success
        ? const Icon(Icons.check_circle, color: Colors.white,size: 45,)
        :type == AlertType.error? const Icon(Icons.warning, color: Colors.white,size: 45,)
        :const Icon(Icons.info, color: Colors.white,size: 45,);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: Column(
             mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              verticalSpace(18),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        );
      },
    );

    // Close it automatically after 2 seconds
   await Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) Navigator.of(context).pop();
    });
  }
}
