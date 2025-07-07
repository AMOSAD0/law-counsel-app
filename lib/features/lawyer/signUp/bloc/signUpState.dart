import 'package:equatable/equatable.dart';

enum SignUpLawyerStatus { initial, loading, success, failure }

class SignUpLawyerState extends Equatable {
  final SignUpLawyerStatus status;
  final String? error;

  const SignUpLawyerState({
    this.status = SignUpLawyerStatus.initial,
    this.error,
  });

  SignUpLawyerState copyWith({
    SignUpLawyerStatus? status,
    String? error,
  }) {
    return SignUpLawyerState(
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, error ?? ''];
}
