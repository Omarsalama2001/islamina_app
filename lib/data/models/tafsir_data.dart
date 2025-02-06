import 'package:get/get.dart';
import 'package:islamina_app/data/repository/tafsir_repository.dart';

class Edition {
  String identifier;
  String name;
  String englishName;

  Edition({
    required this.identifier,
    required this.name,
    required this.englishName,
  });

  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
      identifier: json['identifier'],
      name: json['name'],
      englishName: json['englishName'],
    );
  }
}

class TafsirData {
  RxList<List<String>> tafsirLists;
  // Edition edition;

  TafsirData({
    required this.tafsirLists,
    // required this.edition,
  });

  factory TafsirData.fromJson(Map<String, dynamic> json) {
    List<RxList<String>> tafsirLists = [];
    if (json['quran'] != null) {
   
      // Convert the Map to an Iterable
      Iterable<dynamic> surahTextsData = json['quran'] ['ar.muyassar'].values;
      int currentSurah = 1;
      RxList<String> surahTexts = RxList<String>();

      for (var item in surahTextsData) {
        // تحقق إذا كان العنصر عبارة عن خريطة
        if (item is Map<String, dynamic>) {
          String verseText = item['verse'];
          // print(verseText);

          if (currentSurah == item['surah']) {
            surahTexts.add(verseText);
            if (currentSurah == 114 && surahTexts.length == 5) {
              tafsirLists.add(surahTexts);
            }
          } else if (currentSurah == item['surah']) {
            surahTexts.add(verseText);
            tafsirLists.add(surahTexts);
          } else {
            tafsirLists.add(surahTexts);
            surahTexts = RxList<String>();
            surahTexts.add(verseText);
            currentSurah++;
          }
        } else {
          // Handle non-Map items (optional)
        }
      }
    }
    return TafsirData(
      tafsirLists: tafsirLists.obs,
      // edition: Edition.fromJson(json['edition']),
    );
  }
}
