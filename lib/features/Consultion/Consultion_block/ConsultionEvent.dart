import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:law_counsel_app/features/Consultion/data/consulation.dart';

abstract class ConsultationEvent extends Equatable {
  const ConsultationEvent();

  @override
  List<Object?> get props => [];
}

// إرسال استشارة جديدة
class SendConsultationEvent extends ConsultationEvent {
  final Consultation consultation;
  final DocumentReference docRef;

  const SendConsultationEvent(this.consultation, this.docRef);

  @override
  List<Object?> get props => [consultation, docRef]; 
}

// حذف استشارة
class DeleteConsultationEvent extends ConsultationEvent {
  final DocumentReference docRef;

  const DeleteConsultationEvent(this.docRef);

  @override
  List<Object?> get props => [docRef];
}


// تعديل استشارة
class UpdateConsultationEvent extends ConsultationEvent {
  final Consultation consultation;
  final DocumentReference docRef;

  const UpdateConsultationEvent(this.consultation, this.docRef);

  @override
  List<Object?> get props => [consultation, docRef]; 
}

class UpdatePaymentStatusEvent extends ConsultationEvent {
  final DocumentReference docRef;
  final bool paid;

  const UpdatePaymentStatusEvent(this.docRef, this.paid);

  @override
  List<Object?> get props => [docRef, paid];
}
