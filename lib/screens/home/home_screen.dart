import 'package:flutter/material.dart';
import '../../models/word_model.dart';
import '../../services/word_service.dart';
import '../learned/learned_words_screen.dart';

class HomeScreen extends StatefulWidget {
  final String selectedLevel;
  final int dailyWordCount;

  const HomeScreen({
    super.key,
    required this.selectedLevel,
    required this.dailyWordCount,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> learnedWordIds = {};

  @override
  Widget build(BuildContext context) {
    final List<WordModel> words = WordService.getWordsByLevel(
      widget.selectedLevel,
      widget.dailyWordCount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedLevel} Günlük Kelimeler'),
        centerTitle: true,
      ),
      body: words.isEmpty
          ? const Center(
              child: Text('Bu seviyeye ait kelime bulunamadı.'),
            )
          : Column(
              children: [
                const SizedBox(height: 12),

                Text(
                  '${learnedWordIds.length} / ${words.length} tamamlandı',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: learnedWordIds.length / words.length,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      final bool isLearned = learnedWordIds.contains(word.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word.word,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                word.meaning,
                                style: const TextStyle(fontSize: 16),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                word.exampleSentence,
                                style: const TextStyle(fontSize: 14),
                              ),

                              const SizedBox(height: 12),

                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (isLearned) {
                                        learnedWordIds.remove(word.id);
                                        WordService.learnedWords.removeWhere(
                                          (w) => w.id == word.id,
                                        );
                                      } else {
                                        learnedWordIds.add(word.id);
                                        WordService.addLearnedWord(word);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    isLearned
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                  ),
                                  label: Text(
                                    isLearned ? 'Öğrenildi' : 'Öğrendim',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LearnedWordsScreen(),
                              ),
                            );
                          },
                          child: const Text('Öğrenilen Kelimeleri Gör'),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Ana Sayfaya Dön'),
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