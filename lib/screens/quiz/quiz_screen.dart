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

  void checkAnswer(String selectedAnswer) {
    if (currentWord == null) return;

    final bool isCorrect = selectedAnswer == currentWord!.mainMeaning;

    if (isCorrect) {
      score++;
    } else {
      if (!wrongWords.any((word) => word.id == currentWord!.id)) {
        wrongWords.add(currentWord!);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Doğru cevap' : 'Yanlış cevap'),
        duration: const Duration(milliseconds: 700),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (currentIndex < quizWords.length - 1) {
        setState(() {
          currentIndex++;
          prepareQuestion();
        });
      } else {
        showResultDialog();
      }
    });
  }

  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Sonucu'),
          content: SizedBox(
            width: double.maxFinite,
            child: wrongWords.isEmpty
                ? Text(
                    'Harika! Tüm cevapların doğru.\nSkorun: $score / ${quizWords.length}',
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skorun: $score / ${quizWords.length}'),
                      const SizedBox(height: 16),
                      const Text(
                        'Yanlış Bildiğin Kelimeler:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...wrongWords.map(
                        (word) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('${word.word} - ${word.mainMeaning}'),
                        ),
                      ),
                    ],
                  ),
          ),
          actions: [
            if (wrongWords.isNotEmpty)
              TextButton(
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle ?? 'Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Soru ${currentIndex + 1} / ${quizWords.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              currentWord?.word ?? '',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => checkAnswer(option),
                    child: Text(option),
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
              icon: Icons.today,
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
              icon: Icons.menu_book,
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFA8F0C6),
              size: 32,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$wordCount kelime',
                    style: const TextStyle(
                      color: Color(0xFFA8F0C6),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
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