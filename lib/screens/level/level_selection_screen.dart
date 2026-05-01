import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final TextEditingController wordCountController = TextEditingController();

  String? selectedLevel;

  final List<String> levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  void goToHomePage() {
    if (selectedLevel == null || wordCountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen seviye seçin ve kelime sayısı girin.'),
        ),
      );
      return;
    }

    int wordCount = int.parse(wordCountController.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          selectedLevel: selectedLevel!,
          dailyWordCount: wordCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seviye ve Hedef Seç'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'İngilizce seviyeni seç',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: levels.map((level) {
                final bool isSelected = selectedLevel == level;

                return ChoiceChip(
                  label: Text(level),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedLevel = level;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: wordCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bugün kaç kelime öğrenmek istersin?',
                hintText: 'Örneğin: 10',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: goToHomePage,
                child: const Text('Başla'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}