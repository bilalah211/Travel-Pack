class WeatherModel {
  final double temperature;
  final String icon;

  WeatherModel({required this.temperature, required this.icon});

  factory WeatherModel.fromMap(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'temperature': temperature, 'icon': icon};
  }
}
