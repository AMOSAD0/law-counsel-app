import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_prediction_app/features/auth/data/error_handler/auth_exceptions.dart';
abstract class AuthRemoteDataSource {
  Future<User?> signUp(String fullName,String email, String password);
  Future<User?> login(String email, String password);
  Future<User?> getCurrentUserFromFirebase();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<User?> signUp(String fullName,String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email:email,  
        password:password,
      );
      User? user = userCredential.user;
      firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(fullName);
        await user.reload();
        user = firebaseAuth.currentUser;
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthExceptionHandler.handleException(e.code));
    }
  }
  
  @override
  Future<User?> login(String email, String password)async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthExceptionHandler.handleException(e.code));
    }
  
  }
  
  @override
  Future<User?> getCurrentUserFromFirebase(){
    return Future.value(firebaseAuth.currentUser);
  }
  
 

  
}