import 'package:flutter/material.dart';
import '../../services/word_service.dart';
import '../../services/streak_service.dart';

class ProfileScreen extends StatefulWidget {
  final String selectedLevel;
  final int dailyWordCount;

  const ProfileScreen({
    super.key,
    required this.selectedLevel,
    required this.dailyWordCount,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int streak = 0;

  @override
  void initState() {
    super.initState();
    loadStreak();
  }

  Future<void> loadStreak() async {
    final currentStreak = await StreakService.updateAndGetStreak();

    setState(() {
      streak = currentStreak;
    });
  }

  @override
  Widget build(BuildContext context) {
    final learnedWords = WordService.getLearnedWords();
    final int totalLearned = learnedWords.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF5C4AE4),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Daily English User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Kelime öğrenme yolculuğun devam ediyor',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                _profileStatCard(
                  title: 'Seviye',
                  value: widget.selectedLevel,
                  icon: Icons.school,
                ),
                const SizedBox(width: 12),
                _profileStatCard(
                  title: 'Günlük Hedef',
                  value: '${widget.dailyWordCount}',
                  icon: Icons.flag,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _profileStatCard(
                  title: 'Öğrenilen',
                  value: '$totalLearned',
                  icon: Icons.menu_book,
                ),
                const SizedBox(width: 12),
                _profileStatCard(
                  title: 'Seri',
                  value: '$streak gün',
                  icon: Icons.local_fire_department,
                ),
              ],
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Genel Durum',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '$totalLearned kelime öğrendin. Günlük hedefin ${widget.dailyWordCount} kelime. Günlük serin $streak gün.',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFA8F0C6), size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}