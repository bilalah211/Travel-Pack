import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_pack/data/models/user_model.dart';

import '../../utils/app_exceptions/app_exceptions.dart';
import '../models/trip_model.dart';

class FireStoreServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  //---------Save and Get data from Firestore-------//

  //SIGNUP
  Future<void> saveUser(
    Map<String, dynamic> data,
    String collection,
    String documentId,
  ) async {
    try {
      await _firestore.collection(collection).doc(documentId).set(data);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Error saving user data.');
    } catch (e) {
      throw FetchDataException('Something went wrong.');
    }
  }

  //LOGIN
  Future<UserModel?> getUserData(String uid) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Error Getting user data.');
    } catch (e) {
      throw FetchDataException('Something went wrong.');
    }
  }

  //User signOut
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //---------Get data from Trips Collection-------//

  Future<List<TripModel>?> getAllTrips() async {
    try {
      final snapshot = await _firestore.collection('trips').get();
      return snapshot.docs.map((doc) => TripModel.fromMap(doc.data())).toList();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
