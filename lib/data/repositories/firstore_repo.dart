import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_pack/data/models/user_model.dart';

class FireStoreRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final snapshot = await _firestore
          .collection('users')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  Future<bool> updateUserProfile(String name, String photo) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await _firestore.collection('users').doc(user!.uid).update({
        'displayName': name,
        'photoUrl': photo,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  Future<bool> deleteImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      await _firestore.collection('users').doc(user!.uid).update({
        'photoUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print("Profile image removed from Firestore");
      return true;
    } catch (e) {
      print("Error deleting image: $e");
      return false;
    }
  }
}
