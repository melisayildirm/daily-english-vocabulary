import 'package:flutter/material.dart';

import '../../models/word_model.dart';
import '../../services/gemini_service.dart';
import '../../services/tts_service.dart';

class WordDetailScreen extends StatefulWidget {
  final WordModel word;

  const WordDetailScreen({
    super.key,
    required this.word,
  });

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  final GeminiService _geminiService = GeminiService();
  final TtsService _ttsService = TtsService();

  String? aiSentence;

  bool isGenerating = false;

  Future<void> generateAISentence() async {
    setState(() {
      isGenerating = true;
    });

    try {
      final sentence = await _geminiService.generateExampleSentence(
        word: widget.word.word,
        level: widget.word.level,
        meaning: widget.word.mainMeaning,
      );

      if (!mounted) return;

      setState(() {
        aiSentence = sentence;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI cümlesi oluşturulamadı: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isGenerating = false;
      });
    }
  }

  Future<void> listenWord() async {
    await _ttsService.speakWord(widget.word.word);
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelime Detayı'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF5C4AE4),
                    Color(0xFF7A66F0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Text(
                    word.word,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    word.mainMeaning,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFA8F0C6),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: listenWord,
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Kelimeyi Dinle'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.white70,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _meaningsCard(word),

            const SizedBox(height: 12),

            _infoCard(
              title: 'Örnek Cümle',
              content: aiSentence ??
                  (word.exampleSentence.isEmpty
                      ? 'AI ile örnek cümle oluşturabilirsin.'
                      : word.exampleSentence),
              icon: Icons.format_quote,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isGenerating ? null : generateAISentence,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C4AE4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  isGenerating
                      ? 'AI düşünüyor...'
                      : 'AI ile Örnek Cümle Oluştur',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            _infoCard(
              title: 'Seviye',
              content: word.level,
              icon: Icons.school,
            ),
          ],
        ),
      ),
    );
  }

  Widget _meaningsCard(WordModel word) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.translate,
                color: Color(0xFFA8F0C6),
              ),
              SizedBox(width: 12),
              Text(
                'Anlamlar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...word.meanings.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF3A3A3A),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.meaning,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F9F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.type,
                      style: const TextStyle(
                        color: Color(0xFF0D4E34),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFFA8F0C6),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}