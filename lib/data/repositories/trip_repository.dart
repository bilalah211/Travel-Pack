import 'package:travel_pack/data/models/trip_model.dart';
import 'package:travel_pack/data/services/firestore_services.dart';
import 'package:travel_pack/data/services/geminiAi_services.dart';
import 'package:uuid/uuid.dart';
import '../services/image_services.dart';
import '../services/weather_services.dart';

class TripRepository {
  //Variables
  final _imageServices = ImageServices();
  final _weatherServices = WeatherServices();
  final _geminiServices = GeminiAiServices();
  final _fireStoreServices = FireStoreServices();

  //-------Generate And Save Data ------//
  Future<TripModel?> generateAndSaveData(
    String destination,
    DateTime startDate,
    DateTime endDate,
    String tripType,
    String notes,
  ) async {
    try {
      final uuid = Uuid();
      final _image = await _imageServices.getImages(destination);
      final _weather = await _weatherServices.getTemperature(destination);

      if (_weather == null) return null;
      final _geminiTextGenerator = await _geminiServices.generateText(
        destination,
        _weather.temperature.toStringAsFixed(1),
      );

      if (_geminiTextGenerator == null ||
          _geminiTextGenerator.generatedText == null) {
        return null;
      }

      final tripId = uuid.v1();
      final data = TripModel(
        id: tripId,
        destination: destination,
        startDate: startDate,
        endDate: endDate,
        tripType: tripType,
        notes: notes,
        imageUrl: _image,
        temperature: _weather.temperature,
        packingList: _extractPackingList(_geminiTextGenerator.generatedText!),
        weatherIcon: _weather.icon,
      );
      // Convert to map and print it
      final dataMap = data.toMap();
      await _fireStoreServices.saveUser(dataMap, 'trips', tripId);

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  //-------Extract Packing List ------//

  List<String> _extractPackingList(String generatedText) {
    if (generatedText.isEmpty) return [];

    // Split by new lines and filter out empty lines
    return generatedText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceAll('•', '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  //-------Get All Data ------//

  Future<List<TripModel>?> getAllData() async {
    final trips = await _fireStoreServices.getAllTrips();
    return trips;
  }
}
