import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileImageModel {
  final String id;
  final String profileImage;
  final DateTime uploadedAt;

  ProfileImageModel({
    required this.id,
    required this.profileImage,
    required this.uploadedAt,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'profileImage': profileImage, 'uploadedAt': uploadedAt};
  }

  factory ProfileImageModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return ProfileImageModel(
      id: documentId,
      profileImage: map['profileImage'] ?? '',
      uploadedAt: (map['uploadedAt'] as Timestamp).toDate(),
    );
  }
}
