import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:travel_pack/utils/helpers/api_keys/api_keys.dart';

class CloudinaryServices {
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(ApiKeys.cUrl))
        ..fields['upload_preset'] = ApiKeys.uploadPreset
        ..fields['folder'] = 'profile'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resData = await response.stream.bytesToString();
        final data = json.decode(resData);

        print("✅ Upload successful!");
        print("Image URL: ${data['secure_url']}");
        print("Public ID: ${data['public_id']}");

        return data['secure_url']; //
      } else {
        print("❌ Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception during upload: $e");
      return null;
    }
  }
}
