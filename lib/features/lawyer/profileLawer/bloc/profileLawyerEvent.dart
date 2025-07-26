// lawyer_profile_event.dart
import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class LawyerProfileEvent extends Equatable {
  const LawyerProfileEvent();
}

class GetLawyerProfile extends LawyerProfileEvent {
  final String lawyerId;

  const GetLawyerProfile(this.lawyerId);

  @override
  List<Object?> get props => [lawyerId];
}

class UpdateLawyerProfile extends LawyerProfileEvent {
  final String lawyerId;
  final File ?profileImg;
  final Map<String, dynamic> updatedData;

  const UpdateLawyerProfile(this.lawyerId, this.updatedData,this.profileImg);

  @override
  List<Object?> get props => [lawyerId, updatedData, profileImg];
}
