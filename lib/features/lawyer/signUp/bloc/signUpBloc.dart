import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/core/helper/image_upload_helper.dart';
import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';
import 'package:law_counsel_app/features/lawyer/signUp/bloc/signUpEvent.dart';
import 'package:law_counsel_app/features/lawyer/signUp/bloc/signUpState.dart';

class SignUpLawerBloc extends Bloc<SignUpLawyerEvent, SignUpLawyerState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignUpLawerBloc() : super(const SignUpLawyerState()) {
    on<SignUpLawyerSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpLawyerSubmitted event,
    Emitter<SignUpLawyerState> emit,
  ) async {
    emit(state.copyWith(status: SignUpLawyerStatus.loading));

    try {
      // Step 1: Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.lawyer.email,
        password: event.password,
      );

      final uid = userCredential.user!.uid;

      final String? idImageUrl = await ImageUploadHelper.uploadImageToKit(
        event.idImg,
      );

      final String ? barImageUrl = await ImageUploadHelper.uploadImageToKit(event.barImg);

      // Step 2: Save lawyer data to Firestore
      final lawyer = event.lawyer;

      final lawyerWithId = Lawyer(
        id: uid,
        name: lawyer.name,
        email: lawyer.email,
        phoneNumber: lawyer.phoneNumber,
        city: lawyer.city,
        birthDate: lawyer.birthDate,
        profileImageUrl: lawyer.profileImageUrl,
        idImageUrl: idImageUrl,
        barAssociationImageUrl: barImageUrl,
        specializations: lawyer.specializations,
        isApproved: false,
        rating: 0.0
      );
      await _firestore
          .collection('lawyers')
          .doc(uid)
          .set(lawyerWithId.toJson());

      emit(state.copyWith(status: SignUpLawyerStatus.success));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(status: SignUpLawyerStatus.failure, error: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SignUpLawyerStatus.failure, error: e.toString()),
      );
    }
  }
}
