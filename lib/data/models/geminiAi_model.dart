class GeminiAiModel {
  final String? generatedText;

  GeminiAiModel({this.generatedText});

  factory GeminiAiModel.fromJson(Map<String, dynamic> json) {
    try {
      final text =
          json['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
      return GeminiAiModel(generatedText: text);
    } catch (e) {
      print('🔴 Error parsing Gemini response: $e');
      return GeminiAiModel(generatedText: null);
    }
  }
}
