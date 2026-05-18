import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<int> updateAndGetStreak() async {
    final user = _auth.currentUser;

    if (user == null) {
      return 0;
    }

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? '',
        'learnedWords': [],
        'learnedWordsCount': 0,
        'streak': 1,
        'lastActiveDate': DateTime.now().toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return 1;
    }

    final data = snapshot.data();

    int streak = data?['streak'] ?? 0;
    final lastActiveDateString = data?['lastActiveDate'];

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (lastActiveDateString == null) {
      streak = 1;
    } else {
      final lastDate = DateTime.parse(lastActiveDateString);
      final lastDateOnly = DateTime(
        lastDate.year,
        lastDate.month,
        lastDate.day,
      );

      final difference = todayOnly.difference(lastDateOnly).inDays;

      if (difference == 0) {
        // Aynı gün tekrar açıldı, streak değişmez.
      } else if (difference == 1) {
        streak++;
      } else {
        streak = 1;
      }
    }

    await userDoc.set({
      'streak': streak,
      'lastActiveDate': todayOnly.toIso8601String(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return streak;
  }

  static Future<int> getStreak() async {
    final user = _auth.currentUser;

    if (user == null) {
      return 0;
    }

    final snapshot =
        await _firestore.collection('users').doc(user.uid).get();

    if (!snapshot.exists) {
      return 0;
    }

    final data = snapshot.data();

    return data?['streak'] ?? 0;
  }
}