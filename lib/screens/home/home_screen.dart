import 'package:flutter/material.dart';

import '../../models/word_model.dart';
import '../../services/user_service.dart';
import '../../services/word_database_service.dart';
import '../learned/learned_words_screen.dart';
import '../profile/profile_screen.dart';
import '../quiz/quiz_screen.dart';
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
  final UserService _userService = UserService();
  final WordDatabaseService _wordDatabaseService = WordDatabaseService();

  List<WordModel> words = [];
  List<WordModel> todayLearnedWords = [];

  Set<String> learnedWordIds = {};
  Set<String> todayLearnedWordIds = {};

  int totalLearnedCount = 0;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    await _userService.saveTodayLearningSettings(
      selectedLevel: widget.selectedLevel,
      dailyWordCount: widget.dailyWordCount,
    );

    learnedWordIds = await _userService.getLearnedWordIds();

    final learnedWords = await _userService.getLearnedWords();
    final todayWords = await _userService.getTodayLearnedWords();

    final firestoreWords = await _wordDatabaseService.getWordsByLevel(
      level: widget.selectedLevel,
      count: widget.dailyWordCount,
      learnedWordIds: learnedWordIds,
    );

    if (!mounted) return;

    setState(() {
      words = firestoreWords;
      totalLearnedCount = learnedWords.length;

      todayLearnedWords = todayWords;
      todayLearnedWordIds = todayWords.map((word) => word.id).toSet();

      isLoading = false;
    });
  }

  Future<void> markWordAsLearned(WordModel word) async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    await _userService.addLearnedWord(word);

    final learnedWords = await _userService.getLearnedWords();
    final todayWords = await _userService.getTodayLearnedWords();

    if (!mounted) return;

    setState(() {
      learnedWordIds.add(word.id);

      todayLearnedWords = todayWords;
      todayLearnedWordIds = todayWords.map((item) => item.id).toSet();

      words.removeWhere((item) => item.id == word.id);
      totalLearnedCount = learnedWords.length;
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalWords = widget.dailyWordCount;
    final int learnedTodayCount = todayLearnedWordIds.length;
    final double progress =
        totalWords == 0 ? 0 : learnedTodayCount / totalWords;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Günlük ilerleme',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    '$learnedTodayCount / $totalWords',
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
                                  value: progress > 1 ? 1 : progress,
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
                        _statBox('$learnedTodayCount', 'Bugün'),
                        _statBox('$totalLearnedCount', 'Toplam'),
                        _statBox(
                          '${((progress > 1 ? 1 : progress) * 100).toInt()}%',
                          'İlerleme',
                        ),
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
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LearnedWordsScreen(),
                              ),
                            );

                            await loadWords();
                          },
                        ),
                        _smallActionButton(
                          title: 'Quiz',
                          color: const Color(0xFFEEF0FF),
                          textColor: const Color(0xFF2A1E8F),
                          onTap: () async {
                            final todayWords =
                                await _userService.getTodayLearnedWords();

                            if (!context.mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  todayWords: todayWords,
                                ),
                              ),
                            );
                          },
                        ),
                        _smallActionButton(
                          title: 'Profil',
                          color: const Color(0xFFEDEBFF),
                          textColor: const Color(0xFF2A1E8F),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );

                            await loadWords();
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
                                'Bu seviyedeki tüm kelimeleri öğrendin.',
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

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WordDetailScreen(word: word),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A2A),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: const Color(0xFF3A3A3A),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        word.exampleSentence.isEmpty
                                            ? 'AI ile örnek cümle oluşturabilirsin.'
                                            : word.exampleSentence,
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
                                          onPressed: isSaving
                                              ? null
                                              : () => markWordAsLearned(word),
                                          child: Text(
                                            isSaving
                                                ? 'Kaydediliyor...'
                                                : 'Öğrendim',
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
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
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