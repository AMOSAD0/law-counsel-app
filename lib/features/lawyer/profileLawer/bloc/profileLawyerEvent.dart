import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class LawyerProfileEvent extends Equatable {
  const LawyerProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetLawyerProfile extends LawyerProfileEvent {
  final String lawyerId;

  const GetLawyerProfile(this.lawyerId);

  @override
  List<Object?> get props => [lawyerId];
}


class UpdateLawyerProfile extends LawyerProfileEvent {
  final String lawyerId;
  final Map<String, dynamic> updatedData;
  final File? profileImg;

  const UpdateLawyerProfile({
    required this.lawyerId,
    required this.updatedData,
    this.profileImg,
  });

  @override
  List<Object?> get props => [lawyerId, updatedData, profileImg];
}
