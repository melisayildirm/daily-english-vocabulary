import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        'selectedLevel': null,
        'dailyWordCount': null,
        'learnedWords': [],
        'learnedWordsCount': 0,
        'streak': 0,
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

  Future<void> updateLearningPreferences({
    required String selectedLevel,
    required int dailyWordCount,
  }) async {
    final uid = currentUserId;

    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'selectedLevel': selectedLevel,
      'dailyWordCount': dailyWordCount,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}