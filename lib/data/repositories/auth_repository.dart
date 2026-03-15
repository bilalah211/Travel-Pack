import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_pack/data/models/user_model.dart';
import 'package:travel_pack/data/services/auth_services.dart';
import 'package:travel_pack/data/services/firestore_services.dart';

import '../../utils/app_exceptions/app_exceptions.dart';

class AuthRepository {
  AuthServices _authServices = AuthServices();
  FireStoreServices _fireStoreServices = FireStoreServices();

  Future<UserModel?> signUp(
    String email,
    String password,
    String displayName,
    String? photoUrl,
    String createdAt,
  ) async {
    try {
      final user = await _authServices.signUp(email, password);
      if (user != null) {
        final newUser = UserModel(
          uid: user.uid,
          email: email,
          displayName: displayName,
          photoUrl: photoUrl,
          createsAt: Timestamp.now(),
        );
        await _fireStoreServices.saveUser(newUser.toMap(), 'users', user.uid);
        return newUser;
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchDataException('Unexpected error during signup.');
    }
    return null;
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      final user = await _authServices.signIn(email, password);
      if (user != null) {
        return await _fireStoreServices.getUserData(user.uid);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchDataException('Unexpected error during login.');
    }
    return null;
  }

  //User signOut
  Future<void> signOut() async {
    await _fireStoreServices.signOut();
  }
}
