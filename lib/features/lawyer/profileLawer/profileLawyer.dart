import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerBloc.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerEvent.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LawyerProfilePage extends StatefulWidget {
  const LawyerProfilePage({super.key});

  @override
  State<LawyerProfilePage> createState() => _LawyerProfilePageState();
}

class _LawyerProfilePageState extends State<LawyerProfilePage> {
  String? userId;

  @override
  void initState() {
    super.initState();
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
    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return BlocProvider(
      create: (_) {
        return LawyerProfileBloc(firestore: FirebaseFirestore.instance)
          ..add(GetLawyerProfile(userId!));
      },
      child: BlocBuilder<LawyerProfileBloc, LawyerProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          } else if (state.lawyerData != null) {
            final lawyer = Lawyer.fromJson(state.lawyerData!);
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
                        child: SizedBox(
                          width: double.infinity,
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
                                lawyer.aboutMe ?? 'لا توجد معلومات متاحة',
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
                                children: List<Widget>.from(
                                  (lawyer.specializations
                                          as List<dynamic>)
                                      .map((tag) => _buildTag(tag.toString())),
                                ),
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
                              verticalSpace(12),
                              Text(
                                lawyer.achievements ?? 'لا توجد معلومات متاحة',
                                style: AppTextStyles.font16primaryColorNormal,
                                textAlign: TextAlign.right,
                              ),
                          
                          
                              verticalSpace(40),
                            ],
                          ),
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
                                  lawyer.profileImageUrl==''|| lawyer.profileImageUrl==null?
                                      'https://i.pravatar.cc/300':
                                      lawyer.profileImageUrl!,
                                ),
                              ),
                              verticalSpace(8),
                              Text(
                                lawyer.name,
                                style: AppTextStyles.font24PrimarySemiBold,
                              ),
                              Text(
                                'محامي',
                                style: AppTextStyles.font20PrimarySemiBold,
                              ),
                              verticalSpace(12),
                              PublicButton(
                                text: 'تعديل الملف الشخصي',
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.editProfileLawyer,
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
          } else {
            return const Text('لم يتم العثور على بيانات');
          }
        },
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


