import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/word_model.dart';
import '../../services/word_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<WordModel> learnedWords;
  late WordModel currentWord;
  late List<String> options;

  int currentIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    learnedWords = List.from(WordService.getLearnedWords());
    learnedWords.shuffle();

    if (learnedWords.length >= 4) {
      prepareQuestion();
    }
  }

  void prepareQuestion() {
    currentWord = learnedWords[currentIndex];

    final random = Random();

    final wrongOptions = learnedWords
        .where((word) => word.id != currentWord.id)
        .map((word) => word.meaning)
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
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Doğru 🎉' : 'Yanlış ❌'),
        duration: const Duration(milliseconds: 700),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (currentIndex < learnedWords.length - 1) {
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
          content: Text('Skorun: $score / ${learnedWords.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (learnedWords.length < 4) {
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
        title: const Text('Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Soru ${currentIndex + 1} / ${learnedWords.length}',
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