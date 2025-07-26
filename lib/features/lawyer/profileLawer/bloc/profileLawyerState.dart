// lawyer_profile_state.dart
import 'package:equatable/equatable.dart';

class LawyerProfileState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? lawyerData;
  final String? error;
    final bool isSuccess;


  const LawyerProfileState({
    this.isLoading = false,
    this.lawyerData,
    this.error,
    this.isSuccess = false,
  });

  LawyerProfileState copyWith({
    bool? isLoading,
    Map<String, dynamic>? lawyerData,
    String? error,
    bool? isSuccess,
  }) {
    return LawyerProfileState(
      isLoading: isLoading ?? this.isLoading,
      lawyerData: lawyerData ?? this.lawyerData,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, lawyerData, error, isSuccess];
}
class UpdateProfileLawyerState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const UpdateProfileLawyerState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  UpdateProfileLawyerState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return UpdateProfileLawyerState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, error];
}
