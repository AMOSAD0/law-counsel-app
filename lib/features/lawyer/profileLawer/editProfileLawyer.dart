import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/image_picker_helper.dart';

import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/helper/validators.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/bottomNav.dart';
import 'package:law_counsel_app/core/widgets/customAlertPopup.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerBloc.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerEvent.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerState.dart';
import 'package:law_counsel_app/features/lawyer/signUp/widgets/specialization_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editprofilelawyer extends StatefulWidget {
  Editprofilelawyer({super.key});

  @override
  State<Editprofilelawyer> createState() => _EditprofilelawyerState();
}

class _EditprofilelawyerState extends State<Editprofilelawyer> {
  final ValueNotifier<List<String>> selectedSpecs = ValueNotifier([]);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController idImgController = TextEditingController();
  final TextEditingController barImgController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController achievementsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  late DateTime date;
  File? _profileImage;
  String? userId;

  double? netPrice;

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
          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
                style: AppTextStyles.font16primaryColorNormal,
              ),
            );
          } else if (state.lawyerData != null) {
            final lawyer = Lawyer.fromJson(state.lawyerData!);

            birthDateController.text = lawyer.birthDate ?? '';
            cityController.text = lawyer.city ?? '';
            aboutMeController.text = lawyer.aboutMe ?? '';
            achievementsController.text = lawyer.achievements ?? '';
            selectedSpecs.value = lawyer.specializations;

            priceController.text = lawyer.price?.toString() ?? '';

            netPrice = lawyer.netPrice;

            return Scaffold(
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 130.h,
                          color: AppColors.primaryColor,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            children: [
                              verticalSpace(220),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  'البيانات الشخصية',
                                  style: AppTextStyles.font20PrimarySemiBold,
                                ),
                              ),
                              verticalSpace(15),
                              PublicTextFormField(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (picked != null) {
                                    birthDateController.text =
                                        "${picked.year}-${picked.month}-${picked.day}";
                                    date = picked;
                                  }
                                },
                                label: 'تاريخ الميلاد',
                                readOnly: true,
                                controller: birthDateController,
                                validator: Validators.validateBirthDate,
                                suffixIcon: Image(
                                  image: AssetImage(AppAssets.iconCalendar),
                                  height: 20.h,
                                ),
                              ),
                              PublicTextFormField(
                                onTap: () {},
                                label: 'المدينة',
                                controller: cityController,
                                validator: Validators.validateCity,
                                suffixIcon: Image(
                                  image: AssetImage(AppAssets.iconCity),
                                  height: 20.h,
                                ),
                              ),
                              // حقل السعر
                              PublicTextFormField(
                                onTap: () {},
                                label: 'السعر (بالجنيه)',
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال السعر';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'الرجاء إدخال رقم صالح';
                                  }
                                  return null;
                                },
                                suffixIcon: Icon(
                                  Icons.attach_money,
                                  color: AppColors.primaryColor,
                                  size: 30.r,
                                ),
                              ),

                              if (netPrice != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 4),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'قيد السعر المستحق: ${netPrice!.toStringAsFixed(2)} جنيه',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),

                              PublicTextFormField(
                                label: 'صورة البطاقة الشخصية',
                                controller: idImgController,
                                readOnly: true,
                                suffixIcon: Icon(
                                  Icons.image,
                                  color: AppColors.primaryColor,
                                  size: 30.r,
                                ),
                              ),
                              if (lawyer.idImageUrl != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      lawyer.idImageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              PublicTextFormField(
                                label: 'بطاقة عضوية نقابة المحامين',
                                controller: barImgController,
                                readOnly: true,
                                suffixIcon: Icon(
                                  Icons.image,
                                  color: AppColors.primaryColor,
                                  size: 30.r,
                                ),
                              ),
                              if (lawyer.barAssociationImageUrl != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      lawyer.barAssociationImageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              verticalSpace(25),
                              SpecializationSelector(
                                selectedSpecializationsNotifier: selectedSpecs,
                              ),
                              verticalSpace(20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  'نبذة عني',
                                  style: AppTextStyles.font20PrimarySemiBold,
                                ),
                              ),
                              verticalSpace(12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: TextFormField(
                                    maxLines: null,
                                    minLines: 4,
                                    keyboardType: TextInputType.multiline,
                                    style: AppTextStyles.font16primaryColorNormal,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'اكتب نبذة عنك هنا...',
                                    ),
                                    controller: aboutMeController,
                                  ),
                                ),
                              ),
                              verticalSpace(20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  'الإنجازات',
                                  style: AppTextStyles.font20PrimarySemiBold,
                                ),
                              ),
                              verticalSpace(12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: TextFormField(
                                    maxLines: null,
                                    minLines: 4,
                                    keyboardType: TextInputType.multiline,
                                    style: AppTextStyles.font16primaryColorNormal,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'اكتب إنجازاتك هنا...',
                                    ),
                                    controller: achievementsController,
                                  ),
                                ),
                              ),
                              verticalSpace(20),
                              BlocConsumer<LawyerProfileBloc, LawyerProfileState>(
                                listener: (context, state) async {
                                  if (state.isSuccess) {
                                    await AlertPopup.show(
                                      context,
                                      message: 'تم حفظ التغيرات بنجاح',
                                      type: AlertType.success,
                                    );
                                    if (context.mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BottomNavBarApp(isLawyer: true),
                                        ),
                                      );
                                    }
                                  } else if (state.error != null) {
                                    AlertPopup.show(
                                      context,
                                      message: state.error!,
                                      type: AlertType.error,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return PublicButton(
                                    text: state.isLoading
                                        ? 'جاري تعديل...'
                                        : 'حفظ التغيرات',
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        final updateLawyer = lawyer.copyWith(
                                          birthDate: birthDateController.text,
                                          city: cityController.text,
                                          specializations:
                                              selectedSpecs.value.isEmpty
                                                  ? lawyer.specializations
                                                  : selectedSpecs.value,
                                          aboutMe: aboutMeController.text,
                                          achievements: achievementsController.text,
                                          price:
                                              double.tryParse(priceController.text) ??
                                                  0,
                                        );

                                        context.read<LawyerProfileBloc>().add(
                                              UpdateLawyerProfile(
                                                lawyerId: userId!,
                                                updatedData: updateLawyer.toJson(),
                                                profileImg: _profileImage,
                                              ),
                                            );
                                      }
                                    },
                                  );
                                },
                              ),
                              verticalSpace(20),
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
                                  backgroundImage: _profileImage == null
                                      ? (lawyer.profileImageUrl != null
                                          ? NetworkImage(lawyer.profileImageUrl!)
                                          : AssetImage(AppAssets.defaultImgProfile)
                                              as ImageProvider)
                                      : Image.file(_profileImage!).image,
                                  child: IconButton(
                                    onPressed: () async {
                                      XFile? file =
                                          await ImagePickerHelper.pickImageFromGallery();
                                      if (file == null) return;
                                      setState(() {
                                        _profileImage = File(file.path);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 50.r,
                                      color: AppColors.whiteColor.withAlpha(170),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Text('');
          }
        },
      ),
    );
  }
}
