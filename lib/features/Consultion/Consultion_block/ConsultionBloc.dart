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
    on<UpdatePaymentStatusEvent>(_onUpdatePaymentStatus); 
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

      await firestore
      .collection("payments")
      .add({
      "clientId":event.consultation.userId,
      "consultationId": event.consultation.id,
      "lawyerId": event.consultation.lawyerId,
      "createdAt": FieldValue.serverTimestamp(),
      "amount": event.consultation.amount ?? 500,
      "status": "escrow", // escrow, released, refunded
      });

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
      await event.docRef.delete();

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
  Future<void> _onUpdatePaymentStatus(
  UpdatePaymentStatusEvent event,
  Emitter<ConsultationState> emit,
) async {
  emit(ConsultationLoading());
  try {
    await event.docRef.update({'paid': event.paid});

    final updatedDoc = await event.docRef.get();
    final consultationData = updatedDoc.data() as Map<String, dynamic>;

    final lawyerId = consultationData['lawyerId'] as String?;

    if (lawyerId == null) {
      emit(ConsultationError('لا يوجد معرف محامي صالح'));
      return;
    }

    final lawyerDocRef = firestore.collection('lawyers').doc(lawyerId);
    final lawyerDoc = await lawyerDocRef.get();

    if (!lawyerDoc.exists) {
      emit(ConsultationError('المحامي غير موجود'));
      return;
    }

    final lawyerData = lawyerDoc.data()!;
    final price = (lawyerData['price'] ?? 0).toDouble();
    final currentBalance = (lawyerData['balance'] ?? 0).toDouble();

    if (price <= 0) {
      emit(ConsultationError('السعر غير صالح أو صفر'));
      return;
    }

    final configDoc = await firestore.collection('configPlatform').doc('commission').get();
    final commissionPercentage = (configDoc.data()?['commissionPercentage'] ?? 0).toDouble();

    final netAmount = price * (1 - commissionPercentage);

    final newBalance = currentBalance + netAmount;

    await lawyerDocRef.update({'balance': newBalance});

    final platformBalanceRef = firestore.collection('platform').doc('balance');
    final platformDoc = await platformBalanceRef.get();
    double currentPlatformBalance = 0;

    if (platformDoc.exists) {
      currentPlatformBalance = (platformDoc.data()?['balance'] ?? 0).toDouble();
    }

    final newPlatformBalance = currentPlatformBalance + (price * commissionPercentage);

    await platformBalanceRef.set({'balance': newPlatformBalance});

    emit(ConsultationSuccess('تم تحديث حالة الدفع ورصيد المحامي ورصيد المنصة بنجاح'));
  } catch (e) {
    emit(ConsultationError('حدث خطأ أثناء تحديث الدفع: $e'));
  }
}



//  Future<void> _onUpdatePaymentStatus(
//   UpdatePaymentStatusEvent event,
//   Emitter<ConsultationState> emit,
// ) async {
//   emit(ConsultationLoading());
//   try {
//     await event.docRef.update({'paid': event.paid});

//     final updatedDoc = await event.docRef.get();
//     final consultationData = updatedDoc.data() as Map<String, dynamic>;

//     final lawyerId = consultationData['lawyerId'] as String?;
//     final price = (consultationData['price'] ?? 0).toDouble();

//     print('lawyerId: $lawyerId, price: $price'); // طباعة التشخيص

//     if (lawyerId != null && lawyerId.isNotEmpty && price > 0) {
//       final lawyerDocRef = firestore.collection('lawyers').doc(lawyerId);
//       final lawyerDoc = await lawyerDocRef.get();

//       if (lawyerDoc.exists) {
//         final lawyerData = lawyerDoc.data()!;
//         final currentBalance = (lawyerData['balance'] ?? 0).toDouble();

//         print('currentBalance before update: $currentBalance');

//         final newBalance = currentBalance + price;
//         await lawyerDocRef.update({'balance': newBalance});

//         print('newBalance after update: $newBalance');
//       } else {
//         print('lawyer document does not exist');
//       }
//     } else {
//       print('Invalid lawyerId or price');
//     }

//     emit(ConsultationSuccess('تم تحديث حالة الدفع ورصيد المحامي بنجاح'));
//   } catch (e) {
//     print('Error in _onUpdatePaymentStatus: $e');
//     emit(ConsultationError('حدث خطأ أثناء تحديث الدفع: $e'));
//   }
// }

}
