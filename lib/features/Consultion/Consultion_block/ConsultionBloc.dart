import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionEvent.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionState.dart';

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  final FirebaseFirestore firestore;

  ConsultationBloc({required this.firestore}) : super(ConsultationInitial()) {
    on<SendConsultationEvent>(_onSendConsultation);
    on<DeleteConsultationEvent>(_onDeleteConsultation);
    on<UpdateConsultationEvent>(_onUpdateConsultation);
  }

  Future<void> _onSendConsultation(
    SendConsultationEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    emit(ConsultationLoading());
    try {
      await firestore
          .collection('consultations')
          .doc(event.consultation.id)
          .set(event.consultation.toMap());

      emit(ConsultationSuccess("تم إرسال الاستشارة بنجاح"));
    } catch (e) {
      emit(ConsultationError("حدث خطأ أثناء الإرسال: $e"));
    }
  }

  Future<void> _onDeleteConsultation(
    DeleteConsultationEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    emit(ConsultationLoading());
    try {
      await firestore
          .collection('consultations')
          .doc(event.consultationId)
          .delete();

      emit(ConsultationSuccess('تم حذف الاستشارة بنجاح'));
    } catch (e) {
      emit(ConsultationError('حدث خطأ أثناء الحذف: $e'));
    }
  }

  Future<void> _onUpdateConsultation(
    UpdateConsultationEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    emit(ConsultationLoading());
    try {
      await event.docRef.set(event.consultation.toMap());
      emit(ConsultationSuccess('تم تعديل الاستشارة بنجاح'));
    } catch (e) {
      emit(ConsultationError('حدث خطأ أثناء التعديل: $e'));
    }
  }
}
