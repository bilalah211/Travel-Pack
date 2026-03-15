import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_pack/data/models/user_model.dart';

import '../../utils/app_exceptions/app_exceptions.dart';

class AuthServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //get user

  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email,
      createsAt: Timestamp.now(),
    );
  }

  //User Signup Method

  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw BadRequestException('This email is already registered.');
        case 'weak-password':
          throw ValidationException('Password is too weak.');
        default:
          throw FetchDataException(e.message ?? 'Signup failed.');
      }
    }
  }

  //User Signin Method
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw BadRequestException('Wrong email or password.');
        case 'wrong-password':
          throw UnauthorizedException('Wrong email or password.');
        case 'invalid-credential':
          throw UnauthorizedException('Wrong email or password.');
        default:
          throw FetchDataException(e.message ?? 'Login failed.');
      }
    }
  }

  //User signOut
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
