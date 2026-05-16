import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/word_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> createUserIfNotExists() async {
    final user = _auth.currentUser;

    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'learnedWords': [],
        'learnedWordsCount': 0,
        'streak': 0,
        'lastActiveDate': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final uid = currentUserId;

    if (uid == null) return null;

    final snapshot = await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) return null;

    return snapshot.data();
  }

  Future<List<WordModel>> getLearnedWords() async {
    final uid = currentUserId;

    if (uid == null) return [];

    final snapshot = await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) return [];

    final data = snapshot.data();
    final learnedWordsData = data?['learnedWords'] as List<dynamic>? ?? [];

    return learnedWordsData
        .map(
          (item) => WordModel.fromMap(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<Set<String>> getLearnedWordIds() async {
    final learnedWords = await getLearnedWords();

    return learnedWords.map((word) => word.id).toSet();
  }

  Future<bool> isWordLearned(String wordId) async {
    final learnedWordIds = await getLearnedWordIds();

    return learnedWordIds.contains(wordId);
  }

  Future<void> addLearnedWord(WordModel word) async {
    final uid = currentUserId;

    if (uid == null) return;

    final userDoc = _firestore.collection('users').doc(uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await createUserIfNotExists();
    }

    final learnedWordIds = await getLearnedWordIds();

    if (learnedWordIds.contains(word.id)) {
      return;
    }

    final currentLearnedWords = await getLearnedWords();
    currentLearnedWords.add(word);

    await userDoc.set({
      'learnedWords': currentLearnedWords
          .map((learnedWord) => learnedWord.toMap())
          .toList(),
      'learnedWordsCount': currentLearnedWords.length,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
  Future<void> cleanDuplicateLearnedWords() async {
  final uid = currentUserId;

  if (uid == null) return;

  final learnedWords = await getLearnedWords();

  final Map<String, WordModel> uniqueWords = {};

  for (final word in learnedWords) {
    uniqueWords[word.id] = word;
  }

  final cleanedWords = uniqueWords.values.toList();

  await _firestore.collection('users').doc(uid).set({
    'learnedWords': cleanedWords.map((word) => word.toMap()).toList(),
    'learnedWordsCount': cleanedWords.length,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
}