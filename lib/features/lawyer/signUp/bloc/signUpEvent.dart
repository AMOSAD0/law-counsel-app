import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';

abstract class SignUpLawyerEvent extends Equatable {
  const SignUpLawyerEvent();

  @override
  List<Object?> get props => [];
}

class SignUpLawyerSubmitted extends SignUpLawyerEvent {
  final Lawyer lawyer;
  final String password;
  final File ?idImg;
  final File ?barImg;

  const SignUpLawyerSubmitted({required this.lawyer, required this.password,required this.idImg,required this.barImg});

  @override
  List<Object?> get props => [lawyer, password,idImg,barImg];
}
