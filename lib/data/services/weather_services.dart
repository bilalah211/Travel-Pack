import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:travel_pack/data/models/weather_model.dart';
import 'package:travel_pack/utils/helpers/api_keys/api_keys.dart';

class WeatherServices {
  Future<WeatherModel?> getTemperature(String destination) async {
    try {
      final url = Uri.parse(ApiKeys.buildWeatherUrl(destination));

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final weather = WeatherModel.fromMap(data);

        return weather;
      } else {
        if (response.statusCode == 401) {
          print(response.statusCode);
          throw 'Invalid API Key - Please check your OpenWeatherMap API key';
        } else if (response.statusCode == 404) {
          throw 'City "$destination" not found. Please check the spelling.';
        } else if (response.statusCode == 429) {
          throw 'API rate limit exceeded. Please try again later.';
        } else {
          throw 'HTTP Error ${response.statusCode}: ${response.body}';
        }
      }
    } catch (e) {
      debugPrint('Exception caught: $e');
      debugPrint('Stack trace: ${e.toString()}');
      rethrow;
    }
    return null;
  }
}
