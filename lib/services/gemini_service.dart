import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
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
- Do not add extra explanation.
- Response format:

English: ...
Turkish: ...
''';

    try {
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);

      final text = response.text?.trim();

      if (text == null || text.isEmpty) {
        return 'Örnek cümle üretilemedi. Lütfen tekrar dene.';
      }

      return text;
    } on GenerativeAIException catch (e) {
      if (e.message.contains('503') ||
          e.message.toLowerCase().contains('high demand') ||
          e.message.toLowerCase().contains('unavailable')) {
        return 'AI şu anda yoğun olduğu için örnek cümle oluşturulamadı. Lütfen biraz sonra tekrar dene.';
      }

      return 'AI cümlesi oluşturulurken bir hata oluştu: ${e.message}';
    } catch (e) {
      return 'Beklenmeyen bir hata oluştu. Lütfen tekrar dene.';
    }
  }
}