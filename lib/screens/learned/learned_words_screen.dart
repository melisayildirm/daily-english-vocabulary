import 'package:flutter/material.dart';
import '../../models/word_model.dart';
import '../../services/word_service.dart';

class LearnedWordsScreen extends StatelessWidget {
  const LearnedWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WordModel> learnedWords =
        WordService.getLearnedWords();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenilen Kelimeler'),
        centerTitle: true,
      ),
      body: learnedWords.isEmpty
          ? const Center(
              child: Text('Henüz öğrenilen kelime yok'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: learnedWords.length,
              itemBuilder: (context, index) {
                final word = learnedWords[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      word.word,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(word.mainMeaning),
                  ),
                );
              },
            ),
    );
  }
}