import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:travel_pack/data/models/trip_model.dart';
import 'package:http/http.dart' as http;
import '../../utils/helpers/api_keys/api_keys.dart';

class ImageServices {
  Future<String> getImages(String destination) async {
    String accessKey = ApiKeys.accessKey;
    String url =
        '${ApiKeys.uEndPoint}?query=$destination&per_page=1&orientation=landscape&client_id=$accessKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print(response.statusCode);
        final data = jsonDecode(response.body);

        final imageUrl = (data['results'] as List).isNotEmpty
            ? data['results'][0]['urls']['regular']
            : 'https://via.placeholder.com/300';
        print(imageUrl);
        return imageUrl;
      } else {
        return 'https://via.placeholder.com/300';
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}
