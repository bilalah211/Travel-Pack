class ApiKeys {
  //-------Unsplash AccessKey And Urls-----//

  //Urls
  static const String uBaseUrl = 'https://api.unsplash.com/';
  static final String uEndPoint = '${uBaseUrl}search/photos';

  //Access Key
  static const String accessKey = 'YOURACCESSKEY';

  //-------OpenWeather ApiKey And Urls-----//

  //Urls
  static const String wBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  //ApiKey
  static const String wApiKey = 'YOURAPIKEY';

  //Complete URL
  static String buildWeatherUrl(String city) {
    return '$wBaseUrl?q=$city&units=metric&appid=$wApiKey';
  }

  //-------OpenAi ChatGPT ApiKey And Urls-----//

  static const String openAiChatGPTBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String openAiChatGPTApiKey = 'YOUR API KEY';

  //-------Gemini ApiKey And Urls-----//

  //Gemini ApiKey
  static const String apiKey = 'YOURAPIKEY';

  //Complete URL
  static String geminiApiUrl() {
    return 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey';
  }

  //-------Cloudinary ApiKey And Url -----//
  static const String cApiKey = 'YOURAPIKEY';
  static const String cloudName = 'dcryvjale';
  static const uploadPreset = "profile";
  static String cUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}
