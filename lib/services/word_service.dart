import '../models/word_model.dart';

class WordService {
  static List<WordModel> getWordsByLevel(String level, int count) {
    final List<WordModel> allWords = [
      // A1
      WordModel(id: 'a1_1', word: 'apple', meaning: 'elma', exampleSentence: 'I eat an apple every day.', level: 'A1'),
      WordModel(id: 'a1_2', word: 'book', meaning: 'kitap', exampleSentence: 'This book is interesting.', level: 'A1'),
      WordModel(id: 'a1_3', word: 'school', meaning: 'okul', exampleSentence: 'She goes to school.', level: 'A1'),
      WordModel(id: 'a1_4', word: 'city', meaning: 'şehir', exampleSentence: 'I live in a big city.', level: 'A1'),
      WordModel(id: 'a1_5', word: 'family', meaning: 'aile', exampleSentence: 'My family is important.', level: 'A1'),
      WordModel(id: 'a1_6', word: 'friend', meaning: 'arkadaş', exampleSentence: 'He is my friend.', level: 'A1'),
      WordModel(id: 'a1_7', word: 'house', meaning: 'ev', exampleSentence: 'This is my house.', level: 'A1'),
      WordModel(id: 'a1_8', word: 'computer', meaning: 'bilgisayar', exampleSentence: 'I use a computer.', level: 'A1'),
      WordModel(id: 'a1_9', word: 'car', meaning: 'araba', exampleSentence: 'My father has a car.', level: 'A1'),
      WordModel(id: 'a1_10', word: 'dog', meaning: 'köpek', exampleSentence: 'The dog is cute.', level: 'A1'),
      WordModel(id: 'a1_11', word: 'cat', meaning: 'kedi', exampleSentence: 'The cat is sleeping.', level: 'A1'),
      WordModel(id: 'a1_12', word: 'day', meaning: 'gün', exampleSentence: 'Today is a good day.', level: 'A1'),
      WordModel(id: 'a1_13', word: 'night', meaning: 'gece', exampleSentence: 'I sleep at night.', level: 'A1'),
      WordModel(id: 'a1_14', word: 'morning', meaning: 'sabah', exampleSentence: 'I study in the morning.', level: 'A1'),
      WordModel(id: 'a1_15', word: 'water', meaning: 'su', exampleSentence: 'I drink water.', level: 'A1'),
      WordModel(id: 'a1_16', word: 'food', meaning: 'yiyecek', exampleSentence: 'This food is delicious.', level: 'A1'),
      WordModel(id: 'a1_17', word: 'happy', meaning: 'mutlu', exampleSentence: 'She is happy.', level: 'A1'),
      WordModel(id: 'a1_18', word: 'big', meaning: 'büyük', exampleSentence: 'This is a big room.', level: 'A1'),
      WordModel(id: 'a1_19', word: 'small', meaning: 'küçük', exampleSentence: 'I have a small bag.', level: 'A1'),
      WordModel(id: 'a1_20', word: 'beautiful', meaning: 'güzel', exampleSentence: 'This flower is beautiful.', level: 'A1'),
      WordModel(id: 'a1_21', word: 'easy', meaning: 'kolay', exampleSentence: 'This question is easy.', level: 'A1'),
      WordModel(id: 'a1_22', word: 'new', meaning: 'yeni', exampleSentence: 'I have a new phone.', level: 'A1'),
      WordModel(id: 'a1_23', word: 'read', meaning: 'okumak', exampleSentence: 'I read a book.', level: 'A1'),
      WordModel(id: 'a1_24', word: 'write', meaning: 'yazmak', exampleSentence: 'Write your name.', level: 'A1'),
      WordModel(id: 'a1_25', word: 'listen', meaning: 'dinlemek', exampleSentence: 'I listen to music.', level: 'A1'),
      WordModel(id: 'a1_26', word: 'speak', meaning: 'konuşmak', exampleSentence: 'I speak English.', level: 'A1'),
      WordModel(id: 'a1_27', word: 'learn', meaning: 'öğrenmek', exampleSentence: 'I learn English.', level: 'A1'),
      WordModel(id: 'a1_28', word: 'answer', meaning: 'cevap', exampleSentence: 'I know the answer.', level: 'A1'),
      WordModel(id: 'a1_29', word: 'question', meaning: 'soru', exampleSentence: 'This is a question.', level: 'A1'),
      WordModel(id: 'a1_30', word: 'teacher', meaning: 'öğretmen', exampleSentence: 'My teacher is kind.', level: 'A1'),

      // A2
      WordModel(id: 'a2_1', word: 'ability', meaning: 'yetenek', exampleSentence: 'She has a great ability.', level: 'A2'),
      WordModel(id: 'a2_2', word: 'abroad', meaning: 'yurt dışı', exampleSentence: 'He wants to study abroad.', level: 'A2'),
      WordModel(id: 'a2_3', word: 'accept', meaning: 'kabul etmek', exampleSentence: 'I accept your offer.', level: 'A2'),
      WordModel(id: 'a2_4', word: 'accident', meaning: 'kaza', exampleSentence: 'There was an accident.', level: 'A2'),
      WordModel(id: 'a2_5', word: 'achieve', meaning: 'başarmak', exampleSentence: 'You can achieve your goal.', level: 'A2'),
      WordModel(id: 'a2_6', word: 'active', meaning: 'aktif', exampleSentence: 'She is very active.', level: 'A2'),
      WordModel(id: 'a2_7', word: 'advantage', meaning: 'avantaj', exampleSentence: 'This is an advantage.', level: 'A2'),
      WordModel(id: 'a2_8', word: 'adventure', meaning: 'macera', exampleSentence: 'It was a great adventure.', level: 'A2'),
      WordModel(id: 'a2_9', word: 'advertisement', meaning: 'reklam', exampleSentence: 'I saw an advertisement.', level: 'A2'),
      WordModel(id: 'a2_10', word: 'affect', meaning: 'etkilemek', exampleSentence: 'Weather can affect mood.', level: 'A2'),
      WordModel(id: 'a2_11', word: 'airline', meaning: 'hava yolu', exampleSentence: 'This airline is popular.', level: 'A2'),
      WordModel(id: 'a2_12', word: 'alive', meaning: 'canlı', exampleSentence: 'The plant is alive.', level: 'A2'),
      WordModel(id: 'a2_13', word: 'allow', meaning: 'izin vermek', exampleSentence: 'My parents allow me to go.', level: 'A2'),
      WordModel(id: 'a2_14', word: 'almost', meaning: 'neredeyse', exampleSentence: 'I almost finished it.', level: 'A2'),
      WordModel(id: 'a2_15', word: 'alone', meaning: 'yalnız', exampleSentence: 'She lives alone.', level: 'A2'),
      WordModel(id: 'a2_16', word: 'already', meaning: 'zaten', exampleSentence: 'I already know this.', level: 'A2'),
      WordModel(id: 'a2_17', word: 'alternative', meaning: 'alternatif', exampleSentence: 'We need an alternative.', level: 'A2'),
      WordModel(id: 'a2_18', word: 'although', meaning: 'rağmen', exampleSentence: 'Although it rained, we went out.', level: 'A2'),
      WordModel(id: 'a2_19', word: 'amount', meaning: 'miktar', exampleSentence: 'The amount is small.', level: 'A2'),
      WordModel(id: 'a2_20', word: 'ancient', meaning: 'antik', exampleSentence: 'This is an ancient city.', level: 'A2'),
      WordModel(id: 'a2_21', word: 'anywhere', meaning: 'herhangi bir yer', exampleSentence: 'You can sit anywhere.', level: 'A2'),
      WordModel(id: 'a2_22', word: 'appear', meaning: 'görünmek', exampleSentence: 'He appeared suddenly.', level: 'A2'),
      WordModel(id: 'a2_23', word: 'apply', meaning: 'başvurmak', exampleSentence: 'I will apply for the job.', level: 'A2'),
      WordModel(id: 'a2_24', word: 'argue', meaning: 'tartışmak', exampleSentence: 'They often argue.', level: 'A2'),
      WordModel(id: 'a2_25', word: 'arrange', meaning: 'düzenlemek', exampleSentence: 'We arranged a meeting.', level: 'A2'),
      WordModel(id: 'a2_26', word: 'assistant', meaning: 'asistan', exampleSentence: 'She works as an assistant.', level: 'A2'),
      WordModel(id: 'a2_27', word: 'athlete', meaning: 'sporcu', exampleSentence: 'He is a successful athlete.', level: 'A2'),
      WordModel(id: 'a2_28', word: 'attention', meaning: 'dikkat', exampleSentence: 'Pay attention, please.', level: 'A2'),
      WordModel(id: 'a2_29', word: 'audience', meaning: 'seyirci', exampleSentence: 'The audience was excited.', level: 'A2'),
      WordModel(id: 'a2_30', word: 'available', meaning: 'mevcut', exampleSentence: 'This room is available.', level: 'A2'),

      // B1
      WordModel(id: 'b1_1', word: 'absolutely', meaning: 'kesinlikle', exampleSentence: 'You are absolutely right.', level: 'B1'),
      WordModel(id: 'b1_2', word: 'academic', meaning: 'akademik', exampleSentence: 'She has academic success.', level: 'B1'),
      WordModel(id: 'b1_3', word: 'access', meaning: 'erişim', exampleSentence: 'Students have access to the library.', level: 'B1'),
      WordModel(id: 'b1_4', word: 'accommodation', meaning: 'konaklama', exampleSentence: 'We need accommodation.', level: 'B1'),
      WordModel(id: 'b1_5', word: 'account', meaning: 'hesap', exampleSentence: 'I opened a bank account.', level: 'B1'),
      WordModel(id: 'b1_6', word: 'achievement', meaning: 'başarı', exampleSentence: 'This is a great achievement.', level: 'B1'),
      WordModel(id: 'b1_7', word: 'addition', meaning: 'ek', exampleSentence: 'In addition, we need more time.', level: 'B1'),
      WordModel(id: 'b1_8', word: 'admire', meaning: 'hayran olmak', exampleSentence: 'I admire her courage.', level: 'B1'),
      WordModel(id: 'b1_9', word: 'admit', meaning: 'itiraf etmek', exampleSentence: 'He admitted his mistake.', level: 'B1'),
      WordModel(id: 'b1_10', word: 'advanced', meaning: 'ileri', exampleSentence: 'This is an advanced course.', level: 'B1'),
      WordModel(id: 'b1_11', word: 'advise', meaning: 'tavsiye etmek', exampleSentence: 'I advise you to rest.', level: 'B1'),
      WordModel(id: 'b1_12', word: 'afford', meaning: 'gücü yetmek', exampleSentence: 'I cannot afford this car.', level: 'B1'),
      WordModel(id: 'b1_13', word: 'agent', meaning: 'temsilci', exampleSentence: 'The agent called me.', level: 'B1'),
      WordModel(id: 'b1_14', word: 'agreement', meaning: 'anlaşma', exampleSentence: 'They reached an agreement.', level: 'B1'),
      WordModel(id: 'b1_15', word: 'aim', meaning: 'amaç', exampleSentence: 'My aim is to improve.', level: 'B1'),
      WordModel(id: 'b1_16', word: 'alarm', meaning: 'alarm', exampleSentence: 'The alarm rang loudly.', level: 'B1'),
      WordModel(id: 'b1_17', word: 'alternative', meaning: 'alternatif', exampleSentence: 'We found an alternative solution.', level: 'B1'),
      WordModel(id: 'b1_18', word: 'amazed', meaning: 'şaşırmış', exampleSentence: 'I was amazed by the result.', level: 'B1'),
      WordModel(id: 'b1_19', word: 'ambition', meaning: 'hırs', exampleSentence: 'She has great ambition.', level: 'B1'),
      WordModel(id: 'b1_20', word: 'analyse', meaning: 'analiz etmek', exampleSentence: 'We need to analyse the data.', level: 'B1'),
      WordModel(id: 'b1_21', word: 'announce', meaning: 'duyurmak', exampleSentence: 'They announced the results.', level: 'B1'),
      WordModel(id: 'b1_22', word: 'annoy', meaning: 'rahatsız etmek', exampleSentence: 'Loud noise can annoy people.', level: 'B1'),
      WordModel(id: 'b1_23', word: 'apologize', meaning: 'özür dilemek', exampleSentence: 'You should apologize.', level: 'B1'),
      WordModel(id: 'b1_24', word: 'application', meaning: 'başvuru', exampleSentence: 'I sent my application.', level: 'B1'),
      WordModel(id: 'b1_25', word: 'appointment', meaning: 'randevu', exampleSentence: 'I have an appointment today.', level: 'B1'),
      WordModel(id: 'b1_26', word: 'appreciate', meaning: 'takdir etmek', exampleSentence: 'I appreciate your help.', level: 'B1'),
      WordModel(id: 'b1_27', word: 'approximately', meaning: 'yaklaşık olarak', exampleSentence: 'It takes approximately one hour.', level: 'B1'),
      WordModel(id: 'b1_28', word: 'arrest', meaning: 'tutuklamak', exampleSentence: 'The police arrested him.', level: 'B1'),
      WordModel(id: 'b1_29', word: 'arrival', meaning: 'varış', exampleSentence: 'Our arrival was late.', level: 'B1'),
      WordModel(id: 'b1_30', word: 'assignment', meaning: 'ödev', exampleSentence: 'I finished my assignment.', level: 'B1'),

      // B2
      WordModel(id: 'b2_1', word: 'abandon', meaning: 'terk etmek', exampleSentence: 'They had to abandon the plan.', level: 'B2'),
      WordModel(id: 'b2_2', word: 'absolute', meaning: 'mutlak', exampleSentence: 'This is an absolute rule.', level: 'B2'),
      WordModel(id: 'b2_3', word: 'absorb', meaning: 'emmek / kavramak', exampleSentence: 'Plants absorb water.', level: 'B2'),
      WordModel(id: 'b2_4', word: 'abstract', meaning: 'soyut', exampleSentence: 'This is an abstract idea.', level: 'B2'),
      WordModel(id: 'b2_5', word: 'accent', meaning: 'aksan', exampleSentence: 'She has a British accent.', level: 'B2'),
      WordModel(id: 'b2_6', word: 'acceptable', meaning: 'kabul edilebilir', exampleSentence: 'This answer is acceptable.', level: 'B2'),
      WordModel(id: 'b2_7', word: 'accidentally', meaning: 'kazara', exampleSentence: 'I accidentally deleted the file.', level: 'B2'),
      WordModel(id: 'b2_8', word: 'accommodate', meaning: 'yer sağlamak', exampleSentence: 'The hotel can accommodate guests.', level: 'B2'),
      WordModel(id: 'b2_9', word: 'accompany', meaning: 'eşlik etmek', exampleSentence: 'I will accompany you.', level: 'B2'),
      WordModel(id: 'b2_10', word: 'accomplish', meaning: 'başarmak', exampleSentence: 'She accomplished her goal.', level: 'B2'),
      WordModel(id: 'b2_11', word: 'accountant', meaning: 'muhasebeci', exampleSentence: 'My uncle is an accountant.', level: 'B2'),
      WordModel(id: 'b2_12', word: 'accuracy', meaning: 'doğruluk', exampleSentence: 'Accuracy is important.', level: 'B2'),
      WordModel(id: 'b2_13', word: 'accurate', meaning: 'doğru', exampleSentence: 'The information is accurate.', level: 'B2'),
      WordModel(id: 'b2_14', word: 'accuse', meaning: 'suçlamak', exampleSentence: 'They accused him of lying.', level: 'B2'),
      WordModel(id: 'b2_15', word: 'acknowledge', meaning: 'kabul etmek', exampleSentence: 'She acknowledged her mistake.', level: 'B2'),
      WordModel(id: 'b2_16', word: 'acquire', meaning: 'edinmek', exampleSentence: 'He acquired new skills.', level: 'B2'),
      WordModel(id: 'b2_17', word: 'activate', meaning: 'etkinleştirmek', exampleSentence: 'Activate your account.', level: 'B2'),
      WordModel(id: 'b2_18', word: 'adapt', meaning: 'uyum sağlamak', exampleSentence: 'You need to adapt quickly.', level: 'B2'),
      WordModel(id: 'b2_19', word: 'addiction', meaning: 'bağımlılık', exampleSentence: 'Phone addiction is common.', level: 'B2'),
      WordModel(id: 'b2_20', word: 'additional', meaning: 'ek', exampleSentence: 'We need additional information.', level: 'B2'),
      WordModel(id: 'b2_21', word: 'adequate', meaning: 'yeterli', exampleSentence: 'The room is adequate.', level: 'B2'),
      WordModel(id: 'b2_22', word: 'adjust', meaning: 'ayarlamak', exampleSentence: 'Adjust the settings.', level: 'B2'),
      WordModel(id: 'b2_23', word: 'administration', meaning: 'yönetim', exampleSentence: 'The administration made a decision.', level: 'B2'),
      WordModel(id: 'b2_24', word: 'adopt', meaning: 'benimsemek', exampleSentence: 'They adopted a new method.', level: 'B2'),
      WordModel(id: 'b2_25', word: 'advance', meaning: 'geliştirmek', exampleSentence: 'Technology continues to advance.', level: 'B2'),
      WordModel(id: 'b2_26', word: 'affordable', meaning: 'uygun fiyatlı', exampleSentence: 'This laptop is affordable.', level: 'B2'),
      WordModel(id: 'b2_27', word: 'agency', meaning: 'ajans', exampleSentence: 'She works at an agency.', level: 'B2'),
      WordModel(id: 'b2_28', word: 'agenda', meaning: 'gündem', exampleSentence: 'The topic is on the agenda.', level: 'B2'),
      WordModel(id: 'b2_29', word: 'aggressive', meaning: 'saldırgan', exampleSentence: 'His tone was aggressive.', level: 'B2'),
      WordModel(id: 'b2_30', word: 'agriculture', meaning: 'tarım', exampleSentence: 'Agriculture is important.', level: 'B2'),

      // C1
      WordModel(id: 'c1_1', word: 'abolish', meaning: 'yürürlükten kaldırmak', exampleSentence: 'They decided to abolish the rule.', level: 'C1'),
      WordModel(id: 'c1_2', word: 'absence', meaning: 'yokluk', exampleSentence: 'His absence was noticed.', level: 'C1'),
      WordModel(id: 'c1_3', word: 'absurd', meaning: 'saçma', exampleSentence: 'That idea sounds absurd.', level: 'C1'),
      WordModel(id: 'c1_4', word: 'abundance', meaning: 'bolluk', exampleSentence: 'There is an abundance of food.', level: 'C1'),
      WordModel(id: 'c1_5', word: 'abuse', meaning: 'kötüye kullanmak', exampleSentence: 'Power can be abused.', level: 'C1'),
      WordModel(id: 'c1_6', word: 'academy', meaning: 'akademi', exampleSentence: 'She joined the academy.', level: 'C1'),
      WordModel(id: 'c1_7', word: 'accelerate', meaning: 'hızlandırmak', exampleSentence: 'The company wants to accelerate growth.', level: 'C1'),
      WordModel(id: 'c1_8', word: 'acceptance', meaning: 'kabul', exampleSentence: 'Acceptance is important.', level: 'C1'),
      WordModel(id: 'c1_9', word: 'accessible', meaning: 'erişilebilir', exampleSentence: 'The website is accessible.', level: 'C1'),
      WordModel(id: 'c1_10', word: 'accomplishment', meaning: 'başarı', exampleSentence: 'This is a major accomplishment.', level: 'C1'),
      WordModel(id: 'c1_11', word: 'accordance', meaning: 'uygunluk', exampleSentence: 'This is in accordance with the law.', level: 'C1'),
      WordModel(id: 'c1_12', word: 'accountability', meaning: 'sorumluluk', exampleSentence: 'Accountability is necessary.', level: 'C1'),
      WordModel(id: 'c1_13', word: 'accumulate', meaning: 'biriktirmek', exampleSentence: 'Dust can accumulate quickly.', level: 'C1'),
      WordModel(id: 'c1_14', word: 'accusation', meaning: 'suçlama', exampleSentence: 'The accusation was serious.', level: 'C1'),
      WordModel(id: 'c1_15', word: 'acquisition', meaning: 'edinme', exampleSentence: 'Language acquisition takes time.', level: 'C1'),
      WordModel(id: 'c1_16', word: 'activist', meaning: 'aktivist', exampleSentence: 'The activist gave a speech.', level: 'C1'),
      WordModel(id: 'c1_17', word: 'acute', meaning: 'şiddetli', exampleSentence: 'He felt acute pain.', level: 'C1'),
      WordModel(id: 'c1_18', word: 'adaptation', meaning: 'uyum', exampleSentence: 'Adaptation is important in nature.', level: 'C1'),
      WordModel(id: 'c1_19', word: 'adhere', meaning: 'bağlı kalmak', exampleSentence: 'You must adhere to the rules.', level: 'C1'),
      WordModel(id: 'c1_20', word: 'adjacent', meaning: 'bitişik', exampleSentence: 'The room is adjacent to mine.', level: 'C1'),
      WordModel(id: 'c1_21', word: 'adjustment', meaning: 'ayarlama', exampleSentence: 'A small adjustment is needed.', level: 'C1'),
      WordModel(id: 'c1_22', word: 'administrative', meaning: 'idari', exampleSentence: 'She handles administrative tasks.', level: 'C1'),
      WordModel(id: 'c1_23', word: 'admission', meaning: 'kabul / giriş', exampleSentence: 'Admission to the course is limited.', level: 'C1'),
      WordModel(id: 'c1_24', word: 'adolescent', meaning: 'ergen', exampleSentence: 'Adolescent behavior can change.', level: 'C1'),
      WordModel(id: 'c1_25', word: 'adoption', meaning: 'benimseme', exampleSentence: 'The adoption of technology increased.', level: 'C1'),
      WordModel(id: 'c1_26', word: 'adverse', meaning: 'olumsuz', exampleSentence: 'The drug had adverse effects.', level: 'C1'),
      WordModel(id: 'c1_27', word: 'advocate', meaning: 'savunmak', exampleSentence: 'They advocate equal rights.', level: 'C1'),
      WordModel(id: 'c1_28', word: 'aesthetic', meaning: 'estetik', exampleSentence: 'The design has aesthetic value.', level: 'C1'),
      WordModel(id: 'c1_29', word: 'affection', meaning: 'sevgi', exampleSentence: 'She showed affection for her family.', level: 'C1'),
      WordModel(id: 'c1_30', word: 'aftermath', meaning: 'sonrası', exampleSentence: 'They helped after the aftermath of the storm.', level: 'C1'),
    ];

    final learnedIds = learnedWords.map((word) => word.id).toSet();

    final List<WordModel> levelWords =
        allWords.where((word) => word.level == level).toList();

    final List<WordModel> unlearnedWords = levelWords
        .where((word) => !learnedIds.contains(word.id))
        .toList();

    if (unlearnedWords.isNotEmpty) {
      return unlearnedWords.take(count).toList();
    }

    // Eğer bu seviyedeki tüm kelimeler öğrenildiyse tekrar moduna geç
    levelWords.shuffle();
    return levelWords.take(count).toList();
  }

  static List<WordModel> learnedWords = [];

  static void addLearnedWord(WordModel word) {
    if (!learnedWords.any((w) => w.id == word.id)) {
      learnedWords.add(word);
    }
  }

  static List<WordModel> getLearnedWords() {
    return learnedWords;
  }
  static List<WordModel> getAllWordsByLevel(String level) {
  return getWordsByLevel(level, 1000);
}
}
