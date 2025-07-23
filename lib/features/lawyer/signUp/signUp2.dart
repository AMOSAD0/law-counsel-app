import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/image_picker_helper.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/helper/validators.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/customAlertPopup.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';
import 'package:law_counsel_app/features/lawyer/signUp/bloc/signUpBloc.dart';
import 'package:law_counsel_app/features/lawyer/signUp/bloc/signUpEvent.dart';
import 'package:law_counsel_app/features/lawyer/signUp/bloc/signUpState.dart';
import 'package:law_counsel_app/features/lawyer/signUp/widgets/specialization_selector.dart';
import 'package:law_counsel_app/features/lawyer/testChat.dart';

class SignupForLawyer2 extends StatefulWidget {
  final Lawyer lawyer;
  final String password;

  SignupForLawyer2({super.key, required this.lawyer, required this.password});

  @override
  State<SignupForLawyer2> createState() => _SignupForLawyer2State();
}

class _SignupForLawyer2State extends State<SignupForLawyer2> {
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
    return BlocProvider(
      create: (context) => SignUpLawerBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  minBackground(),
                  verticalSpace(10),
                  Text(
                    '!سجّل الأن مجاناً',
                    style: AppTextStyles.font24PrimarySemiBold,
                  ),
                  verticalSpace(15),
                  Text(
                    '. ادخل البيانات التالية لانشاء حساب جديد',
                    style: AppTextStyles.font16GrayNormal,
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
                  verticalSpace(15),
                  // PublicButton(text: "تسجيل مستخدم جديد", onPressed: () {}),
                  BlocConsumer<SignUpLawerBloc, SignUpLawyerState>(
                    listener: (context, state) async{
                      if (state.status == SignUpLawyerStatus.success) {
                        
                       await AlertPopup.show(context,
                         message: "تم التسجيل بنجاح",
                         type: AlertType.success,
                         );
                         if(context.mounted){
                         Navigator.pushReplacementNamed(context, Routes.login);
                         }
                      } else if (state.status == SignUpLawyerStatus.failure) {
                        AlertPopup.show(context,
                         message:"فشل في التسجيل: ${state.error ?? ''}",
                          );
                        
                      }
                    },
                    builder: (context, state) {
                      return PublicButton(
                        text:
                            state.status == SignUpLawyerStatus.loading
                                ? 'جاري التسجيل...'
                                : 'تسجيل مستخدم جديد',
                        onPressed:
                            state.status == SignUpLawyerStatus.loading
                                ? () {}
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (selectedSpecs.value.isEmpty) {
                                      AlertPopup.show(context, 
                                      message: "من فضلك اختر التخصصات",
                                      type: AlertType.error,
                                      );
                                      return;
                                    }
                                    final updateLawyer = widget.lawyer.copyWith(
                                      birthDate: birthDateController.text,
                                      city: cityController.text,
                                      specializations: selectedSpecs.value,
                                      profileImageUrl: 'img',
                                    );
                                      context.read<SignUpLawerBloc>().add(
                                        SignUpLawyerSubmitted(
                                          lawyer: updateLawyer,
                                          idImg: _idImage,
                                          barImg: _barImage,
                                          password: widget.password,
                                        ),
                                      );
                                    
                                  }
                                },
                      );
                    },
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        "لديك حساب بالفعل ؟",
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.font14PrimarySemiBold,
                      ),
                      horizontalSpace(10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TestChatForLawyer()));
                        },
                        child: Text(
                          "سجل الدخول",
                          textDirection: TextDirection.rtl,
                          style: AppTextStyles.font14PrimaryBold,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
