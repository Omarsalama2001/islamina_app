import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/data/models/quran_page.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:islamina_app/data/repository/quran_repository.dart';
import 'package:islamina_app/features/khatma/data/models/khatma_model.dart';
import 'package:islamina_app/utils/extension.dart';
import 'package:quran/quran.dart' as quran;

int calculateExpirationTimeOfKhatma(DateTime khatmaCreatedTime, int expectedPeriodOfKhatma) {
  DateTime now = DateTime.now();

  Duration difference = now.difference(khatmaCreatedTime);

  return expectedPeriodOfKhatma - difference.inDays;
}

int calculateDaysLeft(DateTime khatmaCreatedTime, int expectedPeriodOfKhatma) {
  return expectedPeriodOfKhatma - calculateExpirationTimeOfKhatma(khatmaCreatedTime, expectedPeriodOfKhatma);
}

String calculateKhatmeProgress(KhatmaModel khatmeModel) {
  final alreadyDoneUnits = khatmeModel.initialPage - 1;

  final expectedDoneUnits = khatmeModel.unitPerDay * calculateDaysLeft(khatmeModel.createdAt, khatmeModel.expectedPeriodOfKhatma);
  if (alreadyDoneUnits > expectedDoneUnits) {
    return 'انت متقدم';
  } else if (alreadyDoneUnits < expectedDoneUnits) {
    return 'انت متأخر';
  } else {
    return 'معدل طبيعي';
  }
}

getCurrentLanguage() {
  return BlocProvider.of<ThemeCubit>(Get.context!).locale.languageCode;
}

int calculatePercent(KhatmaModel khatmaModel) {
  return ((khatmaModel.initialPage / khatmaModel.valueOfUnit) * 100).toInt();
}

bool getDoneButtonActivationTime(DateTime lastModifiedTime, bool istaped) {
  DateTime now = DateTime.now();
  if (istaped == false) {
    return true;
  } else {
    if (now.difference(lastModifiedTime).inDays >= 1) {
      return true;
    } else {
      return false;
    }
  }
}

getInitialKhatmaVerse(int initialPage, String khatmaUnit) {
  final QuranPageModel page = mapInitialPositionToPage(khatmaUnit, initialPage);

  final pageData = quran.getPageData(page.pageNumber);
  final int surahIndex = pageData[0]['surah'];
  final surahName = BlocProvider.of<ThemeCubit>(Get.context!).locale.languageCode == 'ar' ? surahIndex.getSurahNameArabicSimple : surahIndex.getSurahNameEnglish;
  final firstVerse = pageData[0]['start'];
  final String initialKhatmaVerse = '${Get.context!.translate("from_surah")} $surahName ${Get.context!.translate("ayah")} $firstVerse - ${Get.context!.translate("page")} ${page.pageNumber}';
  return initialKhatmaVerse;
}

getLastKhatmaVerse(int lastPage, String khatmaUnit) {
  final QuranPageModel page = mapInitialPositionToPage(khatmaUnit, lastPage);

  final pageData = quran.getPageData(page.pageNumber);
  final int surahIndex = pageData[0]['surah'];
  final surahName = BlocProvider.of<ThemeCubit>(Get.context!).locale.languageCode == 'ar' ? surahIndex.getSurahNameArabicSimple : surahIndex.getSurahNameEnglish;
  final firstVerse = pageData[0]['start'];
  final String initialKhatmaVerse = '${Get.context!.translate("from_surah")} $surahName ${Get.context!.translate("ayah")} $firstVerse -  ${Get.context!.translate("page")} ${page.pageNumber}';
  return initialKhatmaVerse;
}

List<QuranPageModel?> quranForKhatma = [];
getAllQuranPages() async {
  for (int pageNumber = 1; pageNumber <= 604; pageNumber++) {
    QuranRepository quranRepository = QuranRepository();
    try {
      quranForKhatma.add(await quranRepository.getQuranPageData(pageNumber: pageNumber));
    } catch (e) {}
  }
}

