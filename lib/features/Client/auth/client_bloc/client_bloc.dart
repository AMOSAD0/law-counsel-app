import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_event.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_state.dart';
import 'package:law_counsel_app/features/Client/auth/data/ModelClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ClientBloc() : super(ClientInitial()) {
    on<ClientRegisterEvent>((event, emit) async {
      emit(ClientLoading());
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );

        final uid = userCredential.user!.uid;

        final client = ClientModel(
          id: uid,
          name: event.name,
          email: event.email,
          phone: event.phone,
          password: event.password,
          isDelete: false,
        );

        await FirebaseFirestore.instance
            .collection('clients')
            .doc(uid)
            .set(client.toJson());

        emit(ClientLoaded(client: client));
      } catch (e) {
        emit(ClientError(message: e.toString()));
      }
    });
    on<ClientLoginEvent>((event, emit) async {
      emit(ClientLoading());
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final uid = userCredential.user!.uid;

        final prefs = await SharedPreferences.getInstance();
       
        print('UID Logged in: $uid');

        DocumentSnapshot clientDoc =
            await FirebaseFirestore.instance
                .collection('clients')
                .doc(uid)
                .get();

        if (clientDoc.exists) {
          await prefs.setString('uid', uid);
          await prefs.setString('userType', 'client');
          emit(IsClient());
          return;
        }

        DocumentSnapshot lawyerDoc =
            await FirebaseFirestore.instance
                .collection('lawyers')
                .doc(uid)
                .get();

        if (lawyerDoc.exists) {
          await prefs.setString('uid', uid);
          await prefs.setString('userType', 'lawyer');
          emit(IsLawyer());
        } else {
          emit(ClientError(message: 'Client not found'));
        }
      } catch (e) {
        emit(ClientError(message: e.toString()));
      }
    });
    on<ClientLogoutEvent>((event, emit) async {
      try {
        await _auth.signOut();
        emit(ClientInitial());
      } catch (e) {
        emit(ClientError(message: e.toString()));
      }
    });
  }
}
