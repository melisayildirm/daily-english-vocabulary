import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speakWord(String word) async {
    await _tts.setLanguage('en-US');

    await _tts.setVolume(1.0); // maksimum ses
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.05);

    await _tts.stop();
    await _tts.speak(word);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}