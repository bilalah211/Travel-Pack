import 'package:travel_pack/data/models/weather_model.dart';

import 'geminiAi_model.dart';

class TripImageModel {
  final WeatherModel weather;
  final String imageUrl;
  final GeminiAiModel textGenerator;

  TripImageModel({
    required this.textGenerator,
    required this.weather,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'weather': weather.toMap(),
      'imageUrl': imageUrl,
      'textGenerator': textGenerator,
    };
  }
}
