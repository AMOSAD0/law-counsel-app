import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:law_counsel_app/features/Consultion/data/consulation.dart';

abstract class ConsultationEvent extends Equatable {
  const ConsultationEvent();

  @override
  List<Object?> get props => [];
}

class SendConsultationEvent extends ConsultationEvent {
  final Consultation consultation;
  final DocumentReference docRef;

  const SendConsultationEvent(this.consultation, this.docRef);

  @override
  List<Object?> get props => [consultation];
}

class DeleteConsultationEvent extends ConsultationEvent {
  final String consultationId;

  const DeleteConsultationEvent(this.consultationId);

  @override
  List<Object?> get props => [consultationId];
}

class UpdateConsultationEvent extends ConsultationEvent {
  final Consultation consultation;
  final DocumentReference docRef;

  const UpdateConsultationEvent(this.consultation, this.docRef);

  @override
  List<Object?> get props => [consultation];
}
