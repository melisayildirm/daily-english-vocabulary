import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../models/word_model.dart';

class WordDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> levels = ['a1', 'a2', 'b1', 'b2', 'c1', 'c2'];

  Future<void> uploadAllWordsToFirestore() async {
    for (final level in levels) {
      await _uploadWordsByLevel(level);
    }
  }

  Future<void> _uploadWordsByLevel(String level) async {
    final String jsonString =
        await rootBundle.loadString('assets/data/${level}_words.json');

    final List<dynamic> words = jsonDecode(jsonString); //JSON verisini Dart listesine çeviriyor

    WriteBatch batch = _firestore.batch();
    int operationCount = 0;

    for (final item in words) {
      final Map<String, dynamic> wordData = Map<String, dynamic>.from(item);
      final String id = wordData['id'];

      final docRef = _firestore.collection('words').doc(id);

      batch.set(
        docRef,
        wordData,
        SetOptions(merge: true),
      );

      operationCount++;

      if (operationCount == 450) {
        await batch.commit();
        batch = _firestore.batch();
        operationCount = 0;
      }
    }

    if (operationCount > 0) {
      await batch.commit();
    }
  }
  Future<void> uploadC2WordsToFirestore() async {
    await _uploadWordsByLevel('c2');
  }
  Future<List<WordModel>> getWordsByLevel({
  required String level,
  required int count,
  required Set<String> learnedWordIds,
}) async {
  final snapshot = await _firestore
      .collection('words')
      .where('level', isEqualTo: level)
      .limit(1000)
      .get();

  final words = snapshot.docs
      .map((doc) => WordModel.fromMap(doc.data()))
      .where((word) => !learnedWordIds.contains(word.id))
      .toList();

  words.shuffle(); //random karıştırılıyor

  return words.take(count).toList(); //kullanıcının günlük hedefi kadar kelime veriliyor
}

  Future<int> getWordCount() async {
    final snapshot = await _firestore.collection('words').get();
    return snapshot.docs.length;
  }
}