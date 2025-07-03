import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';


part 'user_model.g.dart';
@HiveType(typeId: 32)
class UserModel extends HiveObject{
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String?name;
  
  UserModel({required this.uid, required this.email, required this.name,});

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      name: user.displayName ?? '',
    );
  }
}
