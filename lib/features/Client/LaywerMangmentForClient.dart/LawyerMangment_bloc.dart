import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/LawyerMangment_bloc/LawyerMangment_Event.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/LawyerMangment_bloc/LawyerMangment_State.dart';
import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';

class LawyerManagementBloc
    extends Bloc<LawyerManagementEvent, LawyerManagementState> {
  final FirebaseFirestore _firestore;

  LawyerManagementBloc(this._firestore) : super(LawyerManagementInit()) {
    on<LawyerLoadByCategoryEvent>((event, emit) async {
      emit(LawyerManagementLoading());
      try {
        final snapshot = await _firestore
            .collection("lawyers")
            .where('specializations', arrayContains: event.category)
            .get();

        final lawyers = snapshot.docs.map((doc) {
          final data = doc.data();
          print(data);
          return Lawyer.fromJson(data);
        }).toList();

        emit(LawyerManagementLoaded(lawyers));
      } catch (e) {
        emit(LawyerManagementError(e.toString()));
      }
    });
  }
}
