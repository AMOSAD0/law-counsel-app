import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';

abstract class LawyerManagementState {}

class LawyerManagementInit extends LawyerManagementState {}

class LawyerManagementLoading extends LawyerManagementState {}

class LawyerManagementLoaded extends LawyerManagementState {
  final List<Lawyer> lawyers;
  LawyerManagementLoaded(this.lawyers);
}

class LawyerManagementError extends LawyerManagementState {
  final String message;
  LawyerManagementError(this.message);
}
