class WordMeaning {
  final String meaning;
  final String type;

  WordMeaning({
    required this.meaning,
    required this.type,
  });
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
}