class UserModel {
  final String uid;
  final String name;
  final String email;
  final int learnedWordsCount;
  final int streak;
  final String? selectedLevel;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.learnedWordsCount,
    required this.streak,
    this.selectedLevel,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      learnedWordsCount: map['learnedWordsCount'] ?? 0,
      streak: map['streak'] ?? 0,
      selectedLevel: map['selectedLevel'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'learnedWordsCount': learnedWordsCount,
      'streak': streak,
      'selectedLevel': selectedLevel,
    };
  }
}