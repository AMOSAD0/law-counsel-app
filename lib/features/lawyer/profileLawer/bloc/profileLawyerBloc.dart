import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/core/helper/UploadImage.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerEvent.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerState.dart';

class LawyerProfileBloc extends Bloc<LawyerProfileEvent, LawyerProfileState> {
  final FirebaseFirestore firestore;

  static const String _commissionCollection = 'configPlatform';
  static const String _commissionDoc = 'commission';

  LawyerProfileBloc({required this.firestore})
      : super(const LawyerProfileState()) {
    on<GetLawyerProfile>(_onGetLawyerProfile);
    on<UpdateLawyerProfile>(_onUpdateProfile);
  }

  Future<void> _onGetLawyerProfile(
    GetLawyerProfile event,
    Emitter<LawyerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final doc = await firestore.collection('lawyers').doc(event.lawyerId).get();

      if (!doc.exists) {
        emit(state.copyWith(isLoading: false, error: 'المحامي غير موجود'));
        return;
      }

      final lawyerData = doc.data() ?? {};
      final updatedLawyerData = Map<String, dynamic>.from(lawyerData);

      final configDoc =
          await firestore.collection(_commissionCollection).doc(_commissionDoc).get();
      final commission = (configDoc.data()?['commissionPercentage'] ?? 0).toDouble();

      double netPrice = 0;
      if (updatedLawyerData['price'] != null) {
        final price = (updatedLawyerData['price'] ?? 0).toDouble();
        netPrice = price - (price * commission);
        updatedLawyerData['netPrice'] = netPrice;
      }

      final balance = (updatedLawyerData['balance'] ?? 0).toDouble();
      updatedLawyerData['balance'] = balance;

      emit(state.copyWith(
        isLoading: false,
        lawyerData: updatedLawyerData,
        netPrice: netPrice,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateLawyerProfile event,
    Emitter<LawyerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));

    try {
      final updatedData = Map<String, dynamic>.from(event.updatedData);

      if (event.profileImg != null) {
        final String? profileImageUrl =
            await ImageUploadHelper.uploadImageToKit(event.profileImg!);
        if (profileImageUrl != null) {
          updatedData['profileImageUrl'] = profileImageUrl;
        }
      }

      if (updatedData.containsKey('price')) {
        final configDoc =
            await firestore.collection(_commissionCollection).doc(_commissionDoc).get();
        final commission = (configDoc.data()?['commissionPercentage'] ?? 0).toDouble();

        final price = (updatedData['price'] ?? 0).toDouble();
        final netPrice = price - (price * commission);
        updatedData['netPrice'] = netPrice;
      }

      await firestore.collection('lawyers').doc(event.lawyerId).update(updatedData);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateLawyerBalance(String lawyerId, double amount) async {
    final lawyerDocRef = firestore.collection('lawyers').doc(lawyerId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(lawyerDocRef);
      if (!snapshot.exists) return;

      final currentBalance = (snapshot.data()?['balance'] ?? 0).toDouble();
      final newBalance = currentBalance + amount;

      transaction.update(lawyerDocRef, {'balance': newBalance});
    });
  }
}
