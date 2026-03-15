import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final Timestamp createsAt;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.createsAt,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      Timestamp createdAt;
      if (map['createdAt'] == null || map['createdAt'].toString().isEmpty) {
        createdAt = Timestamp.now();
      } else if (map['createdAt'] is Timestamp) {
        createdAt = map['createdAt'];
      } else {
        try {
          if (map['createdAt'] is String) {
            final date = DateTime.parse(map['createdAt']);
            createdAt = Timestamp.fromDate(date);
          } else {
            createdAt = Timestamp.now();
          }
        } catch (e) {
          print('Failed to parse createdAt, using current time: $e');
          createdAt = Timestamp.now();
        }
      }

      return UserModel(
        uid: map['uid']?.toString() ?? '',
        email: map['email']?.toString(),
        displayName: map['displayName']?.toString(),
        photoUrl: map['photoUrl']?.toString(),
        createsAt: createdAt,
      );
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createsAt,
    };
  }
}
