// lawyer_profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/core/helper/UploadImage.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerEvent.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerState.dart';


class LawyerProfileBloc extends Bloc<LawyerProfileEvent, LawyerProfileState> {
  final FirebaseFirestore firestore;

  LawyerProfileBloc({required this.firestore}) : super(const LawyerProfileState()) {
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

      if (doc.exists) {
        emit(state.copyWith(isLoading: false, lawyerData: doc.data()));
      } else {
        emit(state.copyWith(isLoading: false, error: 'المحامي غير موجود'));
      }
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
      if (event.profileImg != null) {
        final String? profileImageUrl = await ImageUploadHelper.uploadImageToKit(
          event.profileImg!,
        );
        event.updatedData['profileImageUrl'] = profileImageUrl;
      }
     
      await firestore.collection('lawyers').doc(event.lawyerId).update(event.updatedData);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}


