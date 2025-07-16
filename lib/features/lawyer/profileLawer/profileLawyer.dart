import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/editProfileLawyer.dart';

class LawyerProfilePage extends StatelessWidget {
  const LawyerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 130.h,
                color: AppColors.primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    verticalSpace(380),
                    Text(
                      'نبذة عني',
                      style: AppTextStyles.font20PrimarySemiBold,
                    ),
                    verticalSpace(12),
                    Text(
                      'تأسيس مكتب المحامي، طريق النجاح عام 2025 وذلك لتقديم الخدمات القانونية لكل من الشركات والأفراد داخل مصر',
                      style: AppTextStyles.font16primaryColorNormal,
                      textAlign: TextAlign.right,
                    ),
                    verticalSpace(20),
                    Text(
                      'مجال التخصص',
                      style: AppTextStyles.font20PrimarySemiBold,
                    ),
                    verticalSpace(12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildTag('جنائي'),
                        _buildTag('مدني'),
                        _buildTag('أخري'),
                      ],
                    ),
                    verticalSpace(20),

                    Text(
                      'سعر الخدمة',
                      style: AppTextStyles.font20PrimarySemiBold,
                    ),
                    verticalSpace(12),
                    Chip(
                      backgroundColor: AppColors.primaryColor,
                      label: Text(
                        "500 جنية",
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.font16WhiteNormal,
                      ),
                    ),
                    verticalSpace(20),
                    Text(
                      'الإنجازات',
                      style: AppTextStyles.font20PrimarySemiBold,
                    ),
                    const _AchievementBullet(
                      text: 'حصلت على حكم لصالحك في 12 قضية جنائية كبرى',
                    ),
                    const _AchievementBullet(
                      text: 'حققت في أكثر من 100 جلسة استشارية ناجحة',
                    ),
                    const _AchievementBullet(
                      text: 'حصلت على المركز الأول في 7 مؤتمرات قانونية',
                    ),
                    const _AchievementBullet(
                      text: 'أتممت دراسة الماجستير في القانون الجنائي',
                    ),
                    const _AchievementBullet(
                      text: 'حصلت على تقييم ⭐ 5 في أكثر من 30 منصة',
                    ),
                    const _AchievementBullet(
                      text: 'عضو نقابة المحامين العراقيين منذ عام 2020',
                    ),

                    verticalSpace(40),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 70),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/300',
                        ),
                      ),
                      verticalSpace(8),
                      Text(
                        'زهراء مجدي',
                        style: AppTextStyles.font24PrimarySemiBold,
                      ),
                      Text('محامي', style: AppTextStyles.font20PrimarySemiBold),
                      verticalSpace(12),
                      PublicButton(
                        text: 'تعديل الملف الشخصي',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Editprofilelawyer(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Chip(
      backgroundColor: AppColors.primaryColor,
      label: Text(text, style: AppTextStyles.font16WhiteNormal),
    );
  }
}

class _AchievementBullet extends StatelessWidget {
  final String text;
  const _AchievementBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        const Text("• ", style: TextStyle(color: AppColors.primaryColor)),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.font16primaryColorNormal,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
