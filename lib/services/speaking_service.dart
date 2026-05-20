import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeakingService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speech = SpeechToText();

  Future<void> initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
  }

  Future<void> speakWord(String word) async {
    await _tts.stop();
    await _tts.speak(word);
  }

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  Future<void> listen({
    required Function(String text) onResult,
  }) async {
    final available = await initSpeech();

    if (!available) {
      onResult("Mikrofon kullanılamıyor");
      return;
    }

    await _speech.listen(
      localeId: "en_US",
      listenFor: const Duration(seconds: 4),
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool isCorrectPronunciation({
    required String targetWord,
    required String spokenText,
  }) {
    return targetWord.toLowerCase().trim() ==
        spokenText.toLowerCase().trim();
  }
}