mapInitialPositionToPage(String khatmaUnit, int initialPosition) {
  // Get.put(QuranReadingController());
  final allQuran = quranForKhatma;
  final QuranPageModel page;
  if (khatmaUnit == 'juz') {
    page = allQuran.firstWhere((element) => element!.juzNumber == initialPosition)!;
  } else if (khatmaUnit == 'hizb') {
    page = allQuran.firstWhere((element) => element!.hizbNumber == initialPosition)!;
  } else if (khatmaUnit == 'quarter_hizb') {
    page = allQuran.firstWhere((element) => element!.rubElHizbNumber == initialPosition)!;
  } else if (khatmaUnit == 'surah') {
    page = allQuran.firstWhere((element) => element!.surahNumber == initialPosition)!;
  } else {
    page = allQuran.firstWhere((element) => element!.pageNumber == initialPosition)!;
  }
  return page;
}

List<String> khatmaImages = [
  "assets/images/khatma_1.jpg",
  "assets/images/khatma_2.jpg",
  "assets/images/khatma_3.jpg",
  "assets/images/khatma_4.jpg",
];
String getKhatmaImage(String type) {
  if (type == 'save') {
    return khatmaImages[1];
  }
  if (type == 'RevisionofMemorization') {
    return khatmaImages[1];
  }
  if (type == 'Contemplation') {
    return khatmaImages[2];
  }
  if (type == 'Reading') {
    return khatmaImages[0];
  }
  return khatmaImages[3];
}

calculateLastThirdOfNight() {
  final prayerTimes = Get.find<PrayerTimeRepository>().prayerTimes;
  DateTime maghrib = prayerTimes!.maghrib;
  DateTime fajr = prayerTimes.fajr.add(const Duration(days: 1));

  Duration difference = fajr.difference(maghrib);
  Duration twoThirds = Duration(minutes: ((difference.inMinutes * 2) / 3).round());

  // وقت بدء الثلث الأخير
  DateTime lastThirdStart = maghrib.add(twoThirds);
  String formattedTime = _formatPrayerTime(lastThirdStart);
  return formattedTime;
}

calculateLastThirdOfNightNotificationTime() {
  final prayerTimes = Get.find<PrayerTimeRepository>().prayerTimes;
  DateTime maghrib = prayerTimes!.maghrib;
  DateTime fajr = prayerTimes.fajr.add(const Duration(days: 1));

  Duration difference = fajr.difference(maghrib);
  Duration twoThirds = Duration(minutes: ((difference.inMinutes * 2) / 3).round());
  // وقت بدء الثلث الأخير
  DateTime lastThirdStart = maghrib.add(twoThirds);

  return lastThirdStart;
}

calculateMidNightNotificationTime() {
  final prayerTimes = Get.find<PrayerTimeRepository>().prayerTimes;
  DateTime maghrib = prayerTimes!.maghrib;
  DateTime fajr = prayerTimes.fajr.add(const Duration(days: 1));
  Duration difference = fajr.difference(maghrib);
  Duration oneThird = Duration(
    minutes: (difference.inMinutes / 2).round(),
  );
  DateTime lastThirdStart = maghrib.add(oneThird);
  return lastThirdStart;
}

calculateMidNight() {
  final prayerTimes = Get.find<PrayerTimeRepository>().prayerTimes;
  DateTime maghrib = prayerTimes!.maghrib;
  DateTime fajr = prayerTimes.fajr.add(const Duration(days: 1));
  Duration difference = fajr.difference(maghrib);
  Duration oneThird = Duration(
    minutes: (difference.inMinutes / 2).round(),
  );
  DateTime lastThirdStart = maghrib.add(oneThird);
  String formattedTime = _formatPrayerTime(lastThirdStart);
  return formattedTime;
}

String _formatPrayerTime(DateTime prayerTime) {
  String time = DateFormat.jm().format(prayerTime);
  return time.replaceAll('AM', '').replaceAll('PM', '');
}
