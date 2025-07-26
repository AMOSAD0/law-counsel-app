import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Client/auth/data/ModelClient.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_state.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileclientBloc extends Bloc<ProfileClientEvent, ProfileClientState> {
  ProfileclientBloc() : super(ProfileClientInitial()) {
    on<ProfileClientLoadEvent>((event, emit) async {
      emit(ProfileClientLoading());
      try {
        final userId = await _getUserId();
        if (userId == null) {
          emit(ProfileClientError("لم يتم العثور على معرف المستخدم."));
          return;
        }

        final doc = await FirebaseFirestore.instance
            .collection("clients")
            .doc(userId)
            .get();

        if (doc.exists) {
          final client = ClientModel.fromJson(doc.data()!);
          emit(ProfileClientLoaded(client));
        } else {
          emit(ProfileClientError("المستخدم غير موجود"));
        }
      } catch (e) {
        emit(ProfileClientError("خطأ أثناء تحميل البيانات: ${e.toString()}"));
      }
    });

    on<ProfileClientImageUpdateEvent>((event, emit) async {
      emit(ProfileClientLoading());
      try {
        final userId = await _getUserId();
        if (userId == null) {
          emit(ProfileClientError("لم يتم العثور على المستخدم."));
          return;
        }

        await FirebaseFirestore.instance
            .collection("clients")
            .doc(userId)
            .update({"imageUrl": event.imageUrl});


        add(ProfileClientLoadEvent());

      } catch (error) {
        emit(ProfileClientError("خطأ أثناء تحديث الصورة: ${error.toString()}"));
      }
    });


    on<ProfileClientDeleteEvent>((event, emit) async {
      try {
        final userId = await _getUserId();
        if (userId == null) {
          emit(ProfileClientError("لم يتم العثور على المستخدم."));
          return;
        }

        /// Soft Delete
        await FirebaseFirestore.instance
            .collection("clients")
            .doc(userId)
            .update({"isDelete": true});

        emit(ProfileClientSuccess("تم حذف الحساب بنجاح"));

     
        // await FirebaseFirestore.instance.collection("clients").doc(userId).delete();
      } catch (error) {
        emit(ProfileClientError("فشل حذف الحساب: ${error.toString()}"));
      }
    });

    on<ProfileClientLogoutEvent>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('userId');
        emit(ProfileClientSuccess("تم تسجيل الخروج بنجاح"));
      } catch (error) {
        emit(ProfileClientError("فشل تسجيل الخروج: ${error.toString()}"));
      }
    });
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }
}
