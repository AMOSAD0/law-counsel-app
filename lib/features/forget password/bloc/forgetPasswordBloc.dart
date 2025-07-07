import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/forget%20password/bloc/forgetPasswordEvent.dart';
import 'package:law_counsel_app/features/forget%20password/bloc/forgetPasswordState.dart';

class Forgetpasswordbloc
    extends Bloc<Forgetpasswordevent, Forgetpasswordstate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Forgetpasswordbloc() : super(const Forgetpasswordstate()) {
    on<ForgetpasswordSubmitted>(_onForgetpasswordSubmitted);
  }

  Future<void> _onForgetpasswordSubmitted(
    ForgetpasswordSubmitted event,
    Emitter<Forgetpasswordstate> emit,
  ) async {
    emit(state.copyWith(status: Forgetpasswordstatus.loading));
    try {
      await _auth.sendPasswordResetEmail(email: event.email);
      emit(state.copyWith(status: Forgetpasswordstatus.success));
    } on FirebaseAuthException catch (e) {
      String? errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'البريد الإلكتروني غير صالح';
          break;
        case 'user-not-found':
          errorMessage = 'لا يوجد حساب مرتبط بهذا البريد';
          break;
        default:
          errorMessage = 'حدث خطأ: ${e.message}';
      }
      emit(
        state.copyWith(
          status: Forgetpasswordstatus.failure,
          error: errorMessage,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Forgetpasswordstatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
