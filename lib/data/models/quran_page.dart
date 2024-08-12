import 'package:islamina_app/data/models/quran_verse_model.dart';

class QuranPageModel {
  final int pageNumber;
  final int hizbNumber;
  final int juzNumber;
  final int rubElHizbNumber;
  final int surahNumber;
  final List<QuranVerseModel> verses;

  QuranPageModel({
    required this.hizbNumber,
    required this.juzNumber,
    required this.rubElHizbNumber,
    required this.pageNumber,
    required this.verses,
    required this.surahNumber,
  });

  QuranPageModel copyWith({
    final int? pageNumber,
    final int? hizbNumber,
    final int? juzNumber,
    final int? rubElHizbNumber,
    final int? surahNumber,
    final List<QuranVerseModel>? verses,
  }) {
    return QuranPageModel(
      pageNumber: pageNumber ?? this.pageNumber,
      hizbNumber: hizbNumber ?? this.hizbNumber,
      juzNumber: juzNumber ?? this.juzNumber,
      rubElHizbNumber: rubElHizbNumber ?? this.rubElHizbNumber,
      surahNumber: surahNumber ?? this.surahNumber,
      verses: verses ?? this.verses,
    );
  }
}
