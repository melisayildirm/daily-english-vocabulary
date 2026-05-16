import 'dart:math';
import 'package:flutter/material.dart';

import '../../models/word_model.dart';
import '../../services/user_service.dart';

class QuizScreen extends StatefulWidget {
  final List<WordModel>? quizWords;
  final List<WordModel>? todayWords;
  final String? quizTitle;

  const QuizScreen({
    super.key,
    this.quizWords,
    this.todayWords,
    this.quizTitle,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final UserService _userService = UserService();

  List<WordModel> allLearnedWords = [];
  List<WordModel> quizWords = [];
  List<String> options = [];
  List<WordModel> wrongWords = [];

  WordModel? currentWord;

  int currentIndex = 0;
  int score = 0;

  bool isLoading = true;
  bool quizStarted = false;

  bool get isRetryQuiz => widget.quizWords != null;

  @override
  void initState() {
    super.initState();
    loadQuizData();
  }

  Future<void> loadQuizData() async {
    if (widget.quizWords != null) {
      quizWords = List.from(widget.quizWords!);
      quizStarted = true;
      quizWords.shuffle();

      if (quizWords.isNotEmpty) {
        prepareQuestion();
      }
    } else {
      allLearnedWords = await _userService.getLearnedWords();
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  void startQuiz(List<WordModel> selectedWords) {
    setState(() {
      quizWords = List.from(selectedWords);
      quizWords.shuffle();
      wrongWords = [];
      currentIndex = 0;
      score = 0;
      quizStarted = true;

      if (quizWords.isNotEmpty) {
        prepareQuestion();
      }
    });
  }

  void prepareQuestion() {
    currentWord = quizWords[currentIndex];

    final random = Random();

    final wrongOptions = quizWords
        .where((word) => word.id != currentWord!.id)
        .map((word) => word.mainMeaning)
        .toSet()
        .toList()
      ..shuffle(random);

    options = [
      currentWord!.mainMeaning,
      ...wrongOptions.take(3),
    ];

    options.shuffle(random);
  }

  Future<void> checkAnswer(String selectedAnswer) async {
    if (currentWord == null) return;

    final bool isCorrect = selectedAnswer == currentWord!.mainMeaning;

    await showFeedbackAnimation(isCorrect);

    if (isCorrect) {
      score++;
    } else {
      if (!wrongWords.any((word) => word.id == currentWord!.id)) {
        wrongWords.add(currentWord!);
      }
    }

    if (!mounted) return;

    if (currentIndex < quizWords.length - 1) {
      setState(() {
        currentIndex++;
        prepareQuestion();
      });
    } else {
      showResultDialog();
    }
  }

  Future<void> showFeedbackAnimation(bool isCorrect) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.6, end: 1),
            duration: const Duration(milliseconds: 350),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE53935),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isCorrect
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFE53935))
                            .withOpacity(0.35),
                        blurRadius: 35,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    isCorrect ? Icons.check_rounded : Icons.close_rounded,
                    color: Colors.white,
                    size: 88,
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 850));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void showResultDialog() {
    final double percentage =
        quizWords.isEmpty ? 0 : score / quizWords.length;

    final String title = percentage == 1
        ? 'Harika!'
        : percentage >= 0.7
            ? 'Çok iyi!'
            : percentage >= 0.4
                ? 'Fena değil!'
                : 'Tekrar iyi gelir';

    final IconData resultIcon = percentage == 1
        ? Icons.emoji_events_rounded
        : percentage >= 0.7
            ? Icons.star_rounded
            : Icons.refresh_rounded;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    resultIcon,
                    color: const Color(0xFF6C63FF),
                    size: 44,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Skorun: $score / ${quizWords.length}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 12,
                    backgroundColor: const Color(0xFFEAEAF5),
                    color: const Color(0xFF6C63FF),
                  ),
                ),
                if (wrongWords.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tekrar etmen gerekenler',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: wrongWords.map((word) {
                      return Chip(
                        label: Text('${word.word} • ${word.mainMeaning}'),
                        backgroundColor: const Color(0xFFFFEDED),
                        labelStyle: const TextStyle(
                          color: Color(0xFFC62828),
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 24),
                if (wrongWords.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              quizWords: List.from(wrongWords),
                              quizTitle: 'Yanlışları Tekrar Et',
                            ),
                          ),
                        );
                      },
                      child: const Text('Yanlışları Tekrar Et'),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Ana Sayfaya Dön'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!quizStarted && !isRetryQuiz) {
      return _buildQuizSelectionScreen();
    }

    if (quizWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Quiz için kelime bulunamadı.'),
        ),
      );
    }

    if (!isRetryQuiz && quizWords.length < 4) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          centerTitle: true,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Quiz başlatmak için en az 4 kelime gerekir.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

    final double progress =
        quizWords.isEmpty ? 0 : (currentIndex + 1) / quizWords.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle ?? 'Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C63FF),
                    Color(0xFF837BFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Text(
                    'Soru ${currentIndex + 1} / ${quizWords.length}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentWord?.word ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      backgroundColor: Colors.white24,
                      color: const Color(0xFFA8F0C6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () => checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2A2A2A),
                      elevation: 0,
                      side: const BorderSide(
                        color: Color(0xFFE6E6F0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizSelectionScreen() {
    final todayWords = widget.todayWords ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Seç'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _quizOptionCard(
              title: 'Bugünkü Kelimelerden Quiz',
              description:
                  'Sadece bugün öğrendiğin kelimelerle kısa bir quiz çöz.',
              wordCount: todayWords.length,
              icon: Icons.today_rounded,
              color: const Color(0xFFEDEBFF),
              onTap: () {
                if (todayWords.length < 4) {
                  _showWarning(
                    'Bugünkü kelimelerle quiz için en az 4 kelime öğrenmelisin.',
                  );
                  return;
                }

                startQuiz(todayWords);
              },
            ),
            const SizedBox(height: 16),
            _quizOptionCard(
              title: 'Tüm Öğrenilenlerden Quiz',
              description:
                  'Şimdiye kadar öğrendiğin tüm kelimelerden karışık quiz çöz.',
              wordCount: allLearnedWords.length,
              icon: Icons.menu_book_rounded,
              color: const Color(0xFFE8F9F2),
              onTap: () {
                if (allLearnedWords.length < 4) {
                  _showWarning(
                    'Genel quiz için en az 4 kelime öğrenmelisin.',
                  );
                  return;
                }

                startQuiz(allLearnedWords);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _quizOptionCard({
    required String title,
    required String description,
    required int wordCount,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF6C63FF),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$wordCount kelime',
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Color(0xFFB0B0B0),
            ),
          ],
        ),
      ),
    );
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}