import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/streak_service.dart';
import '../../services/user_service.dart';
import '../level/level_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();

  int streak = 0;
  int totalLearned = 0;
  String userName = 'Kullanıcı';

  late AnimationController _streakController;
  late Animation<double> _streakScaleAnimation;

  @override
  void initState() {
    super.initState();

    _streakController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _streakScaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _streakController,
        curve: Curves.easeInOut,
      ),
    );

    loadStreak();
    loadUserStats();
  }

  @override
  void dispose() {
    _streakController.dispose();
    super.dispose();
  }

  Future<void> loadStreak() async {
    final currentStreak = await StreakService.updateAndGetStreak();

    if (!mounted) return;

    setState(() {
      streak = currentStreak;
    });
  }

  Future<void> loadUserStats() async {
    final learnedWords = await _userService.getLearnedWords();
    final userData = await _userService.getUserData();

    final String resolvedName =
        userData?['firstName']?.toString().trim().isNotEmpty == true
            ? userData!['firstName'].toString().trim()
            : userData?['name']?.toString().trim().isNotEmpty == true
                ? userData!['name'].toString().trim()
                : userData?['username']?.toString().trim().isNotEmpty == true
                    ? userData!['username'].toString().trim()
                    : 'Kullanıcı';

    if (!mounted) return;

    setState(() {
      totalLearned = learnedWords.length;
      userName = resolvedName;
    });
  }

  String getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }

  String getStreakMessage() {
    if (streak == 0) {
      return 'Bugün ilk adımı at ve serini başlat.';
    }

    if (streak < 3) {
      return 'Muhteşem bir başlangıç! Bu seriyi korumak için her gün öğrenmeye devam et.';
    }

    if (streak < 7) {
      return 'Harika gidiyorsun! Öğrenme alışkanlığın güçleniyor.';
    }

    return 'Mükemmel! Çok güçlü bir öğrenme serisi yakaladın.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LevelSelectionScreen(),
                  ),
                );
              },
              child: const Text(
                'Öğrenmeye Başla',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          child: Column(
            children: [
              _headerCard(),
              const SizedBox(height: 18),
              _animatedStreakCard(),
              const SizedBox(height: 18),
              Row(
                children: [
                  _miniStatCard(
                    title: 'Öğrenilen Kelime',
                    value: '$totalLearned',
                    backgroundColor: const Color(0xFFE9E1FF),
                  ),
                  const SizedBox(width: 12),
                  _miniStatCard(
                    title: 'Aktif Seviye',
                    value: 'Esnek',
                    backgroundColor: const Color(0xFFDFF4E5),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _miniStatCard(
                    title: 'Günlük Hedef',
                    value: 'Seçilebilir',
                    backgroundColor: const Color(0xFFFFF0BD),
                  ),
                  const SizedBox(width: 12),
                  _miniStatCard(
                    title: 'Mevcut Seri',
                    value: '$streak gün',
                    backgroundColor: const Color(0xFFFFD5B5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF8B7CFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Hoşgeldin $userName',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            getUserEmail(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStatCard({
    required String title,
    required String value,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: Container(
        height: 118,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedStreakCard() {
    final days = ['Paz', 'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt'];
    final todayIndex = DateTime.now().weekday % 7;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF07133D),
            Color(0xFF0E1F68),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ScaleTransition(
                scale: _streakScaleAnimation,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF9800),
                        Color(0xFFFF5722),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.55),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Günlük Seri',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$streak gün',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getStreakMessage(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              final isActive = index == todayIndex;

              return Column(
                children: [
                  Text(
                    days[index],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: isActive ? 52 : 42,
                    height: isActive ? 52 : 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isActive
                          ? const LinearGradient(
                              colors: [
                                Color(0xFFFF9800),
                                Color(0xFFFF5722),
                              ],
                            )
                          : null,
                      color:
                          isActive ? null : Colors.white.withOpacity(0.10),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.6),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      isActive
                          ? Icons.local_fire_department_rounded
                          : Icons.circle,
                      color: isActive ? Colors.white : Colors.white24,
                      size: isActive ? 28 : 10,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}