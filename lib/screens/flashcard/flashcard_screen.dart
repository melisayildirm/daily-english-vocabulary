import 'package:flutter/material.dart';
import '../../models/word_model.dart';
import '../../services/word_service.dart';

class FlashcardScreen extends StatefulWidget {
  final String selectedLevel;

  const FlashcardScreen({
    super.key,
    required this.selectedLevel,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<WordModel> words = [];
  int currentIndex = 0;
  bool isFlipped = false;

  @override
  void initState() {
    super.initState();
    words = WordService.getWordsByLevel(widget.selectedLevel, 999);
  }

  void nextCard() {
    if (currentIndex < words.length - 1) {
      setState(() {
        currentIndex++;
        isFlipped = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tüm kartlar bitti 🎉')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Kelime bulunamadı')),
      );
    }

    final word = words[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          GestureDetector(
            onTap: () {
              setState(() {
                isFlipped = !isFlipped;
              });
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF5C4AE4),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  isFlipped ? word.mainMeaning : word.word,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: nextCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text('Bilmiyorum'),
              ),
              ElevatedButton(
                onPressed: () {
                  WordService.addLearnedWord(word);
                  nextCard();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Biliyorum'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}