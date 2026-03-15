class TripModel {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String tripType;
  final String notes;
  final String imageUrl;
  final double temperature;
  final String weatherIcon; // Add this field
  final List<String> packingList;

  TripModel({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.tripType,
    required this.notes,
    required this.imageUrl,
    required this.temperature,
    required this.weatherIcon, // Add this
    required this.packingList,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'tripType': tripType,
      'notes': notes,
      'imageUrl': imageUrl,
      'temperature': temperature,
      'weatherIcon': weatherIcon, // Add this
      'packingList': packingList,
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'],
      destination: map['destination'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      tripType: map['tripType'],
      notes: map['notes'],
      imageUrl: map['imageUrl'],
      temperature: map['temperature']?.toDouble() ?? 0.0,
      weatherIcon: map['weatherIcon'] ?? '', // Add this
      packingList: List<String>.from(map['packingList']),
    );
  }
}
