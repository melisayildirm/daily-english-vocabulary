import 'package:flutter_test/flutter_test.dart';
import 'package:daily_english_vocabulary/models/word_model.dart';

void main() {
  group('WordModel Unit Testleri', () {
    test('UT-01 WordModel nesnesi doğru oluşturulmalı', () {
      final word = WordModel(
        id: '1',
        word: 'apple',
        level: 'A1',
        exampleSentence: 'I eat an apple.',
        meanings: [
          WordMeaning(
            meaning: 'elma',
            type: 'noun',
          ),
        ],
      );

      expect(word.id, '1');
      expect(word.word, 'apple');
      expect(word.level, 'A1');
      expect(word.exampleSentence, 'I eat an apple.');
      expect(word.meanings.first.meaning, 'elma');
      expect(word.meanings.first.type, 'noun');
    });

    test('UT-02 mainMeaning ilk anlamı döndürmeli', () {
      final word = WordModel(
        id: '2',
        word: 'book',
        level: 'A1',
        exampleSentence: 'This is a book.',
        meanings: [
          WordMeaning(
            meaning: 'kitap',
            type: 'noun',
          ),
        ],
      );

      expect(word.mainMeaning, 'kitap');
    });

    test('UT-03 toMap metodu doğru map oluşturmalı', () {
      final word = WordModel(
        id: '3',
        word: 'run',
        level: 'A2',
        exampleSentence: 'I run every morning.',
        meanings: [
          WordMeaning(
            meaning: 'koşmak',
            type: 'verb',
          ),
        ],
      );

      final map = word.toMap();

      expect(map['id'], '3');
      expect(map['word'], 'run');
      expect(map['level'], 'A2');
      expect(map['exampleSentence'], 'I run every morning.');
      expect(map['meanings'], isA<List>());
    });

    test('UT-04 fromMap metodu map verisini WordModel nesnesine çevirmeli', () {
      final map = {
        'id': '4',
        'word': 'happy',
        'level': 'A1',
        'exampleSentence': 'She is happy.',
        'meanings': [
          {
            'meaning': 'mutlu',
            'type': 'adjective',
          }
        ],
      };

      final word = WordModel.fromMap(map);

      expect(word.id, '4');
      expect(word.word, 'happy');
      expect(word.level, 'A1');
      expect(word.exampleSentence, 'She is happy.');
      expect(word.meanings.first.meaning, 'mutlu');
      expect(word.meanings.first.type, 'adjective');
    });
  });
}