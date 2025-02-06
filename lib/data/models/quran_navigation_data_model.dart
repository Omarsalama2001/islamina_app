import 'package:islamina_app/features/khatma/data/models/khatma_model.dart';

class QuranNavigationArgumentModel {
  int surahNumber;
  int pageNumber;
  int verseNumber;
  bool highlightVerse;
  bool isKhatma;
  KhatmaModel? khatmaModel;
  QuranNavigationArgumentModel({
    required this.surahNumber,
    required this.pageNumber,
    required this.verseNumber,
    required this.highlightVerse,
    required this.isKhatma,
    this.khatmaModel,
  });
}
