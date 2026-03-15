import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:travel_pack/data/models/geminiAi_model.dart';
import 'package:travel_pack/utils/helpers/api_keys/api_keys.dart';

class GeminiAiServices {
  Future<GeminiAiModel?> generateText(String destination, String temp) async {
    try {
      String apiUrl = ApiKeys.geminiApiUrl();
      final url = Uri.parse(apiUrl);
      print(url);
      final String prompt =
          'Generate a simple packing list for $destination with temperature ${temp}°C. '
          'Include basic clothing AND essential electronics/items. '
          'Return ONLY item names as a simple comma-separated list. '
          'Must include: sweaters, warm jacket, long sleeves, trousers, underwear, socks, '
          'power bank, mobile, passwords, IDs, watches. '
          'Keep it very simple - no explanations, no categories, no bullet points. '
          'Example format: "sweater, warm jacket, long sleeves, trousers, underwear, socks, power bank, mobile, IDs, watches"';
      final response = await http.post(
        url,

        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return GeminiAiModel.fromJson(data);
      } else {
        print("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }
}
