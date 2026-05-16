import 'package:flutter/material.dart';

import '../../models/word_model.dart';
import '../../services/user_service.dart';

class LearnedWordsScreen extends StatefulWidget {
  const LearnedWordsScreen({super.key});

  @override
  State<LearnedWordsScreen> createState() =>
      _LearnedWordsScreenState();
}

class _LearnedWordsScreenState
    extends State<LearnedWordsScreen> {
  final UserService _userService = UserService();

  List<WordModel> learnedWords = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLearnedWords();
  }

  Future<void> loadLearnedWords() async {
    await _userService.cleanDuplicateLearnedWords();

    final words =
        await _userService.getLearnedWords();

    if (!mounted) return;

    setState(() {
      learnedWords = words;
      isLoading = false;
    });
  }

  Map<String, List<WordModel>>
      getGroupedWords() {
    Map<String, List<WordModel>> grouped = {};

    for (var word in learnedWords) {
      if (!grouped.containsKey(word.level)) {
        grouped[word.level] = [];
      }

      grouped[word.level]!.add(word);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedWords = getGroupedWords();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Öğrenilen Kelimeler',
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : learnedWords.isEmpty
              ? const Center(
                  child: Text(
                    'Henüz öğrenilen kelime yok',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: groupedWords.entries.map(
                    (entry) {
                      final level = entry.key;
                      final words = entry.value;

                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 12,
                              top: 10,
                            ),
                            child: Text(
                              '$level Kelimeleri',
                              style:
                                  const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          ...words.map(
                            (word) {
                              return Card(
                                margin:
                                    const EdgeInsets
                                        .only(
                                  bottom: 12,
                                ),
                                child: ListTile(
                                  title: Text(
                                    word.word,
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    word.mainMeaning,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
    );
  }
}