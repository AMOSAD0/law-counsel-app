import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/image_picker_helper.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/helper/validators.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/lawyer/signUp/widgets/specialization_selector.dart';

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

  late DateTime date;

  File? _idImage;

  File? _barImage;

  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 25),
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
                      PublicTextFormField(
                        onTap: () async {
                          XFile? file =
                              await ImagePickerHelper.pickImageFromGallery();
                          if (file == null) {
                            return;
                          }
                          setState(() {
                            _idImage = File(file.path);
                            idImgController.text = file.name;
                          });
                        },
                        label: 'ارفع صورة البطاقة الشخصية',
                        controller: idImgController,
                        validator: Validators.validateIdImg,
                        readOnly: true,
                        suffixIcon: Icon(
                          Icons.image,
                          color: AppColors.primaryColor,
                          size: 30.r,
                        ),
                      ),
                      if (_idImage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_idImage!, fit: BoxFit.cover),
                          ),
                        ),
                      PublicTextFormField(
                        onTap: () async {
                          XFile? file =
                              await ImagePickerHelper.pickImageFromGallery();
                          if (file == null) {
                            return;
                          }
                          setState(() {
                            _barImage = File(file.path);
                            barImgController.text = file.name;
                          });
                        },
                        label: 'ارفع بطاقة عضوية نقابة المحامين',
                        controller: barImgController,
                        validator: Validators.validateBarImg,
                        readOnly: true,
                        suffixIcon: Icon(
                          Icons.image,
                          color: AppColors.primaryColor,
                          size: 30.r,
                        ),
                      ),
                      if (_barImage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_barImage!, fit: BoxFit.cover),
                          ),
                        ),
                      verticalSpace(25),
                      SpecializationSelector(
                        selectedSpecializationsNotifier: selectedSpecs,
                      ),
                      verticalSpace(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'الأنجازات',
                          style: AppTextStyles.font20PrimarySemiBold,
                        ),
                      ),
                      verticalSpace(12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'حصلت على حكم بالبراءة في 12 قضية جنائية كبرى.\n تعاملت مع أكثر من 100 استشارة قانونية بنجاح. \nخبرة في المحاكم الجنائية لأكثر من 7 سنوات......',
                            style: AppTextStyles.font16primaryColorNormal,
                          ),
                        ),
                      ),
            
                      verticalSpace(20),
                      PublicButton(text: 'حفظ التغيرات', onPressed: () {}),
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
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/300',
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 50.r,
                            color: AppColors.whiteColor.withAlpha(170),
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
  }
}
