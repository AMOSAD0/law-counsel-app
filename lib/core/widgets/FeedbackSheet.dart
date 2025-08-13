import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';

class FeedbackSheet extends StatefulWidget {
  final String lawyerId;
  final String nameClient;
  final String clientId;
  final String nameLawyer;

  const FeedbackSheet({
    super.key,
    required this.lawyerId,
    required this.nameClient,
    required this.clientId,
    required this.nameLawyer,
  });

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 5;
  bool _isLoading = false;

  Future<void> _submitFeedback() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('من فضلك أدخل تعليقك')));
      return;
    }

    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('من فضلك اختر التقييم')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final feedbackData = {
      'clientId': widget.clientId,
      'lawyerId': widget.lawyerId,
      'nameClient': widget.nameClient,
      'nameLawyer': widget.nameLawyer,
      'description': _commentController.text.trim(),
      'rating': _rating.toInt(),
      'createdAt': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('lawyers')
          .doc(widget.lawyerId)
          .update({
            'feedback': FieldValue.arrayUnion([feedbackData]),
          });

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إضافة التعليق بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء إضافة التعليق')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "إضافة تعليق",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "اكتب تعليقك هنا...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnColor,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _isLoading ? null : _submitFeedback,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      )
                    : Text("إرسال", style: AppTextStyles.font14WhiteNormal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
