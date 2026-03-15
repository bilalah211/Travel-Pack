import 'package:flutter/material.dart';
import 'package:travel_pack/data/models/trip_model.dart';
import 'package:travel_pack/data/models/trip_weatherandimage_model.dart';
import 'package:travel_pack/data/repositories/trip_repository.dart';

import '../data/models/geminiAi_model.dart';
import '../data/models/weather_model.dart';

class TripViewModel with ChangeNotifier {
  final TripRepository _repo = TripRepository();

  TripModel? _tripData;
  TripModel? get tripData => _tripData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Generate And Save Trip Data
  Future<TripModel?> generateAndSaveTripData(
    String destination,
    DateTime startDate,
    DateTime endDate,
    String tripType,
    String notes,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repo.generateAndSaveData(
        destination,
        startDate,
        endDate,
        tripType,
        notes,
      );
      if (data != null) {
        _tripData = data;
      } else {
        _error = "No data found";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  // Fetch All Trips Data

  Future<List<TripModel>?> fetchAllTripsData() async {
    final trips = await _repo.getAllData();
    return trips;
  }
}
