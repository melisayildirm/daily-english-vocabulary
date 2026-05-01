import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/word_model.dart';
import '../../services/word_service.dart';

class QuizScreen extends StatefulWidget {
  final List<WordModel>? quizWords;

  const QuizScreen({
    super.key,
    this.quizWords,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<WordModel> quizWords;
  late WordModel currentWord;
  late List<String> options;

  final List<WordModel> wrongWords = [];

  int currentIndex = 0;
  int score = 0;

  bool get isRetryQuiz => widget.quizWords != null;

  @override
  void initState() {
    super.initState();

    quizWords = widget.quizWords ?? List.from(WordService.getLearnedWords());
    quizWords.shuffle();

    if (quizWords.isNotEmpty) {
      prepareQuestion();
    }
  }

  void prepareQuestion() {
    currentWord = quizWords[currentIndex];

    final random = Random();

    final wrongOptions = WordService.getLearnedWords()
        .where((word) => word.id != currentWord.id)
        .map((word) => word.meaning)
        .toSet()
        .toList()
      ..shuffle(random);

    options = [
      currentWord.meaning,
      ...wrongOptions.take(3),
    ];

    options.shuffle(random);
  }

  void checkAnswer(String selectedAnswer) {
    final bool isCorrect = selectedAnswer == currentWord.meaning;

    if (isCorrect) {
      score++;
    } else {
      if (!wrongWords.any((word) => word.id == currentWord.id)) {
        wrongWords.add(currentWord);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Doğru 🎉' : 'Yanlış ❌'),
        duration: const Duration(milliseconds: 700),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
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
          title: const Text('Quiz Bitti 🎉'),
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
                          child: Text('${word.word} - ${word.meaning}'),
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
              'Quiz başlatmak için en az 4 kelime öğrenmelisin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isRetryQuiz ? 'Yanlışları Tekrar Et' : 'Quiz'),
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
              currentWord.word,
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
}