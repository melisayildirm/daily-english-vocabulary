import 'package:flutter/material.dart';
import '../../models/word_model.dart';
import '../../services/word_service.dart';
import '../learned/learned_words_screen.dart';
import '../quiz/quiz_screen.dart';
import '../profile/profile_screen.dart';
import '../word_detail/word_detail_screen.dart';

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

    final int totalWords = words.length;
    final int learnedCount = learnedWordIds.length;
    final double progress = totalWords == 0 ? 0 : learnedCount / totalWords;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF5C4AE4),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.selectedLevel} Seviyesi',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bugün ${widget.dailyWordCount} kelime öğren',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Günlük ilerleme',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              '$learnedCount / $totalWords',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: Colors.white24,
                            color: const Color(0xFFA8F0C6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _statBox('$learnedCount', 'Bugün'),
                  _statBox('${WordService.getLearnedWords().length}', 'Toplam'),
                  _statBox('${(progress * 100).toInt()}%', 'İlerleme'),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _smallActionButton(
                    title: 'Öğrenilenler',
                    color: const Color(0xFFE8F9F2),
                    textColor: const Color(0xFF0D4E34),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LearnedWordsScreen(),
                        ),
                      );
                    },
                  ),
                  _smallActionButton(
                    title: 'Quiz',
                    color: const Color(0xFFEEF0FF),
                    textColor: const Color(0xFF2A1E8F),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    },
                  ),
                  _smallActionButton(
                    title: 'Profil',
                    color: const Color(0xFFEDEBFF),
                    textColor: const Color(0xFF2A1E8F),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: words.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Bu seviyedeki tüm kelimeleri öğrendin. Artık tekrar moduna geçebilirsin.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        final word = words[index];
                        final bool isLearned = learnedWordIds.contains(word.id);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WordDetailScreen(word: word),
                              ),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFF3A3A3A)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word.word,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                word.mainMeaning,
                                style: const TextStyle(
                                  color: Color(0xFFA8F0C6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                word.exampleSentence,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
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
                                  child: Text(
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
          ],
        ),
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFFA8F0C6),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallActionButton({
    required String title,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 150,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}