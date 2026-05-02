import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _streakKey = 'streak_count';
  static const String _lastOpenDateKey = 'last_open_date';

  static Future<int> updateAndGetStreak() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    final lastDateString = prefs.getString(_lastOpenDateKey);
    int streak = prefs.getInt(_streakKey) ?? 0;

    if (lastDateString == null) {
      streak = 1;
    } else {
      final lastDate = DateTime.parse(lastDateString);
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

    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastOpenDateKey, todayOnly.toIso8601String());

    return streak;
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }
}