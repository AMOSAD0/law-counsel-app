import 'package:flutter/material.dart';

class AlrtDialogApp extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback? onPressed;

  const AlrtDialogApp({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[50],
      title: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }
}


class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.red[50],
      title: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }
}
