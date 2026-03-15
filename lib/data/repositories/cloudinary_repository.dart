import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_pack/data/services/cloudinary_services.dart';

import 'firstore_repo.dart';

class CloudinaryRepository {
  final CloudinaryServices _cloudinaryServices = CloudinaryServices();
  final FireStoreRepo _fireStoreRepo = FireStoreRepo();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Pick image from gallery
  Future<File?> pickImageFromCamera() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Upload image to Cloudinary
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    return await _cloudinaryServices.uploadImageToCloudinary(imageFile);
  }

  // Save uploaded image URL to Firestore
  Future<bool> saveImageUrlToFirestore(String url, String name) async {
    final user = _auth.currentUser;
    if (user == null) {
      print("❌ No authenticated user found!");
      return false;
    }

    if (url.isEmpty) {
      print("❌ Invalid URL (empty)");
      return false;
    }

    print("📤 Saving image URL to Firestore for user: ${user.uid}");

    final success = await _fireStoreRepo.updateUserProfile(url, name);
    if (success) {
      print("✅ Firestore update successful!");
    } else {
      print("❌ Firestore update failed!");
    }

    return success;
  }
}
