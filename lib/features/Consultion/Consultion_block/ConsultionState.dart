import 'package:equatable/equatable.dart';

abstract class ConsultationState extends Equatable {
  const ConsultationState();

  @override
  List<Object?> get props => [];
}

class ConsultationInitial extends ConsultationState {}

class ConsultationLoading extends ConsultationState {}

class ConsultationSuccess extends ConsultationState {
  final String message;

  const ConsultationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ConsultationError extends ConsultationState {
  final String error;

  const ConsultationError(this.error);

  @override
  List<Object?> get props => [error];
}
