class WordMeaning {
  final String meaning;
  final String type;

  WordMeaning({
    required this.meaning,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'meaning': meaning,
      'type': type,
    };
  }

  factory WordMeaning.fromMap(Map<String, dynamic> map) {
    return WordMeaning(
      meaning: map['meaning'] ?? 'Anlam bulunamadı',
      type: map['type'] ?? 'Bilinmiyor',
    );
  }
}

class WordModel {
  final String id;
  final String word;
  final List<WordMeaning> meanings;
  final String exampleSentence;
  final String level;

  WordModel({
    required this.id,
    required this.word,
    String? meaning,
    List<WordMeaning>? meanings,
    required this.exampleSentence,
    required this.level,
  }) : meanings = meanings ??
            [
              WordMeaning(
                meaning: meaning ?? 'Anlam bulunamadı',
                type: 'Bilinmiyor',
              ),
            ];

  String get mainMeaning {
    return meanings.isNotEmpty
        ? meanings.first.meaning
        : 'Anlam bulunamadı';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meanings': meanings.map((meaning) => meaning.toMap()).toList(),
      'exampleSentence': exampleSentence,
      'level': level,
    };
  }

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] ?? '',
      word: map['word'] ?? '',
      meanings: (map['meanings'] as List<dynamic>? ?? [])
          .map(
            (item) => WordMeaning.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      exampleSentence: map['exampleSentence'] ?? '',
      level: map['level'] ?? '',
    );
  }
}