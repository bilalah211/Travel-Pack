import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:travel_pack/data/repositories/cloudinary_repository.dart';
import 'package:travel_pack/data/repositories/firstore_repo.dart';

class CloudinaryViewModel with ChangeNotifier {
  final CloudinaryRepository _cloudinaryRepo = CloudinaryRepository();
  final FireStoreRepo _fireStoreRepo = FireStoreRepo();

  File? pickedImage;
  String? uploadedImageUrl;
  String userName = '';

  // Load user data
  Future<void> loadUserData() async {
    final userData = await _fireStoreRepo.getUserData();
    if (userData != null) {
      userName = userData.displayName ?? '';
      uploadedImageUrl = userData.photoUrl;
      notifyListeners();
    }
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final image = await _cloudinaryRepo.pickImageFromGallery();
    if (image != null) {
      pickedImage = image;
      notifyListeners();
    }
  }

  // Pick image from camera

  Future<void> pickImageFromCamera() async {
    final image = await _cloudinaryRepo.pickImageFromCamera();
    if (image != null) {
      pickedImage = image;
      notifyListeners();
    }
  }

  // Upload image
  Future<String?> uploadImage() async {
    if (pickedImage == null) return null;

    final url = await _cloudinaryRepo.uploadImageToCloudinary(pickedImage!);
    if (url != null) {
      // 🔹 Load latest user data before updating
      final userData = await _fireStoreRepo.getUserData();
      final currentName = userData?.displayName ?? userName;

      // 🔹 Update Firestore with current name + new photo URL
      final success = await _fireStoreRepo.updateUserProfile(currentName, url);

      if (success) {
        uploadedImageUrl = url;
        pickedImage = null;
        await loadUserData();
        notifyListeners();
        print('✅ Firestore updated with new photoUrl');
      } else {
        print('❌ Firestore update failed after upload');
      }
    } else {
      print('❌ Cloudinary upload failed');
    }

    return url;
  }

  // Update profile (name + photo)
  Future<bool> updateProfile(String name, String photo) async {
    final success = await _fireStoreRepo.updateUserProfile(name, photo);
    if (success) {
      userName = name;
      uploadedImageUrl = photo;
      await loadUserData();
      notifyListeners();
    }
    return success;
  }

  Future<bool> deleteImage() async {
    try {
      final success = await _fireStoreRepo.deleteImage();
      if (success) {
        // Clear local state
        uploadedImageUrl = null;
        pickedImage = null;
        await loadUserData();
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}
