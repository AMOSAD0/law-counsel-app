import 'package:hive/hive.dart';
import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel ?user);
  Future<UserModel?> getCacheUser();
  Future<void> deleteCacheUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box _userBox;
  AuthLocalDataSourceImpl(this._userBox);

  @override
  Future<void> cacheUser(UserModel ?user) async {
    await _userBox.put('user', user);
  }

  @override
  Future<UserModel?> getCacheUser() async {
    return _userBox.get('user');
  }

  @override
  Future<void> deleteCacheUser() async {
    await _userBox.delete('user');
  }
}