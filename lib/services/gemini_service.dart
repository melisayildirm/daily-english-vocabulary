import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: apiKey,
    );
  }

  Future<String> generateExampleSentence({
    required String word,
    required String level,
    required String meaning,
  }) async {
    if (apiKey.isEmpty) {
      return 'Gemini API key bulunamadı.';
    }

    final prompt = '''
Create one English example sentence for this word.

Word: $word
Turkish meaning: $meaning
Level: $level

Rules:
- Write ONE natural English sentence.
- Then write the Turkish translation.
- Keep it suitable for $level level.
- Response format:

English: ...
Turkish: ...
''';

    final response = await _model.generateContent([
      Content.text(prompt),
    ]);

    return response.text?.trim() ?? 'Örnek cümle üretilemedi.';
  }
